import pandas as pd
from datasets import Dataset
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM, TrainingArguments, Trainer

MODEL_NAME = "t5-small"
tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
model = AutoModelForSeq2SeqLM.from_pretrained(MODEL_NAME)

# Charge ton CSV (colonnes: input, target)
df = pd.read_csv("data/humanization_pairs.csv")
dataset = Dataset.from_pandas(df)

def preprocess(example):
    return tokenizer(
        example["input"],
        text_target=example["target"],
        truncation=True,
        padding="max_length",
        max_length=128
    )

tokenized = dataset.map(preprocess)

args = TrainingArguments(
    output_dir="./humanizer_model",
    per_device_train_batch_size=8,
    num_train_epochs=3,
    save_steps=500,
    save_total_limit=2,
    logging_steps=100
)

trainer = Trainer(
    model=model,
    args=args,
    train_dataset=tokenized,
    tokenizer=tokenizer,
)

trainer.train()
model.save_pretrained("./humanizer_model")
tokenizer.save_pretrained("./humanizer_model") 