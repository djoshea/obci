#cython: boundscheck=False, wraparound=False, nonecheck=False, overflowcheck=False, cdivision=True, infer_types=True

# Adapted from algo 4 from http://blog.ivank.net/fastest-gaussian-blur.html
cimport numpy as np
import numpy as np
ctypedef np.int32_t INTTYPE

cdef extern from "math.h":
    double sqrt(double m)
    double floor(double x)
    # double round(double x)

cpdef int[:] box_sizes_for_gaussian(int sigma):
    cdef int n = 3 # number of passes - also would need to change gaussBlur to have this number of passes
    cdef double wIdeal
    cdef int wl, wu, m, i
    cdef np.ndarray[int, ndim=1] sizes

    wl = int(floor(sqrt((12.0*<double>sigma*<double>sigma/<double>n)+1)))
    if wl % 2==0:
        wl -= 1
    wu = wl + 2

    m = int(round((12*sigma*sigma - n*wl*wl - 4*n*wl - 3*n) / (-4*wl - 4)))
    sizes = np.empty(n, dtype=np.int32)
    for i in range(n):
        if i<m:
            sizes[i] = int((wl-1)/2)
        else:
            sizes[i] = int((wu-1)/2)
    return sizes

def scale_factor_for_box_sizes(int[:] box_sizes):
    return <int>(2 * box_sizes[0] + 1) ** (3 * 2) * \
                (2 * box_sizes[1] + 1) ** (3 * 2) * \
                (2 * box_sizes[2] + 1) ** (3 * 2)

cpdef void gaussian_blur(double[:,:] src, double[:,:] trg, int[:] box_sizes, bint rescale=True):
    """This will modify src to avoid allocating a new temporary array"""
    # bxs = box_sizes_for_gaussian(r)
    cdef int i
    cdef double scaleFactor
    h = src.shape[0]
    w = src.shape[1]
    cdef double[:] _src = np.ravel(src) # make into vectors
    cdef double[:] _trg = np.ravel(trg)

    boxBlur(_src, _trg, w, h, box_sizes[0])
    boxBlur(_trg, _src, w, h, box_sizes[1])
    boxBlur(_src, _trg, w, h, box_sizes[2])

    if rescale:
        scaleFactor = (2 * box_sizes[0] + 1) ** (3 * 2) * \
                      (2 * box_sizes[1] + 1) ** (3 * 2) * \
                      (2 * box_sizes[2] + 1) ** (3 * 2)

        for i in range(w*h):
            _trg[i] = _trg[i] / scaleFactor

cdef void boxBlur(double[:] src, double[:] trg, INTTYPE w, INTTYPE h, INTTYPE r):
    trg[...] = src
    boxBlurH(trg, src, w, h, r);
    boxBlurT(src, trg, w, h, r);

cdef boxBlurH(double[:] src, double[:] trg, INTTYPE w, INTTYPE h, INTTYPE r):
    cdef INTTYPE ti, li, ri, i, j
    cdef double iarr, fv, lv, val

    # iarr = 1.0 / <double>(r+r+1)
    for i in range(h):
        ti = i*w
        li = ti
        ri = ti+r;
        fv = src[ti]
        lv = src[ti+w-1]
        val = (r+1)*fv
        for j in range(r):
            val += src[ti+j]
        for j in range(r+1):
            val += src[ri] - fv
            ri += 1
            trg[ti] = val
            ti += 1
        for j in range(r+1, w-r):
            val += src[ri] - src[li]
            ri += 1
            li += 1
            trg[ti] = val
            ti += 1
        for j in range(w-r, w):
            val += lv - src[li]
            li += 1
            trg[ti] = val
            ti += 1

cdef boxBlurT(double[:] src, double[:] trg, INTTYPE w, INTTYPE h, INTTYPE r):
    cdef INTTYPE ti, li, ri, i, j
    cdef double iarr, fv, lv, val

    # iarr = 1.0 / <double>(r+r+1)
    for i in range(w):
        ti = i
        li = ti
        ri = ti+r*w
        fv = src[ti]
        lv = src[ti+w*(h-1)]
        val = (r+1)*fv
        for j in range(r):
            val += src[ti+j*w]
        for j in range(r+1):
            val += src[ri] - fv
            trg[ti] = val
            ri+=w
            ti+=w
        for j in range(r+1, h-r):
            val += src[ri] - src[li]
            trg[ti] = val
            li+=w
            ri+=w
            ti+=w
        for j in range(h-r, h):
            val += lv - src[li]
            trg[ti] = val
            li+=w
            ti+=w
