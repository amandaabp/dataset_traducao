FROM python:3.9

# Entrar no diretório de trabalho do container
WORKDIR /traducao-amanda-container

# Copiar os requirements para o container
COPY ./requirements.txt ./

# Instalar pacotes especificados nos requirements
COPY requirements.txt /requirements.txt 

# Upgrade pip e Instalar pacotes especificados nos requirements
RUN pip3 install --upgrade pip 
RUN pip3 install -r requirements.txt  

# Instalar Jupyter
RUN pip3 install jupyter

# Copia todo o projeto para dentro do container
COPY ./ ./

# Set the entrypoint
ENTRYPOINT ["jupyter","notebook","--ip","0.0.0.0","--no-browser","--allow-root"]

# Expose the port Jupyter Notebook will use
EXPOSE 8888
