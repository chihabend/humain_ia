import pandas as pd
from datasets import Dataset
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM, TrainingArguments, Trainer
import sys
import traceback

MODEL_NAME = "t5-small"
BATCH_SIZE = 1000  # Nombre de lignes à traiter à la fois
CSV_PATH = "data/humanization_pairs.csv"

print("[LOG] Début du script d'entraînement.")
try:
    print(f"[LOG] Chargement du tokenizer et du modèle : {MODEL_NAME}")
    tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
    model = AutoModelForSeq2SeqLM.from_pretrained(MODEL_NAME)
except Exception as e:
    print(f"[ERREUR] Problème lors du chargement du modèle/tokenizer : {e}")
    traceback.print_exc()
    sys.exit(1)

def preprocess(example):
    try:
        return tokenizer(
            example["input"],
            text_target=example["target"],
            truncation=True,
            padding="max_length",
            max_length=128
        )
    except Exception as e:
        print(f"[ERREUR] Problème lors du prétraitement d'un exemple : {e}")
        return {}

try:
    chunk_iter = pd.read_csv(CSV_PATH, chunksize=BATCH_SIZE)
except Exception as e:
    print(f"[ERREUR] Impossible de lire le fichier CSV {CSV_PATH} : {e}")
    traceback.print_exc()
    sys.exit(1)

for i, chunk in enumerate(chunk_iter):
    try:
        print(f"[LOG] Traitement du batch {i+1}")
        if chunk.empty:
            print(f"[LOG] Batch {i+1} vide, on passe au suivant.")
            continue
        dataset = Dataset.from_pandas(chunk)
        print(f"[LOG] Prétraitement du batch {i+1}...")
        tokenized = dataset.map(preprocess)
        print(f"[LOG] Données tokenisées pour le batch {i+1}.")

        args = TrainingArguments(
            output_dir="./humanizer_model",
            per_device_train_batch_size=8,
            num_train_epochs=1,  # 1 epoch par batch pour éviter la surcharge
            save_steps=500,
            save_total_limit=2,
            logging_steps=100
        )

        print(f"[LOG] Initialisation du Trainer pour le batch {i+1}...")
        trainer = Trainer(
            model=model,
            args=args,
            train_dataset=tokenized,
            tokenizer=tokenizer,
        )

        print(f"[LOG] Entraînement sur le batch {i+1}...")
        trainer.train()
        print(f"[LOG] Batch {i+1} terminé. Sauvegarde du modèle...")
        model.save_pretrained("./humanizer_model")
        tokenizer.save_pretrained("./humanizer_model")
    except Exception as e:
        print(f"[ERREUR] Problème lors du traitement du batch {i+1} : {e}")
        traceback.print_exc()
        continue

print("[LOG] Entraînement terminé sur tous les batchs.") 