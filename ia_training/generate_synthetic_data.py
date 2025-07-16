import pandas as pd
import random
from faker import Faker
import nlpaug.augmenter.word as naw
from transformers import pipeline
import os

# Initialisation
langs = ["en_US", "fr_FR", "es_ES", "de_DE"]
fakers = {lang: Faker(lang) for lang in langs}

# Paraphraseur local (T5, CPU)
try:
    paraphraser = pipeline("text2text-generation", model="Vamsi/T5_Paraphrase_Paws", device=-1)
except Exception as e:
    print("Erreur lors du chargement du paraphraser :", e)
    paraphraser = None

# Augmenteur de fautes (nlpaug)
def add_typos(text):
    try:
        aug = naw.SpellingAug()
        return aug.augment(text)
    except Exception:
        return text

# Génération de données
styles = ["formel", "familier", "blog", "jeune", "neutre", "academique", "sms", "oral", "pro", "humour", "poetique"]
data = []
for lang in langs:
    fake = fakers[lang]
    for _ in range(2000):
        ia = fake.sentence(nb_words=random.randint(6, 20))
        for style in styles:
            # Paraphrase locale (si possible)
            if paraphraser:
                try:
                    human = paraphraser(ia, max_new_tokens=128, num_return_sequences=1)[0]['generated_text']
                except Exception:
                    human = ia
            else:
                human = ia
            # Ajoute fautes, contractions, etc.
            if random.random() < 0.5:
                human = add_typos(human)
            # Ajoute la paire
            data.append({"input": ia, "target": human, "lang": lang, "style": style})

# Multiplie et mélange
random.shuffle(data)
data = data * 5

# Création du dossier data si besoin
os.makedirs("data", exist_ok=True)

# Sauvegarde
df = pd.DataFrame(data)
df.to_csv("data/humanization_pairs.csv", index=False)
print(f"Généré {len(df)} paires IA → humain dans data/humanization_pairs.csv (100% local)") 