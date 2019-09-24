#include <SDKDDKVer.h>

#include <cstdlib>
#include <cstring>
#include <iostream>
#include <boost/asio.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/lambda/bind.hpp>
#include <boost/thread/thread.hpp> 
#include <boost/chrono/chrono.hpp>
#include <boost/array.hpp>
#include <boost/bind.hpp>

using boost::asio::ip::udp;

class ImageMetadata
{
public:
	static const int NUM_CONDITIONS = 4;

	unsigned int frameNumber;
	unsigned int trialId;
	unsigned int conditionId;
	bool conditionsToDecode[NUM_CONDITIONS];
	bool usable;
	bool training;
	bool reset;

	unsigned int lines, pixels, samples, channels;

	ImageMetadata()
		:frameNumber(0), trialId(0), conditionId(0), usable(false), training(false), reset(true),
		lines(0), pixels(0), samples(0), channels(0), conditionsToDecode{ false, false, false, false }
	{
	}
};

class DecoderUpdate
{
public:
	uint16_t conditionDecoded;
	double log_likelihoods[ImageMetadata::NUM_CONDITIONS];
	std::string description;

	DecoderUpdate()
		:conditionDecoded(0), log_likelihoods{ 0,0,0,0 }, description("")
	{
	}
};

std::ostream &operator<<(std::ostream &os, ImageMetadata const &m) {
	return os << "ImageMetadata[frame=" << m.frameNumber << ",trialId=" << m.trialId << ",conditionId=" << m.conditionId
		<< ",usable=" << m.usable << ",training=" << m.training << ",reset=" << m.reset
		<< ",lines=" << m.lines << ",pixels=" << m.pixels << ",samples=" << m.samples << ",channels=" << m.channels;
}

class SimulinkUdpHandler
{
public:
	static constexpr  const char* IP_ADDR_SEND_TO = "192.168.20.2";
	static const int UDP_PORT_RECV_AT = 10001;
	static constexpr const char* UDP_PORT_SEND_TO = "10002";

private:
	std::unique_ptr<boost::asio::io_service> io_service_;
	udp::resolver resolver_;
	udp::socket socket_recv_;
	udp::socket socket_send_;

	udp::endpoint local_endpoint_;
	udp::endpoint remote_endpoint_;
	udp::endpoint sender_endpoint_;
	std::vector<char> send_buffer_;
	std::vector<char> recv_buffer_;

	ImageMetadata metadata_;

	bool pollThreadRunning_;
	boost::thread* ptrPollThread_;

	boost::mutex mutex_;

	bool verbose_;
	bool connected_;

public:
	SimulinkUdpHandler()
		: io_service_(new boost::asio::io_service()), socket_recv_(*io_service_), socket_send_(*io_service_),
		resolver_(*io_service_), connected_(false),
		send_buffer_(1024), recv_buffer_(1024), 
		pollThreadRunning_(false), ptrPollThread_(NULL)
	{
	}

	void setVerbose(bool tf)
	{
		verbose_ = tf;
	}

	bool startPollingThread()
	{
		try {
			if (!pollThreadRunning_) {
				bool tf = connect();
				if (!tf)
					return false;
				ptrPollThread_ = new boost::thread(boost::bind(&SimulinkUdpHandler::pollingThreadFn, this));
				HANDLE hThread = ptrPollThread_->native_handle();
				BOOL success = SetThreadPriority(hThread, THREAD_PRIORITY_HIGHEST);
				if (!success)
					std::cerr << "Error setting polling thread priority\n";
			}
			return true;
		}
		catch (std::exception& e)
		{
			std::cerr << "Error starting polling thread: " << e.what() << "\n";
			pollThreadRunning_ = false;
			return false;
		}
	}

	void stopPollingThread()
	{
		if (pollThreadRunning_) {
			io_service_->stop();
			socket_recv_.cancel();
			ptrPollThread_->join();
			pollThreadRunning_ = false; // just in case
			delete ptrPollThread_;
		}
	}

	void pollingThreadFn()
	{
		try {
			pollThreadRunning_ = true;
			if(verbose_)
				std::cout << "Simulink UDP polling thread launched\n";

			start_receive();
			
			auto work = std::make_shared<boost::asio::io_service::work>(*io_service_);
			io_service_->run(); // will block until sockets close
			
			if (verbose_)
				std::cout << "Finished ioservice::run. disconnecting...\n";
			disconnect();

			pollThreadRunning_ = false;
		}
		catch (std::exception& e)
		{
			std::cerr << "Error during Simulink UDP polling thread: " << e.what() << "\n";
			pollThreadRunning_ = false;
			return;
		}
	}

