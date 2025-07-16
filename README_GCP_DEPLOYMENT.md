# 🚀 Guide de Déploiement IA sur Google Cloud Platform

Ce guide vous explique comment déployer votre projet d'entraînement IA sur Google Cloud Platform.

## 📋 Prérequis

1. **Compte Google Cloud Platform** avec facturation activée
2. **Google Cloud SDK** installé localement
3. **Docker** installé (optionnel, pour tests locaux)

## 🔧 Installation et Configuration

### 1. Installation de Google Cloud SDK

```bash
# Windows (PowerShell)
# Téléchargez depuis: https://cloud.google.com/sdk/docs/install

# Linux/Mac
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
```

### 2. Authentification et Configuration

```bash
# Authentification
gcloud auth login

# Configuration du projet
gcloud config set project YOUR_PROJECT_ID

# Vérification
gcloud config list
```

## 🚀 Déploiement Automatique

### Option 1: Script Automatique (Recommandé)

```bash
# Rendre le script exécutable
chmod +x deploy_gcp.sh

# Lancer le déploiement
./deploy_gcp.sh YOUR_PROJECT_ID YOUR_BUCKET_NAME
```

### Option 2: Déploiement Manuel

#### Étape 1: Préparation des Données

```bash
# Créer un bucket de stockage
gsutil mb -l europe-west1 gs://YOUR_BUCKET_NAME

# Uploader les données d'entraînement
gsutil cp ia_training/data/humanization_pairs.csv gs://YOUR_BUCKET_NAME/data/
```

#### Étape 2: Activation des APIs

```bash
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable aiplatform.googleapis.com
gcloud services enable storage.googleapis.com
```

#### Étape 3: Construction et Déploiement

```bash
# Construire l'image Docker
gcloud builds submit --config cloudbuild.yaml .
```

## 🎯 Options d'Entraînement

### 1. Cloud Run (Recommandé pour les petits modèles)

```bash
# Déployer le service d'entraînement
gcloud run deploy ia-training-service \
  --image gcr.io/YOUR_PROJECT_ID/ia-training:latest \
  --region europe-west1 \
  --platform managed \
  --memory 4Gi \
  --cpu 2 \
  --set-env-vars="GCS_BUCKET_NAME=YOUR_BUCKET_NAME"
```

### 2. Vertex AI (Pour les gros modèles)

```bash
# Créer un job d'entraînement personnalisé
gcloud ai custom-jobs create \
  --region=europe-west1 \
  --display-name="humanizer-training" \
  --worker-pool-spec=machine-type=n1-standard-4,replica-count=1,container-image-uri=gcr.io/YOUR_PROJECT_ID/ia-training:latest
```

### 3. Compute Engine (Pour un contrôle total)

```bash
# Créer une instance avec GPU
gcloud compute instances create training-instance \
  --zone=europe-west1-b \
  --machine-type=n1-standard-4 \
  --accelerator="type=nvidia-tesla-t4,count=1" \
  --image-family=debian-11 \
  --image-project=debian-cloud \
  --maintenance-policy=TERMINATE \
  --restart-on-failure
```

## 📊 Monitoring et Logs

### TensorBoard

```bash
# Lancer TensorBoard localement
tensorboard --logdir=gs://YOUR_BUCKET_NAME/logs

# Ou utiliser Cloud Shell
gcloud cloud-shell ssh --command="tensorboard --logdir=gs://YOUR_BUCKET_NAME/logs --port=8080"
```

### Logs Cloud Run

```bash
# Voir les logs en temps réel
gcloud run services logs tail ia-training-service --region=europe-west1
```

## 🔄 Variables d'Environnement

| Variable | Description | Défaut |
|----------|-------------|---------|
| `GCS_BUCKET_NAME` | Nom du bucket GCS | `your-bucket-name` |
| `DOWNLOAD_FROM_GCS` | Télécharger les données depuis GCS | `false` |
| `UPLOAD_TO_GCS` | Uploader le modèle vers GCS | `false` |
| `BATCH_SIZE` | Taille du batch d'entraînement | `8` |
| `NUM_EPOCHS` | Nombre d'époques | `3` |
| `LEARNING_RATE` | Taux d'apprentissage | `5e-5` |
| `USE_TENSORBOARD` | Activer TensorBoard | `false` |

## 💰 Estimation des Coûts

### Cloud Run
- **Mémoire**: 4Gi = ~$0.00002400/second
- **CPU**: 2 vCPU = ~$0.00002400/second
- **Entraînement typique**: ~$2-5 par session

### Vertex AI
- **n1-standard-4**: ~$0.19/heure
- **Avec GPU T4**: ~$0.35/heure supplémentaire

### Storage
- **Standard**: $0.020/GB/mois
- **Modèle typique**: ~50-200MB

## 🛠️ Dépannage

### Erreurs Communes

1. **Permission Denied**
   ```bash
   gcloud auth application-default login
   ```

2. **Quota Exceeded**
   ```bash
   gcloud compute regions describe europe-west1
   ```

3. **Out of Memory**
   - Augmenter la mémoire dans `cloudbuild.yaml`
   - Réduire `BATCH_SIZE`

### Logs de Debug

```bash
# Logs détaillés
gcloud builds log [BUILD_ID]

# Logs du service
gcloud run services logs read ia-training-service --region=europe-west1
```

## 🔐 Sécurité

### Service Account

```bash
# Créer un service account
gcloud iam service-accounts create training-sa \
  --display-name="Training Service Account"

# Accorder les permissions
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:training-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.admin"
```

## 📈 Optimisation

### Performance

1. **Utiliser des instances avec GPU** pour l'entraînement
2. **Augmenter la mémoire** si nécessaire
3. **Utiliser des checkpoints** pour reprendre l'entraînement

### Coûts

1. **Arrêter les instances** après l'entraînement
2. **Utiliser des instances préemptibles** pour les tests
3. **Optimiser la taille des données**

## 🎉 Prochaines Étapes

1. **Automatiser le pipeline** avec Cloud Build
2. **Mettre en place un monitoring** avec Cloud Monitoring
3. **Créer des alertes** pour les erreurs d'entraînement
4. **Déployer le modèle** en production avec Cloud Run

## 📞 Support

- [Documentation Google Cloud](https://cloud.google.com/docs)
- [Forum Google Cloud](https://cloud.google.com/support)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/google-cloud-platform) 