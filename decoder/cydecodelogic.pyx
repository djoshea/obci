#cython boundscheck=False, wraparound=False, overflowcheck=False, cdivision=True, nonecheck=False

include "constants.pxi"
import numpy as np
cimport numpy as np
np.import_array() # Numpy must be initialized when using the C-API
cdef NAN = np.NaN

from libcpp cimport bool
from libc.stdint cimport uint16_t, uint8_t

cimport cydecoder
from cydecoder cimport MSEDecoder

cimport cyprairiestream
from cyprairiestream cimport PyPrairieControl, TaggedImage, getTaggedImageAsArray

from libc.stdio cimport *
cdef extern from "stdio.h":
    FILE *fdopen(int, const char *)

import msvcrt # for kbhit
import datetime
import os
import errno
import io
import time
from scipy import io as scipyio
import matplotlib.pyplot as plt

# import scipy.ndimage as ndimage
cimport cyboxblur
from cyboxblur cimport box_sizes_for_gaussian, gaussian_blur
from cyboxblur import scale_factor_for_box_sizes

np.set_printoptions(precision=2)

# ===========================================================================================
#  utilities for smoothing and registering frames

# old version using scipy
# cdef inline np.int32_t[:,:] smooth_frame(np.int32_t[:,:] image, unsigned int sigma):
#     return ndimage.gaussian_filter(image, sigma, order=0)

cdef inline flip_lines_and_sum_samples(np.int16_t[:,:,:,:] src, double[:,:] trg):
    # sum along axis 2 while flipping lines, taking channel 1 (green)
    cdef int i, j, k, L, P, S
    L = src.shape[0]
    P = src.shape[1]
    S = src.shape[2]
    for i in range(L):
        for j in range(P):
            trg[i, j] = 0
            if i % 2 == 0:
                # reverse
                for k in range(S):
                    trg[i,j] += <double>src[i, P-1-j, k, 1]
            else:
                for k in range(S):
                    trg[i, j] += <double>src[i, j, k, 1]

# cdef inline flip_lines_for_resonant(np.int32_t[:,:] frame):
#     frame[::2, :] = frame[::2, ::-1]

cdef class OnlineDecoder:
    def __cinit__(self, PyPrairieControl pc):
        self.frame_acquisition_complete = False
        self.trial_id = 0
        self.last_trial_id = 0
        self.has_stored_images_this_trial = False
        self.has_processed_post_acquisition = False
        self.has_processed_post_training = False
        self.conditions_to_decode = np.zeros(4, dtype=np.uint8)
        self.verbose = True
        self.is_resonant = True

        # create PyPrairieControl Object
        self.pc = pc
        self.n_pixels_y = self.pc.getLines()
        self.n_pixels_x = self.pc.getPixels()
        self.n_pixels_total = self.n_pixels_x * self.n_pixels_y

        # classifier Info
        self.classifier_training = True
        self.decoder = MSEDecoder(self.n_pixels_y, self.n_pixels_x)
        self.decoded_condition = 0
        self.log_likelihoods = np.zeros((4,), dtype=np.float64)
        self.frame_count = 0
        self.last_frame_time = 0
        self.has_seen_training_images = False

        # initialize once so we don't need to allocate new memory
        self.this_frame = np.empty((self.n_pixels_y, self.n_pixels_x), dtype=np.float64)
        self.box_sizes = box_sizes_for_gaussian(FRAME_BLUR_PIX)
        self.smoothed_frame = np.empty((self.n_pixels_y, self.n_pixels_x), dtype=np.float64)

        # initialize logging and decoder file sav
        self.setup_save_paths()
        self.last_frame_time = self.pc.getElapsedMs()
        # self.elapsed_time_str = ""
        self.save_tag = 1
        self.processing_time_this_trial = 0

        self.version_number = u"fast_v20170809" # for fast

    def __dealloc__(self):
        pass

    # main polling loop
    def run(self):
        self.pc.startPolling()

        while not msvcrt.kbhit():
            self.poll_images()

        self.pc.stopPolling()

    cdef poll_images(self):
        cdef unsigned int c
        cdef unicode print_str = u''
        cdef int64_t time_got_frame = 0
        cdef int64_t elapsed_ms = 0
        cdef int64_t now = 0

        cdef np.ndarray[np.uint32_t, ndim=1] frame_counts # for printing
        cdef bint some_conditions_decodable
        cdef double best_likelihood
        cdef double[:] log_likelihoods = np.empty(NUM_CONDITIONS, dtype=np.float64)
        cdef np.ndarray[double, ndim=1] log_likelihoods_for_print

        # watch for mode switch (training vs. decode) and decod er reset
        self.update_meta()

        # query frame
        cdef TaggedImage tag_image = self.pc.readImageNextToRead(usableOnly=True)
        time_got_frame = self.pc.getElapsedMs()

        # 1) === ACQUIRE FRAME AND PROCESS ===
        # Only if a valid new frame is available (xPC usable flag == true, should be once per trial around peri-move)
        if tag_image.image <> NULL:

            if self.update_trial_and_reset(tag_image):  # update trial ID and reset flags if new trial
                # new trial
                self.first_frame_time = time_got_frame
                self.processing_time_this_trial = 0

            self.last_frame_time = time_got_frame

            # training =====================
            if self.classifier_training:

                self.has_processed_post_training = False
                self.update_training(tag_image)
                self.has_stored_images_this_trial = True

                elapsed_ms = self.pc.getElapsedMs() - time_got_frame

                print_str = f'globalFrameNumber: {<int>tag_image.metadata.frameNumber}, ' \
                            f'trialId: {<int>tag_image.metadata.trialId}, ' \
                            f'conditionId: {<int>tag_image.metadata.conditionId}, ' \
                            f'usable: {tag_image.metadata.usable}, ' \
                            f'training: {tag_image.metadata.training}, ' \
                            f'processing time: {elapsed_ms}'

                self.write_to_decode_log(print_str)

            # decode =====================
            elif self.has_seen_training_images:

                # do this once after switching from training to decode mode
                if not self.has_processed_post_training:
                    self.has_processed_post_training = True
                    self.decoder.post_training()

                    # save mean images
                    self.save_training_images()
                    self.decoder.inspect_training_set()

                    self.pc.readImageMostRecentWritten(usableOnly=False) # discard every frame up until where we are now, so that the queue is reset to 0
                    return # and return now

                self.update_decode(tag_image)
                self.has_stored_images_this_trial = True

                # decoded condition should still be zero after reset, doesn't get set until after acquiring frames
                self.pc.sendDecoderUpdate(self.decoded_condition, self.log_likelihoods,
                                          u'MLE decoder')

                elapsed_ms = self.pc.getElapsedMs() - time_got_frame

                log_likelihoods_for_print = np.asarray(self.log_likelihoods)
                print_str = f'globalFrameNumber: {<int>tag_image.metadata.frameNumber}, ' \
                            f'trialId: {<int>tag_image.metadata.trialId}, ' \
                            f'conditionId: {<int>tag_image.metadata.conditionId}, ' \
                            f'processing time: {elapsed_ms}, ' \
                            f'frame {<int>self.frame_count}, ' \
                            f'success: {np.argmax(self.log_likelihoods) + 1 == tag_image.metadata.conditionId}, ' \
                            f'training: {tag_image.metadata.training}' \
                            f'LL: {log_likelihoods_for_print}'

                self.write_to_decode_log(print_str)

            self.processing_time_this_trial += self.pc.getElapsedMs() - time_got_frame

        # 2) === NO FRAME READY, POSSIBLY DONE WITH FRAMES THIS TRIAL ===
        else:
            now = self.pc.getElapsedMs()
            meta = self.pc.getMostRecentMetadata()

            # Skip the following code if we're still acquiring frames this trial
            if not meta.usable:
                if (not self.has_processed_post_acquisition) and self.has_stored_images_this_trial:
                    # begin post-trial complete processing
                    self.has_processed_post_acquisition = True
                    if self.classifier_training:

                        frame_counts = np.asarray(self.decoder.frame_counts)
                        print_str = f"Training: Finished training {<int>self.frame_count} frames in {<double>self.processing_time_this_trial / <double>self.frame_count:.4} ms / frame. Total accum. frames: {frame_counts}"
                        self.write_to_decode_log(print_str)

                        #self.decoder.inspect_frames_this_trial() # for debugging data coming in and blurring
                        #self.decoder.inspect_training_set() # for debugging mean data (change to mean rather than accum)

                        # tic = time.time()
                        self.save_single_trial_images(add_string=u'training')
                        # imageSaveTime = time.time() - tic

                    # decode
                    else:
                        # update decoded condition
                        # conditions_to_mask =
                        some_conditions_decodable = False
                        self.decoded_condition = 0
                        best_likelihood = 0
                        for c in range(<unsigned int>NUM_CONDITIONS):
                            log_likelihoods[c] = self.log_likelihoods[c]
                            if not self.conditions_to_decode[c]:
                                log_likelihoods[c] = NAN

                            elif log_likelihoods[c] <> NAN:
                                if log_likelihoods[c] > best_likelihood or self.decoded_condition == 0:
                                    self.decoded_condition = c + 1
                                    best_likelihood = log_likelihoods[c]

                        # if not some_conditions_decodable or np.all(np.isnan(log_likelihoods)):
                        #     # no conditions to decode
                        #     self.decoded_condition = 0
                        # else:
                        #     self.decoded_condition = np.nanargmax(log_likelihoods) + 1  # deal with zero indexing

                        # print("sending decoder update")

                        # send all likelihoods (no NaN'd out ineligible conditions)
                        self.pc.sendDecoderUpdate(np.floor(self.decoded_condition), self.log_likelihoods,
                                                  u'MLE decoder' + self.version_number)

                        frame_counts = np.asarray(self.decoder.frame_counts)
                        print(f"frame count is {<int>self.frame_count}, proc time is {<int>self.processing_time_this_trial}")
                        print_str = f"Decoding: Finished decoding {<int>self.frame_count} frames in {<double>self.processing_time_this_trial / <double>self.frame_count:.4} ms / frame. Total accum. frames: {frame_counts}"
                        self.write_to_decode_log(print_str)

                        # self.decoder.inspect_frames_this_trial()

                        # LOOKHERE
                        # IF YOU UNCOMMENT THIS, UNCOMMENT THE LINES IN CYDECODER.PXD as well
                        # self.save_single_trial_images(add_string=u'decode') # must uncomment corresponding holding onto image too

    # Most of the imaging update  s happen here
    cdef update_training(self, TaggedImage tagImage):
        # cdef int64_t timeref = self.pc.getElapsedMs()
        # cdef int64_t timenow

        # (0) copy out data
        # cdef np.ndarray[np.int16_t, ndim = 4, mode = "c"] raw_samples = getTaggedImageAsArray(tagImage)
        # cdef np.ndarray[np.int32_t, ndim = 2, mode = "c"] this_frame = np.sum(raw_samples[:, :, :, 1], axis=2)  # sum over samples for green frame
        # timenow = self.pc.getElapsedMs()
        # print(f"  [{timenow - timeref} ms for mean over samples]", )
        # timeref = timenow
        #
        # # (1) flip odd lines if resonant
        # if self.is_resonant:
        #     flip_lines_for_resonant(this_frame)
        #
        # timenow = self.pc.getElapsedMs()
        # print(f"  [{timenow - timeref} ms for flip lines]")
        # timeref = timenow

        cdef np.int16_t[:,:,:,:] raw_samples = getTaggedImageAsArray(tagImage)
        flip_lines_and_sum_samples(raw_samples, self.this_frame)  # sum over samples for green frame

        # timenow = self.pc.getElapsedMs()
        # print(f"  [{timenow - timeref} ms for mean over samples and flip]")
        # timeref = timenow

        self.has_seen_training_images = True
        self.frame_count += 1

        # (3) blur frame into smoothed_frame (will also modify thisFrame) smoothed_frame is now
        gaussian_blur(self.this_frame, self.smoothed_frame, self.box_sizes, False)

        # timenow = self.pc.getElapsedMs()
        # print(f"  [{timenow - timeref} ms for blur]")
        # timeref = timenow

        # (4) add frame to decoder
        self.decoder.process_training_image(self.smoothed_frame, tagImage.metadata.conditionId-1)

        # timenow = self.pc.getElapsedMs()
        # print(f"  [{timenow - timeref} ms for process training image]")
        # timeref = timenow

    cdef update_decode(self, TaggedImage tagImage):  # case 2) finished acquiring frames within this trial
        # cdef int64_t timeref = self.pc.getElapsedMs()
        # cdef int64_t timenow

        self.frame_count += 1

        cdef np.int16_t[:,:,:,:] raw_samples = getTaggedImageAsArray(tagImage)
        flip_lines_and_sum_samples(raw_samples, self.this_frame)  # sum over samples for green frame

        # timenow = self.pc.getElapsedMs()
        # print(f"  [{timenow - timeref} ms for mean over samples and flip]")
        # timeref = timenow

        # (3) blur frame
        gaussian_blur(self.this_frame, self.smoothed_frame, self.box_sizes, False)

        # timenow = self.pc.getElapsedMs()
        # print(f"  [{timenow - timeref} ms for blur]")
        # timeref = timenow

        # (4) perform decode
        self.log_likelihoods = self.decoder.decode_test_image(self.smoothed_frame)

        # timenow = self.pc.getElapsedMs()
        # print(f"  [{timenow - timeref} ms for process decode test image]")
        # timeref = timenow

    cdef write_to_decode_log(self, unicode str):
        ms = self.pc.getElapsedMs()
        self.decode_log.write(f'[{ms} ms] {str}\n')
        self.decode_log.flush()

        if self.verbose:
            print(f'[{ms} ms] Decoder: {str}')

    cdef save_training_images(self):
        try:
            filename = f"{self.save_path}\\trained_classifier__st_{<int>self.save_tag}.mat"
            decoder_data = self.decoder.decoder_data_as_dict()
            scipyio.savemat(filename, decoder_data)
            print(f'saving training images to: {filename}')

            # also save this to a temp file that gets overwritten, useful for viewing in matlab without updating path each time
            filenameOverwrite = f"E:\\PythonLogFiles\\trained_classifier__tmp_data.mat"
            scipyio.savemat(filenameOverwrite, decoder_data)

        except Exception as exc:
            print("errpr saving training images")
            print(exc)

    cdef save_single_trial_images(self, unicode add_string=u''):
        try:
            filename = f"{self.save_path}\\single_trial_images__st_{<int>self.save_tag}__trialId_{<int>self.trial_id}__{add_string}.mat"

            # build output for matlab
            dataOut = {}
            dataOut['trialImages'] = self.decoder.images_this_trial[:,:,0:self.frame_count]
            dataOut['training'] = self.classifier_training
            dataOut['trialId'] = self.trial_id
            dataOut['logLikelihoods'] = self.log_likelihoods
            scipyio.savemat(filename, dataOut)
            # print(f'saving images tshis trial to: {filename}')

        except Exception as exc:
            print("error saving single trial images")
            print(f"attempted save to filename {filename}")
            print(exc)

    def load_training_images(self, unicode save_path, unsigned int save_tag):

        filename = f"{save_path}\\trained_classifier__st_{<int>save_tag}.mat"
        decoder_data = scipyio.loadmat(filename)
        self.decoder.mean_images = decoder_data['mean_images']
        self.decoder.frame_counts = decoder_data['frame_counts']
        print(f"loading data from: {filename}")

    cdef bint update_trial_and_reset(self, TaggedImage tagImage):
        """Returns True if new trial"""
        cdef unicode print_str

        self.trial_id = tagImage.metadata.trialId
        if self.trial_id != self.last_trial_id:
            print_str = f"New Trial: {<int>tagImage.metadata.trialId}, cond: {<int>tagImage.metadata.conditionId}"
            self.write_to_decode_log(print_str)

            # update trial Id
            self.last_trial_id = self.trial_id

            # reset tags and trial information
            self.has_stored_images_this_trial = False
            self.frame_acquisition_complete = False
            self.has_processed_post_acquisition = False
            self.frame_count = 0
            self.decoded_condition = 0
            self.log_likelihoods[:] = 0
            self.decoder.reset_new_trial()
            return True
        else:
            return False

    cdef update_meta(self):
        cdef unsigned int i
        meta = self.pc.getMostRecentMetadata()

        self.classifier_training = meta.training
        self.save_tag = meta.saveTag
        for i in range(<unsigned int>NUM_CONDITIONS):
            self.conditions_to_decode[i] = <uint8_t> meta.conditionsToDecode[i]

        if meta.reset:
            self.reset_decoder()

    cpdef reset_decoder(self):
        self.has_seen_training_images = False
        self.decoder.reset()

    def report_decode_stats(self):
        pass
        # todo

    cdef void setup_save_paths(self):
        self.save_path = u"E:\\PythonLogFiles\\" + datetime.datetime.now().strftime(u"%Y-%m-%d") + "\\" + datetime.datetime.now().strftime(u"%Y-%m-%d__%H_%M_%S") + u"\\"
        print(f"Decoder: Saving Log files to: {self.save_path}")

        if not os.path.exists(os.path.dirname(self.save_path)):
            try:
                os.makedirs(self.save_path)
            except OSError as exc:  # guard against race conditions
                if exc.errno != errno.EEXIST:
                    raise

        self.decode_log_file = self.save_path + u"decode_log.txt"
        self.decode_log = open(self.decode_log_file, 'w')
        # self.timing_log = open(self.save_path + "program_execution_log.txt", 'w')

        self.decode_log.write(u"Decode Log: ")
        self.decode_log.flush()

    cpdef set_verbose(self, bint tf):
        self.verbose = tf

    def inspect_training_set(self):
        self.decoder.post_training() # force this just for inspection
        self.decoder.inspect_training_set()

    def inspect_frames_this_trial(self):
        self.decoder.inspect_frames_this_trial()

