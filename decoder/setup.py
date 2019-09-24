# to build boost with newer visual studio 2017, use developer prompt
#   cd E:\boost_1_64_0
#   bootstrap.bat
#   b2 toolset=msvc-14.1 --build-type=minimal --abbreviate-paths architecture=x86 address-model=32 -j8
# then from anaconda prompt:
#   E:\VisualStudio2017\VC\Auxiliary\Build\vcvars32.bat
#   python setup.py build_ext -i


try:
    from setuptools import setup
    from setuptools import Extension
except ImportError:
    from distutils.core import setup
    from distutils.extension import Extension

from Cython.Build import cythonize
import os
import sysconfig
import numpy

debug = False
if debug:
    extra_compile_args=["/EHsc", "-Zi", "/Od"]
    extra_link_args=["-debug", "/MACHINE:X86"]
else:
    extra_compile_args = ["/EHsc", "/O2"]
    extra_link_args=["/MACHINE:X86"]

ext_cyprairiestream = Extension(
	"cyprairiestream",
	sources=["cyprairiestream.pyx", "CPrairieStream.cpp"],
	language="c++",
	include_dirs=["E:\\boost_1_64_0", numpy.get_include(), ],
	library_dirs=["E:\\boost_1_64_0\\stage\\lib", ],
	extra_link_args=extra_link_args,
	extra_compile_args=extra_compile_args,
)

ext_cydecoder = Extension(
        "cydecoder",
		sources=["cydecoder.pyx"],
		language="c++",
		include_dirs=["E:\\boost_1_64_0", numpy.get_include(), ],
		library_dirs=["E:\\boost_1_64_0\\stage\\lib", ],
		extra_link_args=extra_link_args,
        extra_compile_args=extra_compile_args + ["/fp:fast"],
	)

ext_cydecodelogic = Extension(
        "cydecodelogic",
		sources=["cydecodelogic.pyx"],
		language="c++",
		include_dirs=["E:\\boost_1_64_0", numpy.get_include(), ],
		library_dirs=["E:\\boost_1_64_0\\stage\\lib", ],
		extra_link_args=extra_link_args,
        extra_compile_args=extra_compile_args + ["/fp:fast"],
	)

ext_cyboxblur = Extension(
        "cyboxblur",
		sources=["cyboxblur.pyx"],
		language="c++",
		include_dirs=["E:\\boost_1_64_0", numpy.get_include(), ],
		library_dirs=["E:\\boost_1_64_0\\stage\\lib", ],
		extra_link_args=extra_link_args,
        extra_compile_args=extra_compile_args + ["/fp:fast"],
	)

# setup(
#     ext_modules = cythonize([ext_cyboxblur], annotate=True)
# )

setup(
    ext_modules = cythonize([ext_cyboxblur, ext_cyprairiestream, ext_cydecoder, ext_cydecodelogic], annotate=True)
)

