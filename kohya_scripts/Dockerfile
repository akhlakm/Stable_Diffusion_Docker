# While running, make sure to
#   - Install nvidia-docker using apt/dnf

# Available versions: https://hub.docker.com/r/nvidia/cuda/tags
# Make sure to choose the devel version for nvcc and other tools.
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         gfortran \
         cmake \
         git \
         curl \
         vim \
         ca-certificates \
         libjpeg-dev \
         libpng-dev \
         wget \
         google-perftools \
         python3 \
         python3-pip \
         python3-venv

RUN apt-get install -y pkg-config python3-dev
RUN apt-get install -y ffmpeg libsm6 libxext6
RUN apt-get install -y libcairo2-dev libjpeg-dev libgif-dev

# Setup system
RUN ln -s $(which python3) /bin/python

# Setup user
RUN useradd -m -s /bin/bash -u 1000 user
ENV PATH="/home/user/.local/bin:${PATH}"
ARG PATH="/home/user/.local/bin:${PATH}"
SHELL [ "/bin/bash", "-c" ]

# App dependencies
# RUN apt-get install -y python3-libnvinfer-dev
# RUN ln -s /usr/lib/x86_64-linux-gnu/libnvinfer_lean.so.8 /usr/lib/x86_64-linux-gnu/libnvinfer.so.7

# Setup app
COPY --chown=user sd-scripts/ /home/user/app/
WORKDIR /home/user/app
USER user

# Setup runtime
COPY bashrc.sh /home/user/.bashrc
COPY entrypoint.sh /home/user/entrypoint.sh
ENTRYPOINT ["/bin/bash", "/home/user/entrypoint.sh"]
