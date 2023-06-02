# While running, make sure to
#   - Install nvidia-docker2 using apt/dnf

# Available versions: https://hub.docker.com/r/nvidia/cuda/tags
# Make sure to choose the devel version for nvcc and other tools.
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         gfortran \
         cmake \
         git \
         curl \
         wget \
         vim \
         ca-certificates \
         libjpeg-dev \
         libpng-dev \
         google-perftools \
         python3 \
         python3-pip

RUN apt-get install -y pkg-config python3-dev python3-venv
RUN apt-get install -y ffmpeg libsm6 libxext6
RUN apt-get install -y libcairo2-dev libjpeg-dev libgif-dev

# Setup system
RUN ln -s $(which python3) /bin/python

# Setup user
RUN useradd -m -s /bin/bash -u 1000 user
ENV PATH="/home/user/.local/bin:${PATH}"
ARG PATH="/home/user/.local/bin:${PATH}"
SHELL [ "/bin/bash", "-c" ]

# Code server
# WORKDIR /home/user
# ENV PATH="$PATH:/home/user/.vscode-server/bin"
# ARG PATH="$PATH:/home/user/.vscode-server/bin"
# USER user
# COPY code-server.sh code-server.sh
# RUN bash code-server.sh
# RUN code-server --install-extension ms-python.python
# RUN code-server --install-extension ms-toolsai.jupyter

# App dependencies for tensorflow
# RUN apt-get install -y python3-libnvinfer-dev
# RUN ln -s /usr/lib/x86_64-linux-gnu/libnvinfer_lean.so.8 /usr/lib/x86_64-linux-gnu/libnvinfer.so.7

# Setup app
WORKDIR /home/user
USER user

# Setup runtime
COPY    entrypoint.sh      entrypoint.sh
ENTRYPOINT ["/bin/bash", "/home/user/entrypoint.sh"]
