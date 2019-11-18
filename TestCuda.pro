TARGET = TestCUDA

# Define output directories
DESTDIR = release
OBJECTS_DIR = release/obj
CUDA_OBJECTS_DIR = release/cuda

# Source files
SOURCES += main.cpp

# This makes the .cu files appear in your project
OTHER_FILES +=  vectorAddition.cu

# CUDA settings <-- may change depending on your system
CUDA_SOURCES += vectorAddition.cu
CUDA_SDK = "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.1"   # Path to cuda SDK install
CUDA_DIR = "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.1"            # Path to cuda toolkit install
SYSTEM_NAME = x64           # Depending on your system either 'Win32', 'x64', or 'Win64'
SYSTEM_TYPE = 64            # '32' or '64', depending on your system
CUDA_ARCH = sm_50           # Type of CUDA architecture, for example 'compute_10', 'compute_11', 'sm_10'
NVCC_OPTIONS = --use_fast_math

# include paths
INCLUDEPATH += $$CUDA_DIR/include \
               $$CUDA_SDK/common/inc/ \
               $$CUDA_SDK/../shared/inc/

# library directories
QMAKE_LIBDIR += $$CUDA_DIR/lib/$$SYSTEM_NAME \
                $$CUDA_SDK/common/lib/$$SYSTEM_NAME \
                $$CUDA_SDK/../shared/lib/$$SYSTEM_NAME
# Add the necessary libraries
LIBS += -lcuda -lcudart

# The following library conflicts with something in Cuda
QMAKE_LFLAGS_RELEASE = /NODEFAULTLIB:msvcrt.lib
QMAKE_LFLAGS_DEBUG   = /NODEFAULTLIB:msvcrtd.lib

# The following makes sure all path names (which often include spaces) are put between quotation marks
CUDA_INC = $$join(INCLUDEPATH,'" -I"','-I"','"')

#QMAKE_CXXFLAGS_DEBUG += /MDd
#QMAKE_CXXFLAGS_RELEASE += /MD



# Configuration of the Cuda compiler
CONFIG(debug, debug|release) {
    #QQMAKE_CXXFLAGS_DEBUG += /MTd
    QMAKE_CXXFLAGS = /MTd
    # Debug mode
    cuda_d.input = CUDA_SOURCES
    cuda_d.output = $$CUDA_OBJECTS_DIR/${QMAKE_FILE_BASE}_cuda.o
    cuda_d.commands = $$CUDA_DIR/bin/nvcc.exe -D_DEBUG $$NVCC_OPTIONS $$CUDA_INC $$LIBS --machine $$SYSTEM_TYPE -arch=$$CUDA_ARCH -c -o ${QMAKE_FILE_OUT} ${QMAKE_FILE_NAME}
    cuda_d.dependency_type = TYPE_C
    QMAKE_EXTRA_COMPILERS += cuda_d
}
else {
    # Release mode
    cuda.input = CUDA_SOURCES
    cuda.output = $$CUDA_OBJECTS_DIR/${QMAKE_FILE_BASE}_cuda.o
    cuda.commands = $$CUDA_DIR/bin/nvcc.exe $$NVCC_OPTIONS $$CUDA_INC $$LIBS --machine $$SYSTEM_TYPE -arch=$$CUDA_ARCH -c -o ${QMAKE_FILE_OUT} ${QMAKE_FILE_NAME}
    cuda.dependency_type = TYPE_C
    QMAKE_EXTRA_COMPILERS += cuda
}

CONFIG += static_runtime