	void send_update(const DecoderUpdate &update)
	{
		send_buffer_.clear();
		const char* src;
		send_buffer_.push_back('#');
		send_buffer_.push_back('U');
		src = reinterpret_cast<const char*>(&update.conditionDecoded);
		send_buffer_.insert(send_buffer_.end(), src, src + sizeof(uint16_t));
		src = reinterpret_cast<const char*>(&update.log_likelihoods[0]);
		send_buffer_.insert(send_buffer_.end(), src, src + ImageMetadata::NUM_CONDITIONS*sizeof(double));
		src = (const char*)(update.description.data());
		send_buffer_.insert(send_buffer_.end(), src, src + update.description.length());

		std::cout << "Attempting to send " << send_buffer_.size() << " bytes\n";
		send_contents_of_send_buffer();
	}

private:
	bool connect()
	{
		try {
			if (connected_)
				return true;
			if (verbose_)
				std::cout << "Simulink UDP connecting\n";
			local_endpoint_ = udp::endpoint(boost::asio::ip::address_v4::any(), SimulinkUdpHandler::UDP_PORT_RECV_AT);

			udp::resolver::query query(udp::v4(), SimulinkUdpHandler::IP_ADDR_SEND_TO, SimulinkUdpHandler::UDP_PORT_SEND_TO);
			remote_endpoint_ = *resolver_.resolve(query);

			boost::system::error_code ec;
			socket_recv_.open(udp::v4(), ec);
			if (ec)
				throw std::runtime_error("Error opening receive socket");

			socket_recv_.set_option(boost::asio::socket_base::broadcast(true));
			if (ec)
				throw std::runtime_error("Error setting SO_BROADCAST");

			socket_recv_.set_option(udp::socket::reuse_address(true));
			if (ec)
				throw std::runtime_error("Error setting SO_REUSEADDR");

			socket_recv_.bind(local_endpoint_, ec);
			if (ec) {
				std::cerr << "Error binding local port: " << ec.message() << " [" << ec.category().name() << ":" << ec.value() << "]" << std::endl;
				throw std::runtime_error("Error binding local port");
			}

			socket_send_.open(udp::v4(), ec);
			if (ec)
				throw std::runtime_error("Error opening send socket");

			socket_send_.set_option(boost::asio::socket_base::broadcast(true));
			if (ec)
				throw std::runtime_error("Error setting SO_BROADCAST on send socket");

			socket_send_.set_option(udp::socket::reuse_address(true));
			if (ec)
				throw std::runtime_error("Error setting SO_REUSEADDR on send socket");

			socket_send_.connect(remote_endpoint_, ec);
			if (ec) {
				std::cerr << "Error connecting to remote port: " << ec.message() << " [" << ec.category().name() << ":" << ec.value() << "]" << std::endl;
				throw std::runtime_error("Error connecting to remote port");
			}

			if (verbose_)
				std::cout << "UDP Connection successful\n";
			connected_ = true;
			return true;
		}
		catch (std::exception& e)
		{
			std::cerr << "Error connecting to Simulink UDP: " << e.what() << "\n";
			connected_ = false;
			return false;
		}
	}

	void disconnect()
	{
		if (!connected_)
			return;

		boost::system::error_code ignored_ec;
		socket_recv_.shutdown(boost::asio::ip::tcp::socket::shutdown_both, ignored_ec);
		socket_recv_.close(ignored_ec);
		socket_send_.shutdown(boost::asio::ip::tcp::socket::shutdown_both, ignored_ec);
		socket_send_.close(ignored_ec);
	}

	void send_contents_of_send_buffer()
	{
		if(verbose_)
			std::cout << "Command to send " << send_buffer_.size() << " bytes\n";
		socket_send_.async_send_to(boost::asio::buffer(send_buffer_, send_buffer_.size()), remote_endpoint_,
			boost::bind(&SimulinkUdpHandler::handle_send, this,
				boost::asio::placeholders::error,
				boost::asio::placeholders::bytes_transferred));
	}

	void start_receive()
	{
		socket_recv_.async_receive_from(
			boost::asio::buffer(recv_buffer_), sender_endpoint_,
			boost::bind(&SimulinkUdpHandler::handle_receive, this,
				boost::asio::placeholders::error,
				boost::asio::placeholders::bytes_transferred));
	}

	void handle_receive(const boost::system::error_code& error, std::size_t bytes)
	{
		if (!error || error == boost::asio::error::message_size)
		{
			if (recv_buffer_[0] == '#' && recv_buffer_[1] == 'D') {
				unsigned int bp = 2;
				// valid prefix, parse the contents
				metadata_.trialId = *reinterpret_cast<const uint32_t*>(&recv_buffer_[bp]); 
				bp += 4;
				metadata_.conditionId = *reinterpret_cast<const uint16_t*>(&recv_buffer_[bp]);
				bp += 2;
				for (unsigned c = 0; c < ImageMetadata::NUM_CONDITIONS; c++)
				{
					metadata_.conditionsToDecode[c] = *reinterpret_cast<const bool*>(&recv_buffer_[bp]);
					bp++;
				}
				if (recv_buffer_[bp])
					metadata_.usable = true;
				else
					metadata_.usable = false;
				bp++;
				if (recv_buffer_[bp])
					metadata_.training = true;
				else
					metadata_.training = false;
				bp++;
				if (recv_buffer_[bp])
					metadata_.reset = true;
				else
					metadata_.reset = false;
				bp++;

				if (verbose_)
					std::cout << "UDP received metadata: " << metadata_ << std::endl;
			}
			else
			{
				std::cout << "Simulink UDP: Received invalid UDP packet\n";
			}
		}
		else {
			std::cout << "Simulink UDP: Received error during receive" << std::endl;
		}
		start_receive();
	}

	void handle_send(const boost::system::error_code& ec, std::size_t bytes)
	{
		if(ec)
			std::cerr << "Simulink UDP: Error sending packet: " << ec.message() << " [" << ec.category().name() << ":" << ec.value() << "]" << std::endl;
	}

};


int main()
{
	SimulinkUdpHandler udp;

	try {
		udp.setVerbose(true);
		udp.startPollingThread();

		for(unsigned i = 0; i < 10; i++)
		{
			DecoderUpdate update;
			update.conditionDecoded = 3;
			update.log_likelihoods[0] = -4 + (double)i;
			update.log_likelihoods[1] = -3 + (double)i;
			update.log_likelihoods[2] = -2 + (double)i;
			update.log_likelihoods[3] = -1 + (double)i;
			update.description = "hello";
			udp.send_update(update);
			boost::this_thread::sleep_for(boost::chrono::seconds(2));
		}

		udp.stopPollingThread();

		system("pause");
		return 0;
	}
	catch (std::exception& e)
	{
		std::cerr << "Error occurred in main: " << e.what() << "\n";
		udp.stopPollingThread();
		system("pause");
		return 1;
	}
}


