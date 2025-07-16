#!/bin/bash

# Script de déploiement pour Google Cloud Platform
# Usage: ./deploy_gcp.sh [PROJECT_ID] [BUCKET_NAME]

set -e

PROJECT_ID=${1:-"your-project-id"}
BUCKET_NAME=${2:-"your-bucket-name"}
REGION="europe-west1"

echo "🚀 Déploiement sur Google Cloud Platform..."
echo "Project ID: $PROJECT_ID"
echo "Bucket: $BUCKET_NAME"
echo "Region: $REGION"

# 1. Configuration du projet
echo "📋 Configuration du projet..."
gcloud config set project $PROJECT_ID

# 2. Activer les APIs nécessaires
echo "🔧 Activation des APIs..."
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable aiplatform.googleapis.com
gcloud services enable storage.googleapis.com

# 3. Créer le bucket de stockage s'il n'existe pas
echo "🪣 Création du bucket de stockage..."
gsutil mb -l $REGION gs://$BUCKET_NAME 2>/dev/null || echo "Bucket existe déjà"

# 4. Uploader les données d'entraînement
echo "📤 Upload des données d'entraînement..."
if [ -f "ia_training/data/humanization_pairs.csv" ]; then
    gsutil cp ia_training/data/humanization_pairs.csv gs://$BUCKET_NAME/data/
else
    echo "⚠️  Fichier de données non trouvé. Créez d'abord vos données d'entraînement."
fi

# 5. Construire et déployer avec Cloud Build
echo "🏗️  Construction et déploiement..."
gcloud builds submit --config cloudbuild.yaml .

# 6. Configuration des variables d'environnement pour l'entraînement
echo "⚙️  Configuration des variables d'environnement..."
gcloud run services update ia-training-service \
    --region=$REGION \
    --set-env-vars="GCS_BUCKET_NAME=$BUCKET_NAME" \
    --set-env-vars="DOWNLOAD_FROM_GCS=true" \
    --set-env-vars="UPLOAD_TO_GCS=true" \
    --set-env-vars="BATCH_SIZE=8" \
    --set-env-vars="NUM_EPOCHS=3" \
    --set-env-vars="LEARNING_RATE=5e-5" \
    --set-env-vars="USE_TENSORBOARD=true"

echo "✅ Déploiement terminé!"
echo "🌐 URL du service: https://ia-training-service-$(gcloud config get-value project).run.app"
echo "📊 TensorBoard: gs://$BUCKET_NAME/logs"
echo "🤖 Modèles entraînés: gs://$BUCKET_NAME/models/"

# 7. Instructions pour lancer l'entraînement
echo ""
echo "🎯 Pour lancer l'entraînement:"
echo "1. Accédez à l'URL du service ci-dessus"
echo "2. Ou utilisez: gcloud run jobs execute ia-training-job --region=$REGION"
echo ""
echo "📈 Pour monitorer l'entraînement:"
echo "tensorboard --logdir=gs://$BUCKET_NAME/logs" 