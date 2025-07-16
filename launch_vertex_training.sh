#!/bin/bash

# Script pour lancer l'entraînement sur Vertex AI
# Usage: ./launch_vertex_training.sh [PROJECT_ID] [BUCKET_NAME]

set -e

PROJECT_ID=${1:-"your-project-id"}
BUCKET_NAME=${2:-"your-bucket-name"}
REGION="europe-west1"

echo "🚀 Lancement de l'entraînement sur Vertex AI..."
echo "Project ID: $PROJECT_ID"
echo "Bucket: $BUCKET_NAME"
echo "Region: $REGION"

# 1. Configuration du projet
gcloud config set project $PROJECT_ID

# 2. Activer Vertex AI API
gcloud services enable aiplatform.googleapis.com

# 3. Mettre à jour la configuration Vertex AI
sed -i "s/PROJECT_ID/$PROJECT_ID/g" vertex_ai_config.yaml
sed -i "s/your-bucket-name/$BUCKET_NAME/g" vertex_ai_config.yaml

# 4. Créer le TensorBoard instance
echo "📊 Création de l'instance TensorBoard..."
gcloud ai tensorboards create \
  --display-name="humanizer-training-tensorboard" \
  --region=$REGION

# 5. Lancer le job d'entraînement
echo "🎯 Lancement du job d'entraînement..."
gcloud ai custom-jobs create \
  --region=$REGION \
  --config=vertex_ai_config.yaml

echo "✅ Job d'entraînement lancé!"
echo ""
echo "📈 Pour monitorer l'entraînement:"
echo "1. Console Vertex AI: https://console.cloud.google.com/vertex-ai/training/custom-jobs"
echo "2. TensorBoard: https://console.cloud.google.com/vertex-ai/experiments/tensorboard"
echo ""
echo "📊 Pour voir les logs:"
echo "gcloud ai custom-jobs list --region=$REGION"
echo ""
echo "🔄 Pour arrêter le job:"
echo "gcloud ai custom-jobs cancel JOB_ID --region=$REGION" 