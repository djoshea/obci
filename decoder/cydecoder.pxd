cimport numpy as np

cdef class MSEDecoder:
    cdef unsigned int lines
    cdef unsigned int pixels
    cdef unsigned int num_conditions
    cdef np.uint32_t[:] frame_counts
    cdef double[:,:,:] accum_images
    cdef np.double_t[:] accum_square_error
    cdef unsigned int frame_index
    cdef double[:,:,:] images_this_trial
    cdef double[:,:,:] mean_images
    cdef double[:] log_likelihoods

    cdef void process_training_image(self, double[:,:] image, unsigned int condition_id)
    cdef post_training(self)
    cdef reset_new_trial(self)
    cdef double[:] decode_test_image(self, double[:,:] image)
    cdef reset(self)
