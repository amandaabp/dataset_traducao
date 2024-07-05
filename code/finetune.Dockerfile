FROM nvidia/docker:latest

WORKDIR /app

COPY requirements.txt ./
RUN pip install -U FlagEmbedding

# Copia todo o projeto para dentro do container
COPY ./ ./

CMD ["python3", "-m", "FlagEmbedding.baai_general_embedding.finetune.run",
    "--output_dir", "resultado_modelo",
    "--model_name_or_path", "BAAI/bge-large-zh-v1.5",
    "--train_data", "dados_concatenados.jsonl",
    "--learning_rate", "2e-5",
    "--fp16",
    "--num_train_epochs", "3",
    "--per_device_train_batch_size", "32",
    "--dataloader_drop_last", "True",
    "--normlized", "True",
    "--temperature", "0.02",
    "--query_max_len", "64",
    "--passage_max_len", "256",
    "--train_group_size", "2",
    "--logging_steps", "10",
    "--save_steps", "10000"]
