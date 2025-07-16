# Script PowerShell simplifié pour déployer sur Google Cloud
Write-Host "🚀 Déploiement Google Cloud - Version Simplifiée" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""

# Vérifier gcloud
Write-Host "Vérification de Google Cloud SDK..." -ForegroundColor Yellow
try {
    gcloud --version | Out-Null
    Write-Host "✅ Google Cloud SDK OK" -ForegroundColor Green
} catch {
    Write-Host "❌ Google Cloud SDK non trouvé!" -ForegroundColor Red
    Write-Host "Installez depuis: https://cloud.google.com/sdk/docs/install" -ForegroundColor Yellow
    Read-Host "Appuyez sur Entrée pour continuer..."
    exit
}

# Authentification
Write-Host "Authentification..." -ForegroundColor Yellow
gcloud auth login

# Configuration
$projectId = Read-Host "Entrez votre PROJECT_ID"
gcloud config set project $projectId

$bucketName = Read-Host "Entrez le nom de votre bucket (ou appuyez sur Entrée pour utiliser $projectId-ia-bucket)"
if (-not $bucketName) {
    $bucketName = "$projectId-ia-bucket"
}

# Activation des APIs
Write-Host "Activation des APIs..." -ForegroundColor Yellow
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable aiplatform.googleapis.com
gcloud services enable storage.googleapis.com

# Création du bucket
Write-Host "Création du bucket..." -ForegroundColor Yellow
gsutil mb -l europe-west1 gs://$bucketName

# Upload des données
if (Test-Path "ia_training/data/humanization_pairs.csv") {
    Write-Host "Upload des données..." -ForegroundColor Yellow
    gsutil cp ia_training/data/humanization_pairs.csv gs://$bucketName/data/
}

# Déploiement
Write-Host "Déploiement en cours..." -ForegroundColor Yellow
gcloud builds submit --config cloudbuild.yaml .

Write-Host ""
Write-Host "🎉 DÉPLOIEMENT TERMINÉ!" -ForegroundColor Green
Write-Host "URL du service: https://ia-training-service-$projectId.run.app" -ForegroundColor Cyan
Write-Host "Bucket: $bucketName" -ForegroundColor Cyan
Read-Host "Appuyez sur Entrée pour terminer..." 