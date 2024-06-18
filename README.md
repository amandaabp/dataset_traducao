# dataset_traducao

## Executar com Docker Compose

Para executar o script com Docker Compose, use
```bash
docker-compose up -d
```

Para deletar o container e a imagem com Docker Compose, use
```bash
docker-compose down --rmi 'all'
```

## Executar com venv

Crianção da venv
```bash
python3 -m venv .venv
``` 

Ativação da venv
```bash
source .venv/bin/activate
``` 

Instalação dos requisitos
```bash
pip install -r requirements.txt
``` 
Execução do script
```bash
Python3 code/ScriptMTEB.py
``` 

Desativação da venv
```bash
deactivate
``` 