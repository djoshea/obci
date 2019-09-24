# Adapted from algo 4 from http://blog.ivank.net/fastest-gaussian-blur.html

import math
import numpy as np

def box_sizes_for_gaussian(sigma, n):
    wIdeal = math.sqrt((12*sigma*sigma/n)+1)
    wl = math.floor(wIdeal)
    if wl%2==0:
        wl-= 1
    wu = wl + 2

    mIdeal = (12*sigma*sigma - n*wl*wl - 4*n*wl - 3*n) / (-4*wl - 4)
    m = round(mIdeal)
    sizes = np.empty(n, dtype=np.float64)
    for i in range(n):
        if i<m:
            sizes[i] = wl
        else:
            sizes[i] = wu
    return sizes;

def gaussBlur(scl, tcl, r):
    h = scl.shape[0]
    w = scl.shape[1]
    scl = np.ravel(scl)
    tcl = np.ravel(tcl)
    bxs = box_sizes_for_gaussian(r, 3)
    start = np.copy(scl)
    boxBlur(start, tcl, w, h, int((bxs[0]-1)/2))
    boxBlur(tcl, start, w, h, int((bxs[1]-1)/2))
    boxBlur(start, tcl, w, h, int((bxs[2]-1)/2))

def boxBlur(scl, tcl, w, h, r):
    np.copyto(tcl, scl)
    boxBlurH(tcl, scl, w, h, r);
    boxBlurT(scl, tcl, w, h, r);

def boxBlurH(scl, tcl, w, h, r):
    iarr = 1 / (r+r+1)
    for i in range(h):
        ti = i*w
        li = ti
        ri = ti+r;
        fv = scl[ti]
        lv = scl[ti+w-1]
        val = (r+1)*fv
        for j in range(r):
            val += scl[ti+j]
        for j in range(r+1):
            val += scl[ri] - fv
            ri += 1
            tcl[ti] = round(val*iarr)
            ti += 1
        for j in range(r+1, w-r):
            val += scl[ri] - scl[li]
            ri += 1
            li += 1
            tcl[ti] = round(val*iarr)
            ti += 1
        for j in range(w-r, w):
            val += lv - scl[li]
            li += 1
            tcl[ti] = round(val*iarr)
            ti += 1

def boxBlurT(scl, tcl, w, h, r):
    iarr = 1 / (r+r+1)
    for i in range(w):
        ti = i
        li = ti
        ri = ti+r*w
        fv = scl[ti]
        lv = scl[ti+w*(h-1)]
        val = (r+1)*fv
        for j in range(r):
            val += scl[ti+j*w]
        for j in range(r+1):
            val += scl[ri] - fv
            tcl[ti] = round(val*iarr)
            ri+=w
            ti+=w
        for j in range(r+1, h-r):
            val += scl[ri] - scl[li]
            tcl[ti] = round(val*iarr)
            li+=w
            ri+=w
            ti+=w
        for j in range(h-r, h):
            val += lv - scl[li]
            tcl[ti] = round(val*iarr)
            li+=w
            ti+=w

# def boxBlurH(scl, tcl, w, h, r):
#     iarr = 1 / (r+r+1)
#     for i in range(h):
#         ti = i*w
#         li = ti
#         ri = ti+r;
#         fv = scl[ti]
#         lv = scl[ti+w-1]
#         val = (r+1)*fv
#         for j in range(r):
#             val += scl[ti+j]
#         for j in range(r+1):
#             val += scl[ri] - fv
#             ri += 1
#             tcl[ti] = round(val*iarr)
#             ti += 1
#         for j in range(r+1, w-r):
#             val += scl[ri] - scl[li]
#             ri += 1
#             li += 1
#             tcl[ti] = round(val*iarr)
#             ti += 1
#         for j in range(w-r, w):
#             val += lv - scl[li]
#             li += 1
#             tcl[ti] = round(val*iarr)
#             ti += 1
#
# def boxBlurT(scl, tcl, w, h, r):
#     iarr = 1 / (r+r+1)
#     for i in range(w):
#         ti = i
#         li = ti
#         ri = ti+r*w
#         fv = scl[ti]
#         lv = scl[ti+w*(h-1)]
#         val = (r+1)*fv
#         for j in range(r):
#             val += scl[ti+j*w]
#         for j in range(r+1):
#             val += scl[ri] - fv
#             tcl[ti] = round(val*iarr)
#             ri+=w
#             ti+=w
#         for j in range(r+1, h-r):
#             val += scl[ri] - scl[li]
#             tcl[ti] = round(val*iarr)
#             li+=w
#             ri+=w
#             ti+=w
#         for j in range(h-r, h):
#             val += lv - scl[li]
#             tcl[ti] = round(val*iarr)
#             li+=w
#             ti+=w