#cython: boundscheck=False, wraparound=False, nonecheck=False, overflowcheck=False, cdivision=True, infer_types=True
#distutils: language = c++
#distutils: sources = CPrairieStream.cpp

# helpful: https://stackoverflow.com/questions/29168575/wrap-c-class-with-cython-getting-the-basic-example-to-work

include "constants.pxi"

from libcpp cimport bool
from libcpp.string cimport string
from libc.stdint cimport uint16_t, int64_t

import numpy as np
cimport numpy as np
np.import_array() # Numpy must be initialized when using the C-API

cimport cyprairiestream
from cyprairiestream cimport TaggedImage

cdef np.ndarray[np.int16_t, ndim=4, mode="c"] getTaggedImageAsArray(TaggedImage tagimg):
    cdef int nd = 4;
    cdef np.npy_intp shape[4]
    if tagimg.image == NULL:
        return np.zeros([0, 0, 0, 0], dtype=np.int16)
    else:
        shape[0] = <np.npy_intp> tagimg.metadata.lines
        shape[1] = <np.npy_intp> tagimg.metadata.pixels
        shape[2] = <np.npy_intp> tagimg.metadata.samples
        shape[3] = <np.npy_intp> tagimg.metadata.channels
        return np.PyArray_SimpleNewFromData(nd, shape, np.NPY_INT16, tagimg.image)

cdef class PyPrairieControl:
    def __cinit__(self):
        self.thisptr = new PrairieControl()

    def __dealloc__(self):
        self.thisptr.disconnect()
        del self.thisptr

    cpdef bint connect(self):
        return self.thisptr.connect()

    cpdef void disconnect(self):
        self.thisptr.disconnect()

    cpdef int64_t getElapsedMs(self):
        return self.thisptr.getElapsedMs()

    cpdef void setVerbose(self, bint control = False, bint session = False, bint stream = False, bint udp = False):
        self.thisptr.setVerbose(control!=0, session!=0, stream!=0, udp!=0)

    cpdef void shutup(self):
        self.thisptr.setVerbose(0, 0, 0, 0)

    cpdef void setUseTSeries(self, bint tf):
        self.thisptr.setUseTSeries(tf != 0)

    cpdef bint setSavePath(self, unicode path):
        cpp_string = <string> path.encode('utf-8')
        return <bint>self.thisptr.setSavePath(cpp_string)

    cpdef bint setSingleImageName(self, unicode name):
        cpp_string = <string> name.encode('utf-8')
        return <bint>self.thisptr.setSingleImageName(cpp_string)

    cpdef bint setTSeriesName(self, unicode name):
        cpp_string = <string> name.encode('utf-8')
        return <bint>self.thisptr.setTSeriesName(cpp_string)

    cpdef unsigned int getLines(self):
        return self.thisptr.getLines()

    cpdef unsigned int getPixels(self):
        return self.thisptr.getPixels()

    cpdef unsigned int getSamples(self):
        return self.thisptr.getSamples()

    cpdef unsigned int getChannels(self):
        return self.thisptr.getChannels()

    cdef ImageMetadata getMostRecentMetadata(self):
        return self.thisptr.getMostRecentMetadata()

    cpdef void startPolling(self):
        self.thisptr.startPolling()

    cpdef void stopPolling(self):
        self.thisptr.stopPolling()

    cpdef bint hasUnreadImage(self, bint usableOnly=True):
        return <bint> self.thisptr.hasUnreadImage(usableOnly!=0)

    cpdef unsigned int totalFramesWritten(self):
        return self.thisptr.totalFramesWritten()

    cdef TaggedImage readImageMostRecentWritten(self, bint usableOnly=True):
        return self.thisptr.readImageMostRecentWritten(usableOnly!=0)

    cdef TaggedImage readImageNextToRead(self, bint usableOnly=True):
        return self.thisptr.readImageNextToRead(usableOnly!=0)

    cdef bint sendDecoderUpdate(self, unsigned short conditionDecoded,
                                double[:] log_likelihoods,
                                unicode desc):
        """sendDecoderUpdate(conditionDecoded, log_liklihoods as ndarray, description as string)"""
        cpp_string = <string> desc.encode('utf-8')
        # m = log_likelihoods.shape[0]
        # if m != NUM_CONDITIONS:
        #     raise ValueError("Expecting {} conditions in log_likelihoods array".format(NUM_CONDITIONS))
        return <bint>self.thisptr.sendDecoderUpdate(conditionDecoded, &log_likelihoods[0], NUM_CONDITIONS, cpp_string)
