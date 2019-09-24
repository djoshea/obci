import numpy as np
import scipy.ndimage as ndimage
import matplotlib.pyplot as plt
from skimage.feature import register_translation
from scipy.ndimage import fourier_shift
from skimage import data
from numba import jit




# ===========================================================================================
#  utilities for smoothing and registering frames

def smooth_frame(image, sigma):
    img = ndimage.gaussian_filter(image, sigma, order=0)
    #img = img[indices[0] - shift[0]:indices[1] - shift[0], indices[0] - shift[1]:indices[1] - shift[1]]
    return (img)

@jit
def register_frames(newimage, srcimagesub, newimagesub):
    shift, error, diffphase = register_translation(srcimagesub, newimagesub)
    # regst_image = ndimage.shift(newimage, shift)
    # regst_image = fourier_shift(np.fft.fftn(newimage), shift)
    # regst_image = np.fft.ifftn(regst_image)
    # regst_image = regst_image.real
    return (shift)

@jit
def register_frames_autocorrelation(newimage, srcimagesub, nPix):
    n = nPixv *2 +1
    corr = np.array([[0] * n] * n).astype('uint64')
    for i in np.arange(-nPix, nPix):
        for j in np.arange(-nPix, nPix):
            newimagesub = newimage[200 + i:300 + i, 200 + j:300 + j]
            corr[nPix + i, nPix + j] = np.sum(np.dot(newimagesub, srcimagesub))
    shiftx, shifty = np.where(corr == corr.max())
    shift = [shiftx[0] - nPix, shifty[0] - nPix]
    return (shift)

@jit
def flip_lines_for_resonant(image):
    image2 = image.copy()
    image2[::2,:] = image2[::2, ::-1]
    return image2

@jit
def flatten_data_cube(data_cube, subtract_means=False):
    dims = np.shape(data_cube)
    data_flat = data_cube.swapaxes(1, 2).reshape((dims[0], dims[1] * dims[2]))

    if subtract_means:
        repmeans = np.repeat(np.mean(data_cube, 2), np.shape(data_cube)[2], 1)
        return data_flat - repmeans
    else:
        return data_flat
