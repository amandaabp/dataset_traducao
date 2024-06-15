# Use the NVIDIA CUDA base image
FROM nvidia/cuda:11.4.3-base-ubuntu18.04

# Set environment variables to non-interactive for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Explicitly install CUDA development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-nvcc-11-4 \ 
    && rm -rf /var/lib/apt/lists/*

# Set CUDA paths
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=${CUDA_HOME}/bin:${PATH}
ENV LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    software-properties-common \
    build-essential \
    pkg-config \
    libssl-dev \
    ffmpeg \
    libsm6 \
    libxext6 \
    git \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y \
    python3.8 \
    python3.8-venv \
    python3.8-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Ensure python3 and pip3 point to Python 3.8
RUN rm /usr/bin/python3 && ln -s /usr/bin/python3.8 /usr/bin/python3
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.8

WORKDIR /traducao-amanda-container

# Install Rust using rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Add Rust to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Python packages (without flash-attn)
#RUN pip3 install torch torchvision torchaudio -f https://download.pytorch.org/whl/cu111/torch_stable.html
RUN pip3 install opencv-python-headless PyYAML regex requests 
RUN pip3 install certifi charset-normalizer colorama coloredlogs filelock flatbuffers fsspec 
RUN pip3 install huggingface-hub humanfriendly idna mpmath numpy protobuf pyreadline3 
RUN pip3 install safetensors tokenizers tqdm transformers typing_extensions
RUN pip3 install urllib3 cuda-python tensorrt tiktoken einops pytest packaging ninja

# Build pytorch from source
RUN apt-get update
# Install CMake 3.18.0+
RUN git clone --recursive https://github.com/pytorch/pytorch
RUN apt-get install python3-apt
WORKDIR /usr/lib/python3/dist-packages
RUN cp apt_pkg.cpython-36m-x86_64-linux-gnu.so apt_pkg.so
RUN apt-get remove --purge -y python3-gi
RUN apt-get update && apt-get install -y --reinstall --no-install-recommends \
    libgirepository1.0-dev \
    gir1.2-gtk-3.0 \
    python3-gi \
    python3-gi-cairo \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    && add-apt-repository ppa:kitware/cmake \ 
    && apt-get update && apt-get install -y cmake \ 
    && rm -rf /var/lib/apt/lists/*
RUN apt-get install -y --no-install-recommends libopenblas-dev libblas-dev m4 python3-setuptools python3-yaml
WORKDIR /traducao-amanda-container/pytorch
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"
ENV TORCH_CUDA_ARCH_LIST="8.0"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
RUN python3 setup.py install

# Install flash-attn with --no-build-isolation
RUN pip3 install --no-build-isolation 'flash-attn==1.0.0'

# Verify installations
RUN rustc --version
RUN cargo --version
RUN python3 --version
RUN pip3 show safetensors
RUN python3 -c "import cv2; print(cv2.__version__)"
RUN python3 -c "import torch; print(torch.__version__)"
RUN python3 -c "import torchvision; print(torchvision.__version__)"
RUN python3 -c "import torchaudio; print(torchaudio.__version__)"

COPY ./ ./

# # Entrar na pasta code-container
WORKDIR /traducao-amanda-container/code-container

# # Set the entrypoint
ENTRYPOINT ["python3","run.py"]