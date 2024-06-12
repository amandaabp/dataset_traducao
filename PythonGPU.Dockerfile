FROM nvidia/cuda:12.4.1-base-ubuntu20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
        git \
        python3-pip \
        python3-dev \
        python3-opencv \
        libglib2.0-0

# Entrar no diretório de trabalho do container
WORKDIR /traducao-amanda-container

# Copiar os requirements para o container
COPY ./requirements.txt ./

# Instalar pacotes especificados nos requirements
RUN python3 -m pip install -r requirements.txt

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# Instalar PyTorch e torchvision
RUN pip3 install torch torchvision torchaudio -f https://download.pytorch.org/whl/cu111/torch_stable.html

# Copia todo o projeto para dentro do container
COPY ./ ./

# Entrar na pasta code-container
WORKDIR /traducao-amanda-container/code-container

# Set the entrypoint
ENTRYPOINT ["python3","run.py"]FROM nvidia/cuda:12.4.1-base-ubuntu20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
        git \
        python3-pip \
        python3-dev \
        python3-opencv \
        libglib2.0-0

# Entrar no diretório de trabalho do container
WORKDIR /traducao-amanda-container

# Copiar os requirements para o container
COPY ./requirements.txt ./

# Instalar pacotes especificados nos requirements
RUN python3 -m pip install -r requirements.txt

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# Instalar PyTorch e torchvision
RUN pip3 install torch torchvision torchaudio -f https://download.pytorch.org/whl/cu111/torch_stable.html

RUN pip install --pre onnxruntime-genai-cuda --index-url=https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-genai/pypi/simple/

# Copia todo o projeto para dentro do container
COPY ./ ./

# Entrar na pasta code-container
WORKDIR /traducao-amanda-container/code-container

# Set the entrypoint
ENTRYPOINT ["python3","run.py"]s
