FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04


ARG OPENCV="4.7.0"
ARG CUDA_ARCH_BIN="5.2 5.3 6.0 6.1 6.2 7.0 7.2 7.5 8.0 8.6"



# See https://developer.nvidia.com/blog/updating-the-cuda-linux-gpg-repository-key/
RUN apt-key adv --fetch-keys https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub



RUN apt update && apt install -y --no-install-recommends build-essential \
    cmake \
    gcc \
    g++ \
    ninja-build \
    gdb \
    git \
    wget \
    unzip \
    yasm \
    doxygen \
    pkg-config \
    checkinstall \
    libdc1394-22 \
    libdc1394-22-dev \
    libatlas-base-dev \
    gfortran \
    libflann-dev \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libglew-dev \
    libtiff5-dev \
    zlib1g-dev \
    libjpeg-dev \
    libgdal-dev \
    libeigen3-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    libprotobuf-dev \
    protobuf-compiler \
    python-dev \
    python-numpy \
    python3-dev \
    python3-numpy \
    ffmpeg \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libswscale-dev \
    libavresample-dev \
    libleptonica-dev \
    libtesseract-dev \
    libgtk-3-dev \
    libgtk2.0-dev \
    libvtk6-dev \
    liblapack-dev \
    libv4l-dev \
    libhdf5-serial-dev \
    vim


WORKDIR /tmp
RUN wget https://github.com/opencv/opencv/archive/refs/tags/${OPENCV}.zip && unzip ${OPENCV}.zip && rm ${OPENCV}.zip
RUN wget https://github.com/opencv/opencv_contrib/archive/${OPENCV}.zip && unzip ${OPENCV}.zip && rm ${OPENCV}.zip


ADD Interface/cuviddec.h /usr/local/cuda/include
ADD Interface/nvcuvid.h /usr/local/cuda/include
ADD Interface/nvEncodeAPI.h /usr/local/cuda/include

RUN mkdir opencv-${OPENCV}/build && \
    cd opencv-${OPENCV}/build && \
   cmake -GNinja \
    -D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib-${OPENCV}/modules \
    -D WITH_CUDA=ON \
    -D WITH_CUDNN=ON \
    -D WITH_NVCUVID=ON \
    -D WITH_CUBLAS=ON \
    -D WITH_OPENGL=ON \
	-D WITH_FFMPEG=ON  \
    -D WITH_V4L=ON \
	-D WITH_LIBV4L=ON \
    -D ENABLE_FAST_MATH=ON \
    -D CUDA_FAST_MATH=ON \
    -D CUDA_ARCH_BIN=${CUDA_ARCH_BIN} \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D WITH_GSTREAMER=OFF \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_opencv_apps=ON \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=ON \
    -D PYTHON_DEFAULT_EXECUTABLE=$(python3 -c "import sys; print(sys.executable)")   \
    -D PYTHON3_EXECUTABLE=$(python3 -c "import sys; print(sys.executable)")   \
    -D PYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy; print (numpy.get_include())") \
    -D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
    -D CUDA_CUDA_LIBRARY=/lib/x86_64-linux-gnu/libcuda.so.1 \
    -D CUDA_nvcuvid_LIBRARY=/lib/x86_64-linux-gnu/libnvcuvid.so.1 \
    .. && \
    ninja && \
    ninja install

RUN rm -rf /tmp/* && rm -rf /var/lib/apt/lists/*

ADD test.py /home
ADD test.mov /home
