#pragma once
#include <SDKDDKVer.h>
#include <boost/thread.hpp>
#include <boost/asio.hpp>

namespace PrairieStream {
	class PrairieSession;
	class PrairieDataStream;
	class SimulinkUdpHandler;

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
		unsigned int saveTag;

		unsigned int lines, pixels, samples, channels;

		ImageMetadata()
			:frameNumber(0), trialId(0), conditionId(0), usable(false), training(true), reset(false), saveTag(0),
			lines(0), pixels(0), samples(0), channels(0), conditionsToDecode{ false, false, false, false }
		{
		}
	};

	class TaggedImage
	{
	public:
		short* image;
		ImageMetadata metadata;
		TaggedImage()
			: image(NULL), metadata()
		{
		}

		TaggedImage(short* _image, ImageMetadata _metadata)
			:image(_image), metadata(_metadata)
		{
		}
	};

	class PrairieControl
	{
	public:
		PrairieControl();
		~PrairieControl();

		bool connect();
		void disconnect();

		int64_t getElapsedMs();
		void setUseTSeries(bool tf);
		bool setSingleImageName(const std::string& name);
		bool setTSeriesName(const std::string& name);
		bool setSavePath(const std::string& path);

		unsigned int getLines();
		unsigned int getPixels();
		unsigned int getSamples();
		unsigned int getChannels();
		void startPolling();
		void stopPolling();
		unsigned int totalFramesWritten();
		void setVerbose(bool tfControl = false, bool tfSession = false, bool tfStream = false, bool tfUdp = false);

		bool hasUnreadImage(bool usableOnly);
		TaggedImage readImageMostRecentWritten(bool usableOnly);
		TaggedImage readImageNextToRead(bool usableOnly);

		bool sendDecoderUpdate(uint16_t conditionDecoded, double* log_likelihoods, unsigned int nConditions, const std::string& desc);

		ImageMetadata getMostRecentMetadata();

	private:
		bool connected_;
		bool verbose_;
		std::unique_ptr<boost::asio::io_service> io_service_;
		std::unique_ptr<PrairieStream::PrairieSession> session_;
		std::unique_ptr<PrairieStream::SimulinkUdpHandler> udp_;
		std::unique_ptr<PrairieStream::PrairieDataStream> stream_; // needs to be last since it is passed udp_ and session_
		boost::mutex mutex_;
	};

	
}
