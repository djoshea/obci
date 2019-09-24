import numpy as np

cdef double[:] kernel

def gaussian_kernel1d_rev(unsigned int sigma):
    """
    Computes a 1D Gaussian convolution kernel for use with correlate1d.
    """
    radius = 4 * sigma + 1
    p = np.polynomial.Polynomial([0, 0, -0.5 / (sigma * sigma)])
    x = np.arange(-radius, radius + 1)
    phi_x = np.exp(p(x), dtype=numpy.double)
    phi_x /= phi_x.sum()
    return phi_x[::-1]

def gaussian_filter1d(input, unsigned int sigma, axis=-1, output=None,
                      mode="reflect", cval=0.0, truncate=4.0):
    # make the radius of the filter equal to truncate standard deviations
    lw = int(4 * sd + 0.5)
    # Since we are calling correlate, not convolve, revert the kernel
    correlate1d(input, weights, axis, output, mode, cval, 0)

def gaussian_filter(input, sigma, order=0, output=None,
                    mode="reflect", cval=0.0, truncate=4.0):
    for axis in range(2)
        correlate1d(input, weights, axis, output, mode, cval, 0)
        input = output
    else:
        output[...] = input[...]
    return return_value


def correlate1d(input, weights, axis, output=None, mode="reflect",
                cval=0.0, origin=0):
    _nd_image.correlate1d(input, weights, axis, output, mode, cval,
                          origin)
    return return_value
