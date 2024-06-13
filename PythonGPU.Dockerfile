FROM nvidia/cuda:12.4.1-base-ubuntu20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
# Adicionando variavel de ambiente
# ENV CUDA_HOME = /usr/local/cuda-12.4
# ENV PATH=${CUDA_HOME}/bin:${PATH}

# Install system dependencies
RUN apt-get update 

RUN apt-get install -y git
RUN apt-get install -y python3-pip
RUN apt-get install -y python3-dev
RUN apt-get install -y python3-opencv
RUN apt-get install -y libglib2.0-0
#RUN apt-get install -y cuda-11.0
RUN apt-get install -y cuda-11.7
RUN apt-get install -y libcudnn8
RUN apt-get install -y libcudnn8-dev

# Entrar no diretório de trabalho do container
WORKDIR /traducao-amanda-container

# Copiar os requirements para o container
COPY ./requirements.txt ./

# Upgrade pip
RUN python3 -m pip install --upgrade pip


# Instalar pacotes especificados nos requirements
RUN python3 -m pip install -r requirements.txt

# Instalar PyTorch e torchvision
RUN pip3 install torch torchvision torchaudio -f https://download.pytorch.org/whl/cu111/torch_stable.html

# Instalar onnxruntime-genai-cuda
#RUN pip3 install onnxruntime-genai-cuda --pre --index-url=https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-genai/pypi/simple/

RUN pip3 install tensorrt

RUN pip3 install tiktoken

RUN pip3 install einops

RUN pip3 install pytest

RUN CUDA_HOME = /usr/local/cuda-11.7 pip3 install 'flash-attn==1.0.4'
# Copia todo o projeto para dentro do container
COPY ./ ./

# Entrar na pasta code-container
WORKDIR /traducao-amanda-container/code-container

# Set the entrypoint
ENTRYPOINT ["python3","run.py"]