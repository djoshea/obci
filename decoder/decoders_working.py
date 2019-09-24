import numpy as np
import imageTools as it
import matplotlib.pyplot as plt

MAX_IMAGES_PER_TRIAL = 15

class MSEDecoder:
    def __init__(self, lines, pixels, num_conditions=4, register_window_pixels=4):
        self.register_window_pixels = register_window_pixels
        self.lines = lines
        self.pixels = pixels
        self.num_conditions = num_conditions
        self.frame_counts = np.zeros(num_conditions, dtype=np.int32)
        self.accum_images = np.zeros((lines, pixels, num_conditions))

        self.accum_square_error = np.zeros(num_conditions)

        # for displaying single frames in a trial
        self.frame_index = 0
        self.images_this_trial = np.zeros((lines, pixels, MAX_IMAGES_PER_TRIAL))

        # self.registration_target = np.zeros((lines, pixels))
        self.versionNumber = 'v_1.0'

        self.reset_log_likelihoods()


    def process_training_image(self, image, condition_id):
        """Image is lines x pixels, condition_id is scalar"""
        # if np.sum(self.frame_counts) > 0:
        #     it.register_frames_autocorrelation(image, self.registration_target, self.register_window_pixels):

        # add image to this trial
        self.images_this_trial[:, :, self.frame_index] = image
        self.frame_index += 1

        print(f"training image has mean {np.mean(image)}")

        # add image to trial average accumulation
        self.accum_images[:,:,condition_id] += image
        self.frame_counts[condition_id] += 1
        # self.registration_target += image
        #self.post_training()
        #self.accum_log_likelihoods += np.sum(self.log_mean_images * image[:,:,np.newaxis], axis=(0,1)) - self.sum_mean_images
        #return self.accum_log_likelihoods

    def post_training(self):
        condition_mask = self.frame_counts > 0
        self.mean_images = np.zeros_like(self.accum_images)
        self.mean_images[:,:,condition_mask] = self.accum_images[:,:,condition_mask] / self.frame_counts[np.newaxis, np.newaxis, condition_mask]

        self.log_mean_images = np.zeros_like(self.mean_images)
        self.log_mean_images[:,:,condition_mask] = np.log(self.mean_images[:,:,condition_mask]) # L * P * Conditions

        self.sum_mean_images = np.sum(self.mean_images, axis=(0,1))

    def reset_log_likelihoods(self):
        #self.accum_log_likelihoods = np.zeros(self.num_conditions)
        self.accum_square_error = np.zeros(self.num_conditions)

    def reset_new_trial(self):
        self.frame_index = 0
        self.images_this_trial = np.zeros((self.lines, self.pixels, MAX_IMAGES_PER_TRIAL))
        #self.accum_log_likelihoods = np.zeros(self.num_conditions)
        self.accum_square_error = np.zeros(self.num_conditions)

    def decode_test_image(self, image):
        # if np.sum(self.frame_counts) > 0:
        #     it.register_frames_autocorrelation(image, self.registration_target, self.register_window_pixels):
        #self.accum_log_likelihoods += (np.sum(self.log_mean_images * image[:,:,np.newaxis], axis=(0,1)) - self.sum_mean_images)

        self.accum_square_error += np.sum(np.square(self.mean_images - image[:, :, np.newaxis]), axis=(0,1))
        log_likelihoods = np.reciprocal(self.accum_square_error)

        # ignore conditions with no frames
        condition_no_frames = self.frame_counts == 0
        log_likelihoods[condition_no_frames] = np.NaN

        return log_likelihoods

    def inspect_training_set(self):
        # try:
        # dims = np.shape(self.mean_images)
        # allCondImage = self.mean_images.swapaxes(1,2).reshape((dims[0], dims[1]*dims[2]))
        # plt.imshow(allCondImage)
        # plt.colorbar()
        # plt.show()

        # dims = np.shape(self.mean_images)
        # allCondImage = self.mean_images.swapaxes(1, 2).reshape((dims[0], dims[1] * dims[2]))
        # repmeans = np.repeat(np.mean(self.mean_images, 2), self.num_conditions, 1)


        plt.figure(1)

        # plt.subplot(211)
        plt.imshow(it.flatten_data_cube(self.mean_images, subtract_means=False))
        plt.colorbar()
        plt.show()

        # plt.subplot(212)
        # plt.imshow(it.flatten_data_cube(self.mean_images, subtract_means=True))
        # plt.colorbar()
        # plt.show()

    def mean_pixel_value_this_trial(self):
        return np.mean(self.images_this_trial[:,:,self.frame_counts])

    def inspect_frames_this_trial(self):
        plt.figure(2)

        plt.subplot(211)
        plt.imshow(it.flatten_data_cube(self.images_this_trial[:,:,0:self.frame_index], subtract_means=False))
        plt.colorbar()
        plt.show()

        # plt.subplot(212)
        # plt.imshow(it.flatten_data_cube(self.images_this_trial, subtract_means=True))
        # plt.colorbar()
        # plt.show()



    def reset(self):
        self.frame_counts = np.zeros(self.num_conditions, dtype=np.int32)
        self.accum_images = np.zeros((self.lines, self.pixels, self.num_conditions))
        # self.registration_target = np.zeros((self.lines, self.pixels))
        self.reset_log_likelihoods()
        self.post_training()

    def decoder_data_as_dict(self):
        out = {}
        out['mean_images'] = self.mean_images
        out['frame_counts'] = self.frame_counts
        return out