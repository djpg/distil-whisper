# Usa la imagen base de Hugging Face con PyTorch y soporte para GPU
FROM huggingface/transformers-pytorch-gpu:4.41.2

# Actualiza e instala nano e ipython
RUN apt-get update && apt-get install -y nano
RUN python3 -m pip install --upgrade pip && pip install ipython

# Clona el repositorio y configura el entorno
RUN git clone https://github.com/djpg/distil-whisper.git \  # https://github.com/huggingface/distil-whisper.git
    && cd distil-whisper \
    && git remote add upstream https://github.com/huggingface/distil-whisper.git \
    && cd training \
    && pip install -e .

# Configura Git para almacenar las credenciales y hacer login en Hugging Face
RUN git config --global credential.helper store
# Define el token de Hugging Face y lo usa para hacer login
RUN python -c 'from huggingface_hub.commands.user import _login; _login(token=TOKEN)'

# Define el token de Weights & Biases y lo configura en el entorno
ENV WANDB_API_KEY=

# Define el directorio de trabajo
WORKDIR /distil-whisper/training

# Comando por defecto al iniciar el contenedor
CMD ["bash"]
