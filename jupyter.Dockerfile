FROM python:3.9

# Entrar no diretório de trabalho do container
WORKDIR /traducao-amanda-container

# Copiar os requirements para o container
COPY ./requirements.txt ./

# Instalar pacotes especificados nos requirements
COPY requirements.txt /requirements.txt 

RUN pip3 install -r requirements.txt --progress-bar off

# Instalar Jupyter
RUN pip3 install jupyterlab --progress-bar off

# Copia todo o projeto para dentro do container
COPY ./ ./

# Set the entrypoint
ENTRYPOINT ["jupyter","lab","--ip","0.0.0.0","--no-browser","--allow-root"]

# Expose the port Jupyter Notebook will use
EXPOSE 8888
