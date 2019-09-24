// see http://www.boost.org/doc/libs/1_64_0/doc/html/boost_asio/example/cpp03/timeouts/blocking_tcp_client.cpp for info on timeouts
#include <SDKDDKVer.h>

#include <cstdlib>
#include <cstring>
#include <iostream>
#include <boost/asio.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/lambda/bind.hpp>
#include <boost/lambda/lambda.hpp>
#include <boost/thread/thread.hpp>
#include <boost/thread/recursive_mutex.hpp>
#include <boost/chrono/chrono.hpp>

#include "CPrairieStream.h"

using boost::asio::ip::tcp;
using boost::asio::ip::udp;
using boost::asio::deadline_timer;
using boost::lambda::bind;

namespace PrairieStream {
	// timing utilities

	class ElapsedTime
	{
	public:
		static boost::chrono::high_resolution_clock::time_point timeRef;
		
		static void resetTimeReference()
		{
			ElapsedTime::timeRef = boost::chrono::high_resolution_clock::now();
		}

		static int64_t getElapsedMs()
		{
			auto now = boost::chrono::high_resolution_clock::now();
			auto elapsed = boost::chrono::duration_cast<boost::chrono::milliseconds>(now - ElapsedTime::timeRef);
			return elapsed.count();
		}

	};
	boost::chrono::high_resolution_clock::time_point ElapsedTime::timeRef = boost::chrono::high_resolution_clock::now();
	
	// handles raw communication with PrairieView
	class PrairieSession
	{

	private:
		boost::asio::io_service& io_service_;
		tcp::resolver::iterator iterator_;
		tcp::socket socket_;
		deadline_timer deadline_;
		boost::asio::streambuf input_buffer_;
		boost::recursive_mutex mutex_;

		boost::posix_time::time_duration timeout_;
		int num_retries_;
		bool verbose_;

	public:
		PrairieSession(boost::asio::io_service& io_service)
			: socket_(io_service), io_service_(io_service), deadline_(io_service)
		{
			num_retries_ = 3;
			verbose_ = false;
		}

		~PrairieSession()
		{
			disconnect();
		}

		bool is_connected()
		{
			return socket_.is_open();
		}

		void setVerbose(bool verbose)
		{
			verbose_ = verbose;
		}

		void setTimeout(int seconds)
		{
			timeout_ = boost::posix_time::seconds(seconds);
		}

		static std::string streambuf_to_string(boost::asio::streambuf& streambuf)
		{
			return{ buffers_begin(streambuf.data()),
				buffers_end(streambuf.data()) };
		}

		static std::string get_separator()
		{
			return std::string("\1", 1);
		}

		bool connect()
		{
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);
			if (is_connected())
				return true;

			if(verbose_)
				std::cout << "Connecting to PrairieView\n";

			tcp::resolver resolver(io_service_);
			tcp::resolver::query query(tcp::v4(), "localhost", "1236");
			iterator_ = resolver.resolve(query);

			timeout_ = boost::posix_time::seconds(1);

			// No deadline is required until the first socket operation is started. We
			// set the deadline to positive infinity so that the actor takes no action
			// until a specific deadline is set.
			deadline_.expires_at(boost::posix_time::pos_infin);

			// Start the persistent actor that checks for deadline expiry.
			check_deadline();

			// Set a deadline for the asynchronous operation. As a host name may
			// resolve to multiple endpoints, this function uses the composed operation
			// async_connect. The deadline applies to the entire operation, rather than
			// individual connection attempts.
			deadline_.expires_from_now(timeout_);

			// Set up the variable that receives the result of the asynchronous
			// operation. The error code is set to would_block to signal that the
			// operation is incomplete. Asio guarantees that its asynchronous
			// operations will never fail with would_block, so any other value in
			// ec indicates completion.
			boost::system::error_code ec = boost::asio::error::would_block;

			// Start the asynchronous operation itself. The boost::lambda function
			// object is used as a callback and will update the ec variable when the
			// operation completes. The blocking_udp_client.cpp example shows how you
			// can use boost::bind rather than boost::lambda.
			socket_.open(tcp::v4());
			socket_.set_option(tcp::no_delay(true), ec);
			if (ec)
				throw std::runtime_error("Error setting TCP NODELAY");
			socket_.set_option(tcp::socket::reuse_address(true), ec);
			if (ec)
				throw std::runtime_error("Error setting SO_REUSEADDR");
			boost::asio::async_connect(socket_, iterator_, boost::lambda::var(ec) = boost::lambda::_1);

			// Block until the asynchronous operation has completed.
			do io_service_.run_one(); while (ec == boost::asio::error::would_block);

			// Determine whether a connection was successfully established. The
			// deadline actor may have had a chance to run and close our socket, even
			// though the connect operation notionally succeeded. Therefore we must
			// check whether the socket is still open before deciding if we succeeded
			// or failed.
			if (ec || !socket_.is_open())
				throw boost::system::system_error(
					ec ? ec : boost::asio::error::operation_aborted);

			flushRead();

			return true;
		}

		void disconnect()
		{
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);
			if (is_connected()) {
				sendAndWaitDone(std::string("-x"));
				boost::system::error_code ignored_ec;
				socket_.shutdown(boost::asio::ip::tcp::socket::shutdown_both, ignored_ec);
				socket_.close(ignored_ec);
			}
		}

	private:
		void flushRead()
		{
			connect();
			while (true)
			{
				auto bytes = socket_.available();
				if (bytes > 0) {
					const int max_length = 1000;
					char buffer[max_length];
					boost::asio::read(socket_, boost::asio::buffer(buffer, bytes));
				}
				else
					break;
			}
		}

		bool read_line(std::string& line)
		{
			// Set a deadline for the asynchronous operation. Since this function uses
			// a composed operation (async_read_until), the deadline applies to the
			// entire operation, rather than individual reads from the socket.
			deadline_.expires_from_now(timeout_);

			// Set up the variable that receives the result of the asynchronous
			// operation. The error code is set to would_block to signal that the
			// operation is incomplete. Asio guarantees that its asynchronous
			// operations will never fail with would_block, so any other value in
			// ec indicates completion.
			boost::system::error_code ec = boost::asio::error::would_block;

			// Start the asynchronous operation itself. The boost::lambda function
			// object is used as a callback and will update the ec variable when the
			// operation completes. The blocking_udp_client.cpp example shows how you
			// can use boost::bind rather than boost::lambda.
			boost::asio::async_read_until(socket_, input_buffer_, '\n', boost::lambda::var(ec) = boost::lambda::_1);

			// Block until the asynchronous operation has completed.
			do io_service_.run_one(); while (ec == boost::asio::error::would_block);

			if (ec) {
				std::cout << "Error reading from socket. " << ec.message() << " [" << ec.category().name() << ":" << ec.value() << "]" << std::endl;
				return false;
			}
			else
			{
				std::istream is(&input_buffer_);
				std::getline(is, line);
				boost::algorithm::trim_right(line); // remove trailing \r
				return true;
			}
		}

		bool write_line(const std::string& line)
		{
			std::string data = line + "\r\n";

			// Set a deadline for the asynchronous operation. Since this function uses
			// a composed operation (async_write), the deadline applies to the entire
			// operation, rather than individual writes to the socket.
			deadline_.expires_from_now(timeout_);

			// Set up the variable that receives the result of the asynchronous
			// operation. The error code is set to would_block to signal that the
			// operation is incomplete. Asio guarantees that its asynchronous
			// operations will never fail with would_block, so any other value in
			// ec indicates completion.
			boost::system::error_code ec = boost::asio::error::would_block;

			// Start the asynchronous operation itself. The boost::lambda function
			// object is used as a callback and will update the ec variable when the
			// operation completes. The blocking_udp_client.cpp example shows how you
			// can use boost::bind rather than boost::lambda.
			boost::asio::async_write(socket_, boost::asio::buffer(data), boost::lambda::var(ec) = boost::lambda::_1);

			// Block until the asynchronous operation has completed.
			do io_service_.run_one(); while (ec == boost::asio::error::would_block);

			if (ec) {
				std::cout << "Error writing to socket. " << ec.message() << "[" << ec.category().name() << ":" << ec.value() << "]" << std::endl;
				return false;
			}

			return true;
		}

	public:
		std::string sendAndWaitReply(std::string& output, bool expectDone = true)
		{
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);
			bool tf = false, hasAck = false, hasDone = false;
			std::string line;
			std::string reply;

			flushRead();

			// sends command and awaits ACK, up to max_retries times
			for (int i = 0; i < num_retries_; i++)
			{
				if (verbose_) {
					if (i > 0)
						std::cout << "Resend attempt " << i << " of " << num_retries_ << std::endl;
					else
						std::cout << "Sending cmd " << output << std::endl;
				}
				tf = write_line(output); // will print error code
				if (!tf) {
					return "";
				}

				tf = read_line(line);
				if (verbose_) {
					if (tf)
						std::cout << "Received line: " << line << std::endl;
					else
						std::cout << "No reply in timeout" << std::endl;
				}

				if (tf && !line.compare(0, 3, "ACK")) {
					hasAck = true;
					break;
				}
			}

			if (!hasAck)
				return "";

			if (expectDone) {
				for (int i = 0; i < num_retries_; i++)
				{
					tf = read_line(line);
					if (verbose_) {
						if (tf)
							std::cout << "Received line: " << line << std::endl;
						else
							std::cout << "No reply in timeout" << std::endl;
					}

					if (tf) {
						if (line.compare(0, 4, "DONE"))
							reply = line;
						else {
							hasDone = true;
							break;
						}
					}
				}
				if (reply.length() == 0)
					return "DONE";
				else
					return reply;
			}
			else // some commands like -stop don't seem to send a DONE, only ack
				return "ACK";
		}

		bool sendAndWaitReplyUInt(std::string& output, unsigned int& value)
		{
			std::string reply;
			int valueS = 0;
			value = 0;
			for (int i = 0; i < num_retries_; i++)
			{
				reply = sendAndWaitReply(output);
				if (reply.length() > 0) 
				{
					try
					{
						valueS = std::stoi(reply);
					}
					catch (std::exception&)
					{
						std::cout << "Error: Reply was " << reply << " expecting int\n";
						return false;
					}
					
					if (valueS < 0) 
					{
						continue;
					}
					else 
					{
						value = (unsigned int)valueS;
						return true;
					}
				}
			}
			return false;
		}

		bool sendAndWaitReplyBool(std::string& output, bool& tfResponse)
		{
			std::string reply;
			tfResponse = false;
			reply = sendAndWaitReply(output);
			for (int i = 0; i < num_retries_; i++)
			{
				if (reply.length() > 0) 
				{
					if (boost::algorithm::iequals(reply, "true")) 
					{
						tfResponse = true;
						return true;
					}
					else if (boost::algorithm::iequals(reply, "false")) 
					{
						tfResponse = false;
						return true;
					}
				}
			}
				
			return false;
		}

		bool sendAndWaitDone(std::string& output)
		{
			std::string reply;
			reply = sendAndWaitReply(output);
			return reply.length() > 0;
		}

		bool sendAndWaitAckOnly(std::string& output)
		{
			return sendAndWaitReply(output, false).length() > 0; // don't wait for DONE, reply will be "ACK"
		}

		std::string queryState(const std::string &key, const std::string &index = std::string(), const std::string &subindex = std::string())
		{
			std::string reply;
			std::string sep = PrairieSession::get_separator();
			std::string output = std::string("-gts") + sep + key;
			if (index.length() > 0)
			{
				output += sep + index;
				if (subindex.length() > 0)
				{
					output += sep + subindex;
				}
			}

			reply = sendAndWaitReply(output);
			//std::cout << "Returned from setAndWaitReply, assigning into reply\n";
			return reply;
		}

		bool queryStateUInt(unsigned int& value, const std::string &key, const std::string &index = std::string(), const std::string &subindex = std::string())
		{
			std::string reply;
			int valueS = 0;
			reply = queryState(key, index, subindex);
			if (reply.length() > 0) {
				valueS = std::stoi(reply);
				if (valueS < 0) {
					value = 0;
					return false;
				}
				else {
					value = (unsigned int)valueS;
					return true;
				}
			}
			else
				return false;
		}

		bool sendAcceptCommandsDuringScan()
		{
			return sendAndWaitDone(std::string("-dw"));
		}

		bool sendLimitBufferSize(unsigned short bufSize)
		{
			std::ostringstream oss;
			std::string sep = PrairieSession::get_separator();
			oss << "-lbs" << sep << "true" << sep << bufSize;
			std::string cmd = oss.str();
			return sendAndWaitDone(cmd);
		}

		bool sendNoLimitBufferSize()
		{
			std::ostringstream oss;
			std::string sep = PrairieSession::get_separator();
			oss << "-lbs" << sep << "false";
			std::string cmd = oss.str();
			return sendAndWaitDone(cmd);
		}

		bool sendStartRawDataStreaming(unsigned short bufferFrames)
		{
			std::ostringstream oss;
			std::string sep = PrairieSession::get_separator();
			oss << "-srd" << sep << "True" << sep << bufferFrames;
			std::string cmd = oss.str();
			return sendAndWaitDone(cmd);
		}

		bool sendStopRawDataStreaming()
		{
			std::ostringstream oss;
			std::string sep = PrairieSession::get_separator();
			oss << "-srd" << sep << "False";
			std::string cmd = oss.str();
			return sendAndWaitDone(cmd);
		}

		bool sendStartLiveScan()
		{
			return sendAndWaitDone(std::string("-lv"));
		}

		bool sendStartTSeries()
		{
			return sendAndWaitDone(std::string("-ts"));
		}

		bool sendNoWait()
		{
			return sendAndWaitDone(std::string("-nw"));
		}

		bool setSavePath(const std::string& path)
		{
			if (path.find_first_of(' ') != std::string::npos)
			{
				std::cout << "Save path must not contain spaces\n";
				return false;
			}
			std::ostringstream oss;
			std::string sep = PrairieSession::get_separator();
			oss << "-SetSavePath" << sep << path;
			std::string cmd = oss.str();
			return sendAndWaitDone(cmd);
		}

		bool setTSeriesName(const std::string& name)
		{
			if (name.find_first_of(' ') != std::string::npos)
			{
				std::cout << "File name must not contain spaces\n";
				return false;
			}
			std::ostringstream oss;
			std::string sep = PrairieSession::get_separator();
			oss << "-SetFileName" << sep << "Tseries" << sep << name;
			std::string cmd = oss.str();
			return sendAndWaitDone(cmd);
		}

		bool setSingleImageName(const std::string& name)
		{
			if (name.find_first_of(' ') != std::string::npos)
			{
				std::cout << "File name must not contain spaces\n";
				return false;
			}
			std::ostringstream oss;
			std::string sep = PrairieSession::get_separator();
			oss << "-SetFileName" << sep << "Singlescan" << sep << name;
			std::string cmd = oss.str();
			return sendAndWaitDone(cmd);
		}

		bool sendStopScan()
		{
			return sendAndWaitAckOnly(std::string("-stop"));
		}

		bool querySamplesPerPixel(unsigned int& samples)
		{
			return sendAndWaitReplyUInt(std::string("-spp"), samples);
		}

		bool queryDroppedData(bool& tf)
		{
			return sendAndWaitReplyBool(std::string("-dd"), tf);
		}

	private:
		void check_deadline()
		{
			// Check whether the deadline has passed. We compare the deadline against
			// the current time since a new asynchronous operation may have moved the
			// deadline before this actor had a chance to run.
			if (deadline_.expires_at() <= deadline_timer::traits_type::now())
			{
				std::cout << "Timeout hit waiting for reply!" << std::endl;

				// The deadline has passed. The socket is closed so that any outstanding
				// asynchronous operations are cancelled. This allows the blocked
				//// connect(), read_line() or write_line() functions to return.

				boost::system::error_code ignored_ec;
				socket_.cancel(ignored_ec);

				// There is no longer an active deadline. The expiry is set to positive
				// infinity so that the actor takes no action until a new deadline is set.
				deadline_.expires_at(boost::posix_time::pos_infin);
			}

			// Put the actor back to sleep.
			deadline_.async_wait(bind(&PrairieSession::check_deadline, this));
		}
	};

	// wraps information sent back to Simulink
	class DecoderUpdate
	{
	public:
		uint16_t conditionDecoded;
		std::array<double, ImageMetadata::NUM_CONDITIONS> log_likelihoods;
		std::string description;

		DecoderUpdate()
			:conditionDecoded(0), log_likelihoods(), description("")
		{
		}

		DecoderUpdate(uint16_t _conditionDecoded, const double _log_likelihoods[ImageMetadata::NUM_CONDITIONS], const std::string& _desc)
			:conditionDecoded(_conditionDecoded), description(_desc)
		{
			for (unsigned i = 0; i < log_likelihoods.size(); i++)
				log_likelihoods[i] = _log_likelihoods[i];
		}
	};

	// pretty print for DecoderUpdate
	std::ostream &operator<<(std::ostream &os, ImageMetadata const &m) {
		return os << "ImageMetadata[frame=" << m.frameNumber << ",trialId=" << m.trialId << ",conditionId=" << m.conditionId
			<< ",usable=" << m.usable << ",training=" << m.training << ",reset=" << m.reset << ", saveTag=" << m.saveTag
			<< ",lines=" << m.lines << ",pixels=" << m.pixels << ",samples=" << m.samples << ",channels=" << m.channels;
	}

	// handles bi-directional Simulink UDP communication and tracks current ImageMetadata
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
		std::array<char, 1024> recv_buffer_;

		ImageMetadata metadata_;

		bool pollThreadRunning_;
		std::unique_ptr<boost::thread> ptrPollThread_;

		boost::recursive_mutex mutex_;

		bool verbose_;
		bool connected_;

	public:
		SimulinkUdpHandler()
			: io_service_(new boost::asio::io_service()), socket_recv_(*io_service_), socket_send_(*io_service_),
			resolver_(*io_service_), metadata_(), 
			send_buffer_(1024), connected_(false),
			pollThreadRunning_(false)
		{
		}

		~SimulinkUdpHandler()
		{
			stopPollingThread();
		}

		void setVerbose(bool tf)
		{
			verbose_ = tf;
		}

		bool startPollingThread()
		{
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);
			try {
				if (!pollThreadRunning_) {
					bool tf = connect();
					if (!tf)
						return false;
					if (verbose_)
						std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "UDP: Starting UDP polling thread\n";
					ptrPollThread_.reset(new boost::thread(boost::bind(&SimulinkUdpHandler::pollingThreadFn, this)));
					//HANDLE hThread = ptrPollThread_->native_handle();
					//BOOL success = SetThreadPriority(hThread, THREAD_PRIORITY_ABOVE_NORMAL);
					//if (!success)
					//	std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Error setting polling thread priority\n";
					if (verbose_)
						std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "UDP: Elevated polling thread priority\n";
				}
				return true;
			}
			catch (std::exception& e)
			{
				std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Error starting polling thread: " << e.what() << "\n";
				pollThreadRunning_ = false;
				ptrPollThread_.release();
				return false;
			}
		}

		void stopPollingThread()
		{
			// DONT LOCK MUTEX HERE
			if (pollThreadRunning_) 
			{
				if(verbose_)
					std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Stopping UDP polling thread\n";
				
				io_service_->stop();
				
				if (verbose_)
					std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "UDP io service stopped\n";
				if (ptrPollThread_ != NULL) {
					ptrPollThread_->join();
					ptrPollThread_.release();
				}
				pollThreadRunning_ = false; // just in case
			}
		}

		void sendDecoderUpdate(const DecoderUpdate &update)
		{
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);
			send_buffer_.clear();
			const char* src;
			send_buffer_.push_back('#');
			send_buffer_.push_back('U');
			src = reinterpret_cast<const char*>(&update.conditionDecoded);
			send_buffer_.insert(send_buffer_.end(), src, src + sizeof(uint16_t));
			src = reinterpret_cast<const char*>(&update.log_likelihoods[0]);
			send_buffer_.insert(send_buffer_.end(), src, src + ImageMetadata::NUM_CONDITIONS * sizeof(double));
			src = (const char*)(update.description.data());
			send_buffer_.insert(send_buffer_.end(), src, src + update.description.length());

			if(verbose_)
				std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Attempting to send " << send_buffer_.size() << " bytes\n";
			send_contents_of_send_buffer();
		}

		void getMostRecentMetadata(ImageMetadata &meta) {
			meta = metadata_;
		}

	private:
		// we use connect and disconnect here internally, they are called by start and stop polling thread
		bool connect()
		{
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);
			try {
				if (connected_)
					return true;
				if (verbose_)
					std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Simulink UDP connecting\n";
				local_endpoint_ = udp::endpoint(boost::asio::ip::address_v4::any(), SimulinkUdpHandler::UDP_PORT_RECV_AT);

				udp::resolver::query query(udp::v4(), SimulinkUdpHandler::IP_ADDR_SEND_TO, SimulinkUdpHandler::UDP_PORT_SEND_TO);
				remote_endpoint_ = *resolver_.resolve(query);

				boost::system::error_code ec;
				socket_recv_.open(udp::v4(), ec);
				if (ec)
					throw std::runtime_error("Error opening receive socket");

				socket_recv_.set_option(boost::asio::socket_base::broadcast(true), ec);
				if (ec)
					throw std::runtime_error("Error setting SO_BROADCAST");

				socket_recv_.set_option(udp::socket::reuse_address(true), ec);
				if (ec)
					throw std::runtime_error("Error setting SO_REUSEADDR");

				socket_recv_.bind(local_endpoint_, ec);
				if (ec) {
					std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Error binding local port: " << ec.message() << " [" << ec.category().name() << ":" << ec.value() << "]" << std::endl;
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
					std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Error connecting to remote port: " << ec.message() << " [" << ec.category().name() << ":" << ec.value() << "]" << std::endl;
					throw std::runtime_error("Error connecting to remote port");
				}

				if (verbose_)
					std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "UDP Connection successful\n";
				connected_ = true;
				return true;

				// DO NOT CALL START POLLING THREAD HERE - IT CALLS US
			}
			catch (std::exception& e)
			{
				std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Error connecting to Simulink UDP: " << e.what() << "\n";
				connected_ = false;
				return false;
			}
		}

		void disconnect()
		{
			// DO NOT CALL STOP POLLING THREAD - IT WILL CALL HERE
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);
			if (!connected_)
				return;

			if (verbose_)
				std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Disconnecting from UDP ports\n";
			try
			{
				boost::system::error_code ignored_ec;
				socket_recv_.shutdown(boost::asio::ip::tcp::socket::shutdown_both, ignored_ec);
				socket_recv_.close(ignored_ec);
				socket_send_.shutdown(boost::asio::ip::tcp::socket::shutdown_both, ignored_ec);
				socket_send_.close(ignored_ec);
				connected_ = false;
			}
			catch (std::exception& e)
			{
				std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Error closing UDP ports" << e.what() << "\n";
				connected_ = false;
			}
		}


		void pollingThreadFn()
		{
			try {
				pollThreadRunning_ = true;
				if (verbose_)
					std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Simulink UDP polling thread launched\n";

				start_receive();

				//auto work = std::make_shared<boost::asio::io_service::work>(*io_service_);
				io_service_->run(); // will block until sockets close

				if (verbose_)
					std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Finished ioservice::run. disconnecting...\n";

				pollThreadRunning_ = false;
			}
			catch (std::exception& e)
			{
				std::cout << "Error during Simulink UDP polling thread: " << e.what() << "\n";
				pollThreadRunning_ = false;
				return;
			}
		}

		void send_contents_of_send_buffer()
		{
			if (verbose_)
				std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Command to send " << send_buffer_.size() << " bytes\n";
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

					metadata_.saveTag = *reinterpret_cast<const uint32_t*>(&recv_buffer_[bp]);
					bp += 4;


					if (verbose_)
						std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Simulink UDP metadata: " << metadata_ << std::endl;
				}
				else
				{
					std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Simulink UDP: Received invalid UDP packet\n";
				}
			}
			else {
				std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Simulink UDP: Received error during receive" << std::endl;
			}
			start_receive();
		}

		void handle_send(const boost::system::error_code& ec, std::size_t bytes)
		{
			if (ec)
				std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Simulink UDP: Error sending packet: " << ec.message() << " [" << ec.category().name() << ":" << ec.value() << "]" << std::endl;
		}
	};

	//ring buffer for storing live streaming images, designed to store images in continguous blocks
	//even as they come in piecemeal
	class PrairieImageStreamBuffer
	{
	private:
		std::vector<bool> hasFrame_;
		std::vector<ImageMetadata> metadata_;
		std::vector<short> data_; // ring buffer for storing data
		unsigned int offsetWrite_;

		unsigned nFramesWritten_;
		int highestFrameNumberRead;

		unsigned int samplesPerFrame_;
		unsigned int nFramesBuffer_;

		int lastFrameSlotRead_;

		boost::recursive_mutex mutex_;

		bool verbose_;
	public:
		PrairieImageStreamBuffer()
			:offsetWrite_(0), nFramesWritten_(0), 
			samplesPerFrame_(0), nFramesBuffer_(0), 
			highestFrameNumberRead(-1), verbose_(false), lastFrameSlotRead_(-1)
		{
		}

		void setSize(unsigned int samplesPerFrame, unsigned int nFramesBuffer)
		{
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);
			samplesPerFrame_ = samplesPerFrame;
			nFramesBuffer_ = nFramesBuffer;
			data_.resize(nFramesBuffer*samplesPerFrame);
			metadata_.resize(nFramesBuffer);
			hasFrame_.resize(nFramesBuffer);
			reset();
			if (verbose_)
				std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Stream: sizing for " << samplesPerFrame << " samples over " << nFramesBuffer << " frames\n";
		}

		unsigned int getSize()
		{
			return (unsigned int)data_.size();
		}

		void reset()
		{
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);
			std::fill(hasFrame_.begin(), hasFrame_.end(), false);
			lastFrameSlotRead_ = -1;
			offsetWrite_ = 0;
			nFramesWritten_ = 0;
			highestFrameNumberRead = -1;
			if (verbose_)
				std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Stream: resetting\n";
		}

		void setVerbose(bool tf)
		{
			verbose_ = tf;
		}

		short* getStartPointer()
		{
			return data_.data();
		}

		unsigned int getOffsetStartOfImage(unsigned int index)
		{
			return samplesPerFrame_ * index;
		}

		unsigned int getOffsetEndOfFrame(unsigned int index)
		{
			return samplesPerFrame_ * (index + 1) - 1;
		}

		short* getPointerToStartOfFrame(unsigned int index)
		{
			//if(verbose_) 
			//{
			//	std::cout << "Returning ptr to start of frame " << index << "\n";
			//	std::cout << "start is at " << getStartPointer() << " + " << samplesPerFrame_ << " * " << index << "\n";
			//}
			return getStartPointer() + samplesPerFrame_ * index;
		}

		short* getPointerNextWrite()
		{
			// get the pointer to the next item in data yet to be written
			short* ptr = getStartPointer();
			return ptr + offsetWrite_;
		}

		unsigned int getFrameIndexNextWrite()
		{
			// returns the frame index where the next sample will be written into
			return offsetWrite_ / samplesPerFrame_;
		}

		unsigned int getSamplesRemainingWrite()
			// return the number of samples left from offsetWrite_ to the end of data_
		{
			return getSize() - offsetWrite_;
		}

		void markSamplesWritten(unsigned int nSamples, ImageMetadata meta)
		{
			//boost::recursive_mutex::scoped_lock scoped_lock(mutex_);
			// acquiring the mutex would be safer, but since reading images is read-only, probably okay to have this not slow down 
			// the polling thread
			if (nSamples == 0)
				return;

			unsigned int offsetWriteCopy = offsetWrite_;
			unsigned int offsetWritePre = offsetWrite_;
			unsigned int frameStart = getFrameIndexNextWrite();
			unsigned int i = 0;
			unsigned int sz = getSize();

			// correct 8192 offset in the newly written samples, plus ignore negative samples
			for (i = offsetWrite_; i < offsetWrite_ + nSamples && i < sz; i++)
			{
				data_[i] = data_[i] >= 8192 ? data_[i] - 8192 : 0;
			}

			// move our write offset, we'll loop to 0 below
			offsetWriteCopy += nSamples;

			//if (verbose_)
			//	std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Stream: " << nSamples << " written\n";
		
			// loop i over frames we've completely written
			for (i = frameStart;
				offsetWriteCopy > getOffsetEndOfFrame(i) && i < nFramesBuffer_; i++)
			{
				meta.frameNumber = nFramesWritten_;
				//if (verbose_)
				//	std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Stream: finished frame " << meta.frameNumber << " at slot " << i << " trial " << meta.trialId << " usable " << meta.usable << std::endl;
				if(verbose_ && meta.usable)
					std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Stream: finished frame " << meta.frameNumber << " at slot " << i << " trial " << meta.trialId << " usable " << meta.usable << std::endl;
				metadata_[i] = meta;
				hasFrame_[i] = true;
				nFramesWritten_++;
			}

			if (offsetWriteCopy >= getSize())
				offsetWriteCopy = 0;

			offsetWrite_ = offsetWriteCopy;
		}

		int findFrameIndexMostRecentWritten(bool usableOnly)
		{
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);

			//// pick up from where we left off
			//int mri = -1;
			//int maxFrameNumber = -1;
			//if (verbose_)
			//	std::cout << "Buffer: findFrameIndexMostRecentWritten starting on frame " << lastFrameSlotRead_ << std::endl;

			//for (unsigned int i = 0; i < nFramesBuffer_; i++)
			//{
			//	// pick up from one after where we left off
			//	auto imod = (i + lastFrameSlotRead_ + 1) % nFramesBuffer_;
			//	if (verbose_)
			//		std::cout << "Buffer: looking at frame " << imod << std::endl;
			//	// break once we run out frames with hasFrame set 
			//	// or we hit a frame with a lower frame number than we've returned previously (highestFrameNumberRead) 
			//	// or we hit a frame with a lower frame number than we've encountered looping through (maxFrameNumber)
			//	if (!hasFrame_[imod] || (int)metadata_[i].frameNumber <= highestFrameNumberRead || (int)metadata_[imod].frameNumber <= maxFrameNumber)
			//	{
			//		// we've reached the end of frames in the buffer or are looking at old frames having looped around
			//		if (verbose_) {
			//			if (!hasFrame_[imod]) 
			//				std::cout << "Buffer: Breaking on !hasFrame slot " << imod << std::endl; 
			//			else if ((int)metadata_[i].frameNumber <= highestFrameNumberRead)
			//				std::cout << "Buffer: Breaking on slot " << imod << " frameNumber " << metadata_[i].frameNumber << " <= highestFrameNumberRead " << highestFrameNumberRead << std::endl;
			//			else if ((int)metadata_[imod].frameNumber <= maxFrameNumber)
			//				std::cout << "Buffer: Breaking on slot " << imod << " frameNumber " << metadata_[i].frameNumber <<  " <= maxFrameNumber " << maxFrameNumber << std::endl;
			//		}
			//			
			//		break;
			//	}
			//	else if (!usableOnly || metadata_[imod].usable)
			//	{
			//		if (verbose_)
			//			std::cout << "Buffer: Seeing more recent frame " << metadata_[imod].frameNumber  << " in slot " << imod << std::endl;
			//		mri = imod;
			//		maxFrameNumber = metadata_[imod].frameNumber;
			//	} 
			//	else if (verbose_)
			//	{
			//		if ((int)metadata_[imod].frameNumber <= maxFrameNumber)
			//			std::cout << "Buffer: Skipping because frame number " << metadata_[imod].frameNumber << " less than maxFrameNumber " << maxFrameNumber << std::endl;
			//		else if (usableOnly && !metadata_[imod].usable)
			//			std::cout << "Buffer: Skipping because not usable\n";
			//	}

			//}

			//if(verbose_)
			//	std::cout << "Buffer: Returning slot " << mri << " with frame " << maxFrameNumber << std::endl;
			//if (maxFrameNumber != -1)
			//{
			//	lastFrameSlotRead_ = mri;
			//	return mri;
			//}
			//else
			//	return -1;

			// old implementation O(nFramesBuffer_)
			int mri = -1;
			int maxFrameNumber = -1;
			for (unsigned int i = 0; i < nFramesBuffer_; i++)
			{
				if (hasFrame_[i] && (int)metadata_[i].frameNumber > maxFrameNumber &&
					(!usableOnly || metadata_[i].usable) && (int)metadata_[i].frameNumber > highestFrameNumberRead) {
					mri = i;
					maxFrameNumber = metadata_[i].frameNumber;
				}
			}

			if (maxFrameNumber == -1)
				return -1;
			else
				return mri;
		}

		int findFrameIndexNextToRead(bool usableOnly)
		{
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);

			//if (verbose_)
			//	std::cout << "Buffer: findFrameIndexNextToRead starting on frame " << lastFrameSlotRead_+1 << " highestframeNumberRead " << highestFrameNumberRead << std::endl;
			//int mri = -1;
			//int minFrameNumber = -1;
			//for (unsigned int i = 0; i < nFramesBuffer_; i++)
			//{
			//	// pick up from where we left off
			//	auto imod = (i + lastFrameSlotRead_ + 1) % nFramesBuffer_;
			//	if (verbose_)
			//		std::cout << "Buffer: looking at slot " << imod << " frame " << metadata_[i].frameNumber << " usable " << metadata_[imod].usable << std::endl;
			//	if (!hasFrame_[imod] || (int)metadata_[i].frameNumber <= highestFrameNumberRead)
			//	{
			//		// we've reached the end of frames in the buffer or are looking at old frames having looped around, so break
			//		if (verbose_)
			//		{
			//			if (!hasFrame_[imod])
			//				std::cout << "Buffer: Breaking on !hasFrame slot " << imod << std::endl;
			//			else if ((int)metadata_[i].frameNumber <= highestFrameNumberRead)
			//				std::cout << "Buffer: Breaking on slot " << imod << " frameNumber " << metadata_[i].frameNumber << " <= highestFrameNumberRead " << highestFrameNumberRead << std::endl;
			//		}
			//		break;
			//	}
			//	else if (!usableOnly || metadata_[imod].usable)
			//	{
			//		// we've hit a frame we haven't yet read, so immediately return it
			//		if (verbose_)
			//			std::cout << "Buffer: Seeing next frame on slot " << imod << std::endl;
			//		mri = imod;
			//		minFrameNumber = metadata_[imod].frameNumber;
			//		break;
			//	}
			//}

			//if (verbose_)
			//	std::cout << "Buffer: Returning slot " << mri << " with frame " << minFrameNumber << std::endl;
			//if (minFrameNumber != -1)
			//{
			//	lastFrameSlotRead_ = mri;
			//	return mri;
			//}
			//else
			//	return -1;

			// old implementation O(nFramesBuffer_) - works better
			int mri = -1;
			int minFrameNumber = -1;
			for (unsigned int i = 0; i < nFramesBuffer_; i++)
			{
			//	if (verbose_)
			//		std::cout << "image " << i << hasFrame " << hasFrame_[i] << " frameNum " << metadata_[i].frameNumber << " min " << mri << " usable" << metadata_[i].usable << std::endl;
				if (hasFrame_[i] && (mri == -1 || (int)metadata_[i].frameNumber < minFrameNumber) &&
					(!usableOnly || metadata_[i].usable) && (int)metadata_[i].frameNumber > highestFrameNumberRead) {
					mri = i;
					minFrameNumber = metadata_[i].frameNumber;
				}
			}

			if (minFrameNumber == -1)
				return -1;
			else
				return mri;
		}

		bool hasUnreadImage(bool usableOnly)
		{
			return (findFrameIndexNextToRead(usableOnly) != -1);
		}

		unsigned int totalFramesWritten()
		{
			return nFramesWritten_;
		}

		TaggedImage readImageMostRecentWritten(bool usableOnly)
		{
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);
			int index = findFrameIndexMostRecentWritten(usableOnly);
			if (index == -1) {
				// nothing valid to read
				//if (verbose_)
				//	std::cout << "Stream: No images to read\n";
				return TaggedImage(NULL, ImageMetadata());
			}
			else 
			{
				if (verbose_)
					std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Stream: returning most recent frame " << metadata_[index].frameNumber << " at slot " << index << " trial " << metadata_[index].trialId << "\n";
				highestFrameNumberRead = metadata_[index].frameNumber;
				hasFrame_[index] = false;

				// read the most recently written image, mark as most recently read
				return TaggedImage(getPointerToStartOfFrame(index), metadata_[index]);
			}

		}

		TaggedImage readImageNextToRead(bool usableOnly)
		{
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);
			int index = findFrameIndexNextToRead(usableOnly);
			if (index == -1) {
				//if (verbose_)
				//	std::cout << "Stream: No images to read\n";
				// nothing valid to read
				return TaggedImage(NULL, ImageMetadata());
			}
			else
			{
				if (verbose_)
					std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Stream: returning next to read frame " << metadata_[index].frameNumber << " at slot " << index << " trial " << metadata_[index].trialId << "\n";
				highestFrameNumberRead = metadata_[index].frameNumber;
				hasFrame_[index] = false;

				// read the most recently written image, mark as most recently read
				return TaggedImage(getPointerToStartOfFrame(index), metadata_[index]);
			}
		}
	};

	// handles requesting of data copy and places images into image stream buffer with current metadata
	class PrairieDataStream
	{

	public:
		PrairieDataStream(PrairieStream::PrairieSession& session,
			PrairieStream::SimulinkUdpHandler& udp, 
			unsigned int nFramesBuffer=100)
			:session_(session), udp_(udp), lines(0), samples(0), pixels(0), channels(0), 
			 nFramesBuffer_(nFramesBuffer), useTseries_(false)
		{
		}

		void setVerbose(bool tf)
		{
			verbose_ = tf;
			imgstreambuf_.setVerbose(tf);
		}

		void setUseTSeries(bool tf)
		{
			useTseries_ = tf;
		}

		bool queryInfo()
		{
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);
			channels = 2; // hardcoded for now until i figure out how to set this
			bool tf;
			tf = session_.queryStateUInt(lines, "linesPerFrame");
			if (!tf) return false;

			tf = session_.queryStateUInt(pixels, "pixelsPerLine");
			if (!tf) return false;

			tf = session_.querySamplesPerPixel(samples);
			if (!tf) return false;

			if(verbose_)
				std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Image: " << lines << " lines x " << pixels << " pixels x " << samples << " samples x " << channels << " channels\n";
			return true;
		}

		unsigned int calculateSamplesPerFrame()
		{
			return lines * pixels * channels * samples;
		}

		bool startStreaming()
		{
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);
			bool tf;
			if (lines == 0) {
				tf = queryInfo();
				if (!tf) return false;
			}

			tf = session_.sendAcceptCommandsDuringScan();
			if (!tf) return false;

			tf = session_.sendStopScan();
			if (!tf) return false;

			tf = session_.sendStopRawDataStreaming();
			if (!tf) return false;

			tf = session_.sendLimitBufferSize(0);
			if (!tf) return false;

			//tf = session_.sendNoWait();
			//if (!tf) return false;

			tf = session_.sendStartRawDataStreaming(prairieViewInternalNumFramesBuffer_);
			if (!tf) return false;

			// initialize buffer
			imgstreambuf_.setSize(calculateSamplesPerFrame(), nFramesBuffer_);
			imgstreambuf_.reset();

			return true;
		}

		bool stopStreaming()
		{
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);
			bool tf1, tf2;
			tf1 = session_.sendStopRawDataStreaming();
			tf2 = session_.sendNoLimitBufferSize();
			return tf1 && tf2;
		}

		bool requestData(unsigned int &nSamplesRecv)
		{
			boost::recursive_mutex::scoped_lock scoped_lock(mutex_);

            ImageMetadata meta = getMostRecentMetadata();
			// -rrd PID ADDRESS SAMPLES
			std::string sep = PrairieSession::get_separator();
			DWORD pid = GetCurrentProcessId();
			uintptr_t ptr = (uintptr_t)(imgstreambuf_.getPointerNextWrite()); // must convert to int so not formatted as hex
			unsigned int samplesAvailable = imgstreambuf_.getSamplesRemainingWrite();

			std::ostringstream oss;
			oss << "-rrd" << sep << pid << sep << ptr << sep << samplesAvailable;
			std::string cmd = oss.str();

			bool tf = session_.sendAndWaitReplyUInt(cmd, nSamplesRecv);
			if (!tf) {
				std::cout << "Error retrieving image\n";
				nSamplesRecv = 0;
				return false;
			}
			else
			{
				imgstreambuf_.markSamplesWritten(nSamplesRecv, meta);
				return true;
			}
		}

		unsigned int getLines()
		{
			if (lines == 0)
				queryInfo();
			return lines;
		}

		unsigned int getPixels()
		{
			if (pixels == 0)
				queryInfo();
			return pixels;
		}

		unsigned int getSamples()
		{
			if (samples == 0)
				queryInfo();
			return samples;
		}

		unsigned int getChannels()
		{
			if (channels == 0)
				queryInfo();

			return channels;
		}

		void startPollingThread()
		{
			//boost::recursive_mutex::scoped_lock scoped_lock(mutex_);
			try {
				if (!pollThreadRunning_) {
					pollThreadShouldStop_ = false;
					ptrPollThread_.reset(new boost::thread(boost::bind(&PrairieDataStream::pollingThreadFn, this)));
					HANDLE hThread = ptrPollThread_->native_handle();
					BOOL success = SetThreadPriority(hThread, THREAD_PRIORITY_HIGHEST);
					if (!success)
						std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Error setting polling thread priority\n";
				}
			}
			catch (std::exception& e)
			{
				std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Error starting polling thread: " << e.what() << "\n";
				pollThreadRunning_ = false;
				ptrPollThread_.release();
				return;
			}
		}

		void stopPollingThread()
		{
			// DO NOT LOCK MUTEX HERE OR IT WON'T BE ABLE TO EXIT
			if (pollThreadRunning_) {
				pollThreadShouldStop_ = true;
				if (ptrPollThread_ != NULL) {
					ptrPollThread_->join();
					ptrPollThread_.release();
				}
				pollThreadRunning_ = false; // just in 
			}
		}

		unsigned int totalFramesWritten()
		{
			return imgstreambuf_.totalFramesWritten();
		}

		ImageMetadata getMostRecentMetadata()
		{
			ImageMetadata meta;
			udp_.getMostRecentMetadata(meta);
			meta.lines = lines;
			meta.pixels = pixels;
			meta.samples = samples;
			meta.channels = channels;
			return meta;
		}

		bool hasUnreadImage(bool usableOnly)
		{
			return imgstreambuf_.hasUnreadImage(usableOnly);
		}

		TaggedImage readImageMostRecentWritten(bool usableOnly)
		{
			return imgstreambuf_.readImageMostRecentWritten(usableOnly);
		}

		TaggedImage readImageNextToRead(bool usableOnly)
		{
			return imgstreambuf_.readImageNextToRead(usableOnly);
		}

	private:
		void pollingThreadFn()
		{
			try {
				pollThreadRunning_ = true;
				if(verbose_)
					std::cout << "Polling thread launched\n";

				bool tf;
				tf = session_.connect();
				if (!tf)
					throw std::runtime_error("Error connecting to PrairieView");

				session_.setTimeout(5);
				tf = session_.sendAcceptCommandsDuringScan();
				if (!tf)
					throw std::runtime_error("Error sending accept commands during scan");

				tf = queryInfo();
				if (!tf)
					throw std::runtime_error("Error querying image info");

				// this will also reset imgstreambuf_ and update its buffer size internally
				tf = startStreaming();
				if (!tf)
					throw std::runtime_error("Error starting streaming mode");

				if (useTseries_)
				{
					if (verbose_)
						std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Starting Tseries\n";
					tf = session_.sendStartTSeries();
					if (!tf)
						throw std::runtime_error("Error starting T series");
				}
				else
				{
					if (verbose_)
						std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Starting live scan streaming\n";
					tf = session_.sendStartLiveScan();
					if (!tf)
						throw std::runtime_error("Error starting live scan");
				}

				unsigned int nSamplesRecv = 0;
				unsigned int nFrames = 0;
				ImageMetadata meta;

				while (!pollThreadShouldStop_)
				{
					tf = requestData(nSamplesRecv);
					if (!tf)
						throw std::runtime_error("Error requesting streamed image");
					//if(nSamplesRecv == 0)
					//	boost::this_thread::yield();
				}
				std::cout << std::endl;

				if (verbose_) {
					std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Polling thread terminating\n";
					std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Received " << totalFramesWritten() << " complete frames\n";
				}

				bool dropped = false;
				tf = session_.queryDroppedData(dropped);
				if (!tf)
					throw std::runtime_error("Error querying dropped data");
				if (dropped)
					std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Data was dropped during streaming\n";
				else
					std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "No data was dropped during streaming\n";

				tf = session_.sendStopScan();
				if (!tf)
					throw std::runtime_error("Error stopping scan");

				pollThreadRunning_ = false;
			}
			catch (std::exception& e)
			{
				std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "ERROR Prairie thread: " << e.what() << "\n";

				pollThreadRunning_ = false;
				return;
			}
		}

		unsigned int nFramesBuffer_;
		PrairieStream::PrairieSession& session_;
		PrairieStream::SimulinkUdpHandler& udp_;
		PrairieImageStreamBuffer imgstreambuf_;

		unsigned int lines;
		unsigned int pixels;
		unsigned int channels;
		unsigned int samples;

		bool pollThreadRunning_ = false;
		bool pollThreadShouldStop_ = false;
		std::unique_ptr<boost::thread> ptrPollThread_;

		boost::recursive_mutex mutex_;

		bool verbose_ = false;
		bool useTseries_ = false;

		const unsigned int prairieViewInternalNumFramesBuffer_ = 20;
	};

	PrairieControl::PrairieControl()
		:io_service_(new boost::asio::io_service()),
		 session_(new PrairieSession(*io_service_)), 
		 udp_(new SimulinkUdpHandler()),
		 stream_(new PrairieDataStream(*session_, *udp_)),
		 verbose_(false)
	{
		connected_ = false;
		setVerbose(false, false, false, false);
		ElapsedTime::resetTimeReference();
	}

	PrairieControl::~PrairieControl()
	{
		disconnect();
	}

	void PrairieControl::setVerbose(bool tfControl, bool tfSession, bool tfStream, bool tfUdp)
	{
		verbose_ = tfControl;
		session_->setVerbose(tfSession);
		stream_->setVerbose(tfStream);
		udp_->setVerbose(tfUdp);
	}

	int64_t PrairieControl::getElapsedMs()
	{
		return ElapsedTime::getElapsedMs();
	}

	// utility functions to be interfaced with cython
	bool PrairieControl::connect()
	{
		boost::lock_guard<boost::mutex> guard(mutex_);

		if (connected_)
			return true;

		try {
			bool tf = false;

			if (verbose_)
				std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Connecting to PrairieView...\n";
			tf = session_->connect();
			if (!tf) 
				throw std::runtime_error("Error connecting to PrairieView");
			
			tf = stream_->queryInfo();
			if (!tf)
				throw std::runtime_error("Error querying image info");

			if (verbose_)
				std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Done querying info\n";

			if (verbose_)
				std::cout << "Starting UDP polling...\n";
			tf = udp_->startPollingThread();
			if (!tf)
				throw std::runtime_error("Error starting UDP thread");
			if (verbose_)
				std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Started UDP polling\n";

			connected_ = true;
			return connected_;
		}
		catch (std::exception& e)
		{
			std::cout << "[" << ElapsedTime::getElapsedMs() << " ms] " << "Error connecting: " << e.what() << "\n";
			session_->disconnect();
			udp_->stopPollingThread();
			connected_ = false;
			return connected_;
		}
	}

	void PrairieControl::disconnect()
	{
		// do not call any other locking PrairieControl methods
		boost::lock_guard<boost::mutex> guard(mutex_);

		if (!connected_)
			return;
		try {
			stream_->stopPollingThread();
			session_->disconnect();
			udp_->stopPollingThread();
			connected_ = false;
			std::cout << "Disconnected from PrairieView\n";
		}
		catch (std::exception& e)
		{
			std::cout << "Error disconnecting: " << e.what() << "\n";
		}
	}

	void PrairieControl::setUseTSeries(bool tf)
	{
		stream_->setUseTSeries(tf);
	}

	bool PrairieControl::setSingleImageName(const std::string& name)
	{
		try
		{
			if (!connected_) {
				std::cout << "Call connect() first\n";
				return 0;
			}
			return session_->setSingleImageName(name);
		}
		catch (std::exception& e)
		{
			std::cout << "Error setting Singlescan name: " << e.what() << "\n";
			return false;
		}
	}

	bool PrairieControl::setTSeriesName(const std::string& name)
	{
		try
		{
			if (!connected_) {
				std::cout << "Call connect() first\n";
				return 0;
			}
			return session_->setTSeriesName(name);
		}
		catch (std::exception& e)
		{
			std::cout << "Error setting TSeries name: " << e.what() << "\n";
			return false;
		}
	}

	bool PrairieControl::setSavePath(const std::string& path)
	{
		try
		{
			if (!connected_) {
				std::cout << "Call connect() first\n";
				return 0;
			}
			return session_->setSavePath(path);
		}
		catch (std::exception& e)
		{
			std::cout << "Error setting save path name: " << e.what() << "\n";
			return false;
		}
	}

	unsigned int PrairieControl::getLines()
	{
		boost::lock_guard<boost::mutex> guard(mutex_);

		if (!connected_) {
			std::cout << "Call connect() first\n";
			return 0;
		}
		return stream_->getLines();
	}

	unsigned int PrairieControl::getPixels()
	{
		boost::lock_guard<boost::mutex> guard(mutex_);

		if (!connected_) {
			std::cout << "Call connect() first\n";
			return 0;
		}
		return stream_->getPixels();
	}

	unsigned int PrairieControl::getSamples()
	{
		boost::lock_guard<boost::mutex> guard(mutex_);

		if (!connected_) {
			std::cout << "Call connect() first\n";
			return 0;
		}
		return stream_->getSamples();
	}

	unsigned int PrairieControl::getChannels()
	{
		boost::lock_guard<boost::mutex> guard(mutex_);

		if (!connected_) {
			std::cout << "Call connect() first\n";
			return 0;
		}
		return stream_->getChannels();
	}

	void PrairieControl::startPolling()
	{
		boost::lock_guard<boost::mutex> guard(mutex_);

		if (!connected_) {
			std::cout << "Call connect() first\n";
			return;
		}
		stream_->startPollingThread();
	}

	void PrairieControl::stopPolling()
	{
		boost::lock_guard<boost::mutex> guard(mutex_);

		if (!connected_) {
			std::cout << "Call connect() first\n";
			return;
		}
		stream_->stopPollingThread();
	}

	unsigned int PrairieControl::totalFramesWritten()
	{
		boost::lock_guard<boost::mutex> guard(mutex_);

		if (!connected_) {
			std::cout << "Call connect() first\n";
			return 0;
		}
		return stream_->totalFramesWritten();
	}

	bool PrairieControl::hasUnreadImage(bool usableOnly)
	{
		boost::lock_guard<boost::mutex> guard(mutex_);

		if (!connected_) {
			std::cout << "Call connect() first\n";
			return false;
		}
		return stream_->hasUnreadImage(usableOnly);
	}

	TaggedImage PrairieControl::readImageMostRecentWritten(bool usableOnly)
	{
		boost::lock_guard<boost::mutex> guard(mutex_);

		if (!connected_) {
			std::cout << "Call connect() first\n";
			return TaggedImage();
		}
		return stream_->readImageMostRecentWritten(usableOnly);
	}

	TaggedImage PrairieControl::readImageNextToRead(bool usableOnly)
	{
		boost::lock_guard<boost::mutex> guard(mutex_);

		if (!connected_) {
			std::cout << "Call connect() first\n";
			return TaggedImage();
		}
		return stream_->readImageNextToRead(usableOnly);
	}

	bool PrairieControl::sendDecoderUpdate(uint16_t conditionDecoded, double* log_likelihoods, unsigned int nConditions, const std::string &desc)
	{
		boost::lock_guard<boost::mutex> guard(mutex_);

		if (nConditions != ImageMetadata::NUM_CONDITIONS)
		{
			std::cout << "Error: expecting " << ImageMetadata::NUM_CONDITIONS << " conditions\n";
			return false;
		}
		double ll[ImageMetadata::NUM_CONDITIONS];
		for (unsigned i = 0; i < ImageMetadata::NUM_CONDITIONS; i++)
			ll[i] = log_likelihoods[i];

		DecoderUpdate update = DecoderUpdate(conditionDecoded, ll, desc);
		udp_->sendDecoderUpdate(update);
		return true;
	}

	ImageMetadata PrairieControl::getMostRecentMetadata()
	{
		boost::lock_guard<boost::mutex> guard(mutex_);

		return stream_->getMostRecentMetadata();
	}

}

//int main(int argc, char* argv[])
//{
//	try
//	{
//		using namespace PrairieStream;
//		auto pc = new PrairieControl();
//		pc->setVerbose(false, false, true, false);
//
//		if (!pc->connect())
//			throw std::runtime_error("Could not connect to PrairieView");
//
//		pc->startPolling();
//
//		boost::this_thread::sleep_for(boost::chrono::seconds(5));
//
//		pc->readImageNextToRead(false);
//
//		pc->stopPolling();
//		pc->disconnect();
//		delete pc;
//	}
//	catch (std::exception& e)
//	{
//		std::cout << "Error during run: " << e.what() << "\n";
//	}
//
//	system("pause");
//	return 0;
//}
