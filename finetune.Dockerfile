FROM nvidia/cuda:11.1-cudnn8-base

WORKDIR /app

RUN pip install -U FlagEmbedding

COPY . .

# Definir variáveis de ambiente
ENV CUDA_VISIBLE_DEVICES=3
ENV MODEL_NAME_OR_PATH=BAAI/bge-m3
ENV TRAIN_DATA=dados_concatenados.jsonl
ENV OUTPUT_DIR=resultado_modelo

CMD [
    "python3", "-m", "FlagEmbedding.baai_general_embedding.finetune.run",
    "--output_dir", "$OUTPUT_DIR",
    "--model_name_or_path", "$MODEL_NAME_OR_PATH",
    "--train_data", "$TRAIN_DATA",
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
    "--save_steps", "10000"
]
