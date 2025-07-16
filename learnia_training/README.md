# learnia_training

Ce dossier contient tout le nécessaire pour entraîner le modèle LearnIA sur un serveur.

## Structure

- `train_humanizer_custom.py` : Script principal d'entraînement
- `generate_synthetic_data.py` : Génération de données synthétiques (optionnel)
- `requirements.txt` : Dépendances Python nécessaires
- `data/` : Dossier contenant les datasets d'entraînement (ex : `humanization_pairs.csv`)
- `humanizer_model/` : Dossier où seront sauvegardés les checkpoints du modèle après entraînement

## Utilisation

1. Installez les dépendances :
   ```bash
   pip install -r requirements.txt
   ```
2. Lancez l'entraînement :
   ```bash
   python train_humanizer_custom.py
   ```
3. Les modèles entraînés seront sauvegardés dans `humanizer_model/`

**Remarque :**
- Vous pouvez ajouter vos propres datasets dans `data/`.
- Le script `generate_synthetic_data.py` est optionnel, utile pour augmenter vos données. 