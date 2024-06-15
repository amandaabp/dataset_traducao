# Use the NVIDIA CUDA base image
FROM nvidia/cuda:11.4.3-base-ubuntu18.04

# Set environment variables to non-interactive for apt-get
ENV DEBIAN_FRONTEND=noninteractive

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
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y \
    python3.8 \
    python3.8-venv \
    python3.8-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Ensure pip points to Python 3.8
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1
RUN update-alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3 1

WORKDIR /traducao-amanda-container

# Install Rust using rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Add Rust to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Python packages (without flash-attn)
RUN pip3 install \
    safetensors \
    opencv-python-headless \
    torch \
    torchvision \
    torchaudio \
    certifi \
    charset-normalizer \
    colorama \
    coloredlogs \
    filelock \
    flatbuffers \
    fsspec \
    huggingface-hub \
    humanfriendly \
    idna \
    mpmath \
    numpy \
    protobuf \
    pyreadline3 \
    PyYAML \
    regex \
    requests \
    sympy \
    tokenizers \
    tqdm \
    transformers \
    typing_extensions \
    urllib3 \
    cuda-python \
    tensorrt \
    tiktoken \
    einops \
    pytest \
    packaging \
    ninja

# Install flash-attn with --no-build-isolation
RUN pip3 install --no-build-isolation flash-attn

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