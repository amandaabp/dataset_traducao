FROM nvcr.io/nvidia/pytorch:21.02-py3

RUN pip install transformers datasets accelerate jupyterlab

WORKDIR /traducao-amanda-container/code 

COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY ./ ./

# Install Jupyter kernel inside the container
RUN python -m ipykernel install --user --name=python-gpu

ENTRYPOINT ["jupyter", "lab", "--ip", "0.0.0.0", "--no-browser", "--allow-root"]
