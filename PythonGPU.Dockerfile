FROM nvidia/cuda:12.4.1-base-ubuntu20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
# Adicionando variavel de ambiente
# ENV CUDA_HOME = /usr/local/cuda-12.4
# ENV PATH=${CUDA_HOME}/bin:${PATH}

# Install system dependencies
RUN apt-get update 

RUN apt-get install -y curl
RUN apt-get install -y git
RUN apt-get install -y python3-pip
RUN apt-get install -y python3-dev
RUN apt-get install -y python3-opencv
RUN apt-get install -y libglib2.0-0
#RUN apt-get install -y cuda-11.0
#RUN apt-get install -y cuda-11.7
RUN apt-get install -y libcudnn8
RUN apt-get install -y libcudnn8-dev

# Esse comando funciona, mas o nvcc --version é 10.1. Muito antigo.
# RUN apt-get install -y nvidia-cuda-toolkit

# instalação do nvidia cuda toolkit mais recente
RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
RUN apt-get update
RUN apt-get install -y nvidia-container-toolkit

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
#RUN pip3 install torch==2.0.0 torchvision==0.15.1 torchaudio==2.0.1


# Instalar onnxruntime-genai-cuda
#RUN pip3 install onnxruntime-genai-cuda --pre --index-url=https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-genai/pypi/simple/

RUN pip3 install tensorrt

RUN pip3 install tiktoken

RUN pip3 install einops

RUN pip3 install pytest

RUN pip3 install packaging

RUN pip3 install ninja

# Para interropmer o container e debugar
# acessar o container com o comando docker exec -it <id> bash
ENTRYPOINT ["tail", "-f", "/dev/null"]

# RUN CUDA_HOME=/usr/local/cuda-12.2.1 pip3 install flash-attn --no-build-isolation
#RUN pip3 install flash-attn --no-build-isolation

# Copia todo o projeto para dentro do container
#COPY ./ ./

# # Entrar na pasta code-container
#WORKDIR /traducao-amanda-container/code-container

# # Set the entrypoint
#ENTRYPOINT ["python3","run.py"]
