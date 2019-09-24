#cython: boundscheck=False, wraparound=False, nonecheck=False, overflowcheck=False, cdivision=True, infer_types=True
include "constants.pxi"

# Import the Python-level symbols of numpy
import numpy as np

# Import the C-level symbols of numpy
cimport numpy as np

# Numpy must be initialized when using the C-API
np.import_array()

cimport cython

cdef NAN = np.NaN

import matplotlib.pyplot as plt

cdef inline np.ndarray[double, ndim=2] flatten_data_cube(double[:,:,:] data_cube, bint subtract_means=False):
    _data_cube = np.asarray(data_cube)
    dims = data_cube.shape
    data_flat = _data_cube.swapaxes(1, 2).reshape((dims[0], dims[1] * dims[2]))

    if subtract_means:
        repmeans = np.repeat(np.mean(_data_cube, 2), dims[2], 1)
        return data_flat - repmeans
    else:
        return data_flat

cdef class MSEDecoder:
    def __cinit__(self, lines, pixels):
        self.lines = lines
        self.pixels = pixels
        self.num_conditions = NUM_CONDITIONS # defined in constants.pxi
        self.frame_counts = np.zeros(NUM_CONDITIONS, dtype=np.uint32)
        self.accum_images = np.zeros((lines, pixels, self.num_conditions), dtype=np.float64)
        self.frame_index = 0
        self.images_this_trial = np.zeros((lines, pixels, MAX_IMAGES_PER_TRIAL), dtype=np.float64)
        self.mean_images = np.zeros((lines, pixels, self.num_conditions), dtype=np.float64)
        self.accum_square_error = np.zeros(NUM_CONDITIONS, dtype=np.float64)
        self.log_likelihoods = np.zeros(NUM_CONDITIONS, dtype=np.float64)
    def __dealloc__(self):
        pass

    cdef void process_training_image(self, double[:,:] image, unsigned int condition_id):
        """Image is lines x pixels, condition_id is scalar"""

        # add image to this trial
        self.images_this_trial[:, :, self.frame_index] = image
        self.frame_index += 1

        # add image to trial average accumulation
        for i in range(self.lines):
            for j in range(self.pixels):
                self.accum_images[i, j, condition_id] += image[i,j]
        self.frame_counts[condition_id] += 1

    cdef post_training(self):
        """Computes the per-condition mean images from the accumulators"""
        cdef unsigned int i,j,c
        self.mean_images[:,:,:] = 0

        for c in range(<unsigned int>NUM_CONDITIONS):
            if self.frame_counts[c] > 0:
                for i in range(self.lines):
                    for j in range(self.pixels):
                        self.mean_images[i,j,c] = self.accum_images[i,j,c] / self.frame_counts[c]
            else:
                for i in range(self.lines):
                    for j in range(self.pixels):
                        self.mean_images[i,j,c] = 0

    cdef reset_new_trial(self):
        """Resets accum_square_error at the end of each trial"""
        self.frame_index = 0
        self.images_this_trial[:,:,:] = 0
        self.accum_square_error[:] = 0
        self.log_likelihoods[:] = 0

    cdef double[:] decode_test_image(self, double[:,:] image):
        """Processes a decoding image and returns the updated log likelihoods vector"""
        cdef unsigned int i,j,c
        cdef double delta

        for c in range(<unsigned int>NUM_CONDITIONS):
            if self.frame_counts[c] > 0:
                for i in range(self.lines):
                    for j in range(self.pixels):
                        delta = (self.mean_images[i,j,c] - image[i,j])
                        self.accum_square_error[c] += delta * delta
                self.log_likelihoods[c] = 1.0 / self.accum_square_error[c]
            else:
                self.accum_square_error[c] = 0
                self.log_likelihoods[c] = NAN

        # add image to this trial
        # UNCOMMENT THIS IF YOU WANT TO SAVE TO DISK LATER
        # LOOKHERE
        # self.images_this_trial[:, :, self.frame_index] = image
        # self.frame_index += 1

        # accum_square_error = np.asarray(self.accum_square_error)
        # accum_square_error = np.sum(np.square(mean_images - image[:, :, None]), axis=(0,1))
        # cdef np.ndarray[np.double_t, ndim=1] log_likelihoods = np.reciprocal(self.accum_square_error)
        #
        # # ignore conditions with no frames
        # for i in range(self.num_conditions):
        #     if self.frame_counts[i] == 0:
        #         log_likelihoods[i] = np.NaN

        return self.log_likelihoods

    cdef reset(self):
        self.frame_counts[:] = 0
        self.accum_images[:,:,:] = 0
        self.reset_new_trial()
        self.mean_images[:,:,:] = 0

    def decoder_data_as_dict(self):
        out = {}
        out['mean_images'] = self.mean_images
        out['frame_counts'] = self.frame_counts
        return out

    def inspect_training_set(self):
        plt.figure(1)
        plt.imshow(flatten_data_cube(self.mean_images, subtract_means=False))
        plt.colorbar()
        plt.show()

    def inspect_frames_this_trial(self):
        plt.figure(2)
        plt.subplot(211)
        plt.imshow(flatten_data_cube(self.images_this_trial[:,:,0:self.frame_index], subtract_means=False))
        plt.colorbar()
        plt.show()

