from libc.stdint cimport int64_t, uint8_t

cimport cyprairiestream
from cyprairiestream cimport PyPrairieControl, TaggedImage

cimport cydecoder
from cydecoder cimport MSEDecoder

cdef class OnlineDecoder:
    cdef:
        PyPrairieControl pc
        MSEDecoder decoder
        unsigned int n_pixels_y
        unsigned int n_pixels_x
        unsigned int n_pixels_total
        bint frame_acquisition_complete
        unsigned int trial_id
        unsigned int last_trial_id
        bint has_stored_images_this_trial
        bint has_processed_post_acquisition
        bint has_processed_post_training
        bint has_seen_training_images
        uint8_t[:] conditions_to_decode
        bint verbose
        bint is_resonant
        bint classifier_training
        unsigned int decoded_condition
        double[:] log_likelihoods
        unsigned int frame_count
        unsigned int save_tag
        unicode save_path
        unicode decode_log_file
        unicode version_number

        double[:, :] this_frame
        int[:] box_sizes
        double[:, :] smoothed_frame

        int64_t first_frame_time
        int64_t last_frame_time
        int64_t processing_time_this_trial
        object decode_log # file handle

    cdef poll_images(self)
    cdef update_training(self, TaggedImage tagImage)
    cdef update_decode(self, TaggedImage tagImage)
    cdef write_to_decode_log(self, unicode str)
    cdef save_training_images(self)
    cdef save_single_trial_images(self, unicode add_string=*)
    cdef bint update_trial_and_reset(self, TaggedImage tagImage)
    cdef update_meta(self)
    cpdef reset_decoder(self)
    cdef void setup_save_paths(self)
    cpdef set_verbose(self, bint tf)
