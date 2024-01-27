FROM ubuntu:20.04

RUN apt-get update -yy
RUN apt-get install -yy \
  software-properties-common \
  apt-transport-https \
  ca-certificates \
  gnupg \
  wget

# Add cmake
RUN wget -qO - https://apt.kitware.com/keys/kitware-archive-latest.asc | apt-key add -
RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'

RUN apt-get update -yy
RUN apt-get install -yy \
    # Install recent versions build tools, including Clang and libc++ (Clang's C++ library)
    clang-10 \
    libc++-10-dev \
    libc++abi-10-dev \
    cmake \
    ninja-build \
    # Install libraries for image I/O
    libpng-dev \
    libjpeg-dev \
    # Install required Python packages
    libpython3-dev \
    python3-distutils \
    # For running tests
    python3-pytest \
    python3-pytest-xdist \
    python3-numpy \
    git \
    python3-pip

ENV CC /usr/bin/clang-10
ENV CXX /usr/bin/clang++-10

# Build Mitsuba
WORKDIR /root
RUN git clone --recursive https://github.com/mitsuba-renderer/mitsuba3
COPY .env mitsuba3

RUN mkdir mitsuba3/build
WORKDIR /root/mitsuba3/build
RUN cmake -GNinja ..
RUN sed -i 's/"scalar_rgb", "scalar_spectral", "cuda_ad_rgb", "llvm_ad_rgb"/"scalar_rgb", "cuda_ad_rgb"/' mitsuba.conf
RUN sed -i 's/"python-default": "",/"python-default": "cuda_ad_rgb",/' mitsuba.conf
RUN ninja

# Python packages
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip install matplotlib==3.5 ipykernel ipywidgets

WORKDIR /root
ENTRYPOINT bash