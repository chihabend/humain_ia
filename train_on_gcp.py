import os
import pandas as pd
from datasets import Dataset
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM, TrainingArguments, Trainer
import torch
from google.cloud import storage
import logging

# Configuration du logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def download_data_from_gcs(bucket_name, source_blob_name, destination_file_name):
    """Télécharge les données depuis Google Cloud Storage"""
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(source_blob_name)
    blob.download_to_filename(destination_file_name)
    logger.info(f"Données téléchargées: {destination_file_name}")

def upload_model_to_gcs(bucket_name, source_directory, destination_blob_name):
    """Uploade le modèle entraîné vers Google Cloud Storage"""
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    
    for root, dirs, files in os.walk(source_directory):
        for file in files:
            local_path = os.path.join(root, file)
            blob_path = os.path.join(destination_blob_name, os.path.relpath(local_path, source_directory))
            blob = bucket.blob(blob_path)
            blob.upload_from_filename(local_path)
            logger.info(f"Fichier uploadé: {blob_path}")

def main():
    # Configuration
    MODEL_NAME = "t5-small"
    BUCKET_NAME = os.getenv("GCS_BUCKET_NAME", "your-bucket-name")
    DATA_FILE = "data/humanization_pairs.csv"
    MODEL_DIR = "./humanizer_model"
    
    logger.info("Début de l'entraînement du modèle...")
    
    # Télécharger les données depuis GCS si nécessaire
    if os.getenv("DOWNLOAD_FROM_GCS", "false").lower() == "true":
        download_data_from_gcs(BUCKET_NAME, "data/humanization_pairs.csv", DATA_FILE)
    
    # Charger le tokenizer et le modèle
    logger.info("Chargement du tokenizer et du modèle...")
    tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
    model = AutoModelForSeq2SeqLM.from_pretrained(MODEL_NAME)
    
    # Charger les données
    logger.info("Chargement des données...")
    df = pd.read_csv(DATA_FILE)
    dataset = Dataset.from_pandas(df)
    
    def preprocess(example):
        return tokenizer(
            example["input"],
            text_target=example["target"],
            truncation=True,
            padding="max_length",
            max_length=128
        )
    
    # Tokeniser les données
    logger.info("Tokenisation des données...")
    tokenized = dataset.map(preprocess)
    
    # Configuration de l'entraînement
    training_args = TrainingArguments(
        output_dir=MODEL_DIR,
        per_device_train_batch_size=int(os.getenv("BATCH_SIZE", "8")),
        num_train_epochs=int(os.getenv("NUM_EPOCHS", "3")),
        save_steps=500,
        save_total_limit=2,
        logging_steps=100,
        learning_rate=float(os.getenv("LEARNING_RATE", "5e-5")),
        warmup_steps=int(os.getenv("WARMUP_STEPS", "500")),
        weight_decay=float(os.getenv("WEIGHT_DECAY", "0.01")),
        logging_dir="./logs",
        report_to="tensorboard" if os.getenv("USE_TENSORBOARD", "false").lower() == "true" else None,
    )
    
    # Initialiser le trainer
    trainer = Trainer(
        model=model,
        args=training_args,
        train_dataset=tokenized,
        tokenizer=tokenizer,
    )
    
    # Entraîner le modèle
    logger.info("Début de l'entraînement...")
    trainer.train()
    
    # Sauvegarder le modèle
    logger.info("Sauvegarde du modèle...")
    model.save_pretrained(MODEL_DIR)
    tokenizer.save_pretrained(MODEL_DIR)
    
    # Upload vers GCS si configuré
    if os.getenv("UPLOAD_TO_GCS", "false").lower() == "true":
        logger.info("Upload du modèle vers Google Cloud Storage...")
        upload_model_to_gcs(BUCKET_NAME, MODEL_DIR, "models/humanizer_model")
    
    logger.info("Entraînement terminé avec succès!")

if __name__ == "__main__":
    main() 