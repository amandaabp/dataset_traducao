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

### Build pytorch from source
RUN apt-get update
# Install Miniconda
RUN curl -sLo ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && chmod +x ~/miniconda.sh \
    && ~/miniconda.sh -b -p /opt/conda \
    && rm ~/miniconda.sh \
    && /opt/conda/bin/conda clean -a

# Set up conda environment
ENV PATH="/opt/conda/bin:${PATH}"
RUN conda create -n pytorch-build python=3.8 cmake ninja
RUN echo "source activate pytorch-build" >> ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

# Install build dependencies
RUN conda install -c conda-forge magma-cuda114 # for CUDA 11.4 support
RUN conda install -c pytorch pytorch-cuda=11.4 # Install PyTorch with CUDA 11.4 from the pytorch channel

# Clone PyTorch source
WORKDIR /traducao-amanda-container
RUN git clone --recursive https://github.com/pytorch/pytorch
WORKDIR /traducao-amanda-container/pytorch

# Build PyTorch from source
RUN export CMAKE_PREFIX_PATH=${CONDA_PREFIX:-"$(dirname $(which conda))/../"} && \
    python3 setup.py install

### Install flash-attn with --no-build-isolation
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