include "constants.pxi"
from libcpp cimport bool
from libcpp.string cimport string
from libc.stdint cimport uint16_t, int64_t
cimport numpy as np

cdef extern from "CPrairieStream.h" namespace "PrairieStream":
    cdef cppclass ImageMetadata:
        ImageMetadata() except +
        unsigned int frameNumber
        unsigned int trialId
        unsigned int conditionId
        bool conditionsToDecode[NUM_CONDITIONS]
        bool usable
        bool training
        bool reset
        unsigned int saveTag
        unsigned int lines
        unsigned int pixels
        unsigned int samples
        unsigned int channels

    cdef cppclass TaggedImage:
        TaggedImage() except +
        short* image
        ImageMetadata metadata

    cdef cppclass PrairieControl:
        PrairieControl() except +
        bool connect()
        void disconnect()
        int64_t getElapsedMs()
        void setVerbose(bool tfControl, bool tfSession, bool tfStream, bool tfUdp)

        void setUseTSeries(bool tf)
        bool setTSeriesName(const string& name)
        bool setSingleImageName(const string& name)
        bool setSavePath(const string& path)

        unsigned int getLines()
        unsigned int getPixels()
        unsigned int getSamples()
        unsigned int getChannels()
        void startPolling()
        void stopPolling()
        unsigned int totalFramesWritten()
        bool hasUnreadImage(bool usableOnly)
        TaggedImage readImageMostRecentWritten(bool usableOnly)
        TaggedImage readImageNextToRead(bool usableOnly)
        bool sendDecoderUpdate(uint16_t conditionDecoded, double* log_likelihoods, unsigned int nConditions, const string& desc)
        ImageMetadata getMostRecentMetadata()

cdef np.ndarray[np.int16_t, ndim=4, mode="c"] getTaggedImageAsArray(TaggedImage tagimg)

cdef class PyPrairieControl:
    cdef PrairieControl* thisptr
    cpdef bint connect(self)
    cpdef void disconnect(self)
    cpdef int64_t getElapsedMs(self)
    cpdef void setVerbose(self, bint control=*, bint session=*, bint stream=*, bint udp=*)
    cpdef void shutup(self)
    cpdef void setUseTSeries(self, bint tf)
    cpdef bint setSavePath(self, unicode path)
    cpdef bint setSingleImageName(self, unicode name)
    cpdef bint setTSeriesName(self, unicode name)
    cpdef unsigned int getLines(self)
    cpdef unsigned int getPixels(self)
    cpdef unsigned int getSamples(self)
    cpdef unsigned int getChannels(self)
    cpdef void startPolling(self)
    cpdef void stopPolling(self)
    cpdef bint hasUnreadImage(self, bint usableOnly=*)
    cpdef unsigned int totalFramesWritten(self)

    # C only
    cdef ImageMetadata getMostRecentMetadata(self)
    cdef TaggedImage readImageMostRecentWritten(self, bint usableOnly=*)
    cdef TaggedImage readImageNextToRead(self, bint usableOnly=*)
    cdef bint sendDecoderUpdate(self, unsigned short conditionDecoded,
                                double[:] log_likelihoods,
                                unicode desc)
