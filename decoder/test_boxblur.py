import numpy as np
from scipy import ndimage
from matplotlib import pyplot as plt
import timeit

test_cython = True
if test_cython:
    import cyboxblur as boxblur
else:
    import boxblur

img = ndimage.imread("F:\\texture.jpg").sum(axis=2)
if test_cython:
    # keep as int
    img = img.astype(float)
else:
    img = img.astype(float)
img_orig = np.copy(img) # writes into source image to save time

sigma = 5

# run both once for display
img_tmp = img.copy()
box_sizes = boxblur.box_sizes_for_gaussian(sigma)
imgblur = np.empty_like(img)
boxblur.gaussian_blur(img_tmp, imgblur, box_sizes, rescale=True)

imgblur2 = ndimage.gaussian_filter(img, sigma, order=0)

combined = np.concatenate((img, imgblur2, imgblur2), axis=1)

# now time both of them
def time_boxblur():
    boxblur.gaussian_blur(img_tmp, imgblur, box_sizes, rescale=False)

def time_scipyblur():
    ndimage.gaussian_filter(img, sigma, order=0)

print("boxblur: ", timeit.timeit(time_boxblur, number=100) * 10)
print("scipyblur: ", timeit.timeit(time_scipyblur, number=100) * 10)

plt.figure()
plt.imshow(combined, cmap="gray")
plt.show()