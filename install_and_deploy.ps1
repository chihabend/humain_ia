# Script PowerShell pour installer Google Cloud SDK et déployer le projet
# Usage: .\install_and_deploy.ps1

Write-Host "🚀 Installation et Déploiement Google Cloud" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# Étape 1: Vérifier si gcloud est installé
Write-Host "[1/8] Vérification de Google Cloud SDK..." -ForegroundColor Yellow
try {
    $gcloudVersion = gcloud --version 2>$null
    if ($gcloudVersion) {
        Write-Host "✅ Google Cloud SDK déjà installé" -ForegroundColor Green
        $gcloudInstalled = $true
    }
} catch {
    $gcloudInstalled = $false
}

# Étape 2: Installer Google Cloud SDK si nécessaire
if (-not $gcloudInstalled) {
    Write-Host "[2/8] Installation de Google Cloud SDK..." -ForegroundColor Yellow
    
    # Télécharger l'installateur
    $installerUrl = "https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe"
    $installerPath = "$env:TEMP\GoogleCloudSDKInstaller.exe"
    
    Write-Host "📥 Téléchargement de l'installateur..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath
    
    Write-Host "🔧 Installation en cours..." -ForegroundColor Cyan
    Write-Host "⚠️  Suivez les instructions de l'installateur et redémarrez PowerShell après installation" -ForegroundColor Red
    Start-Process -FilePath $installerPath -Wait
    
    # Nettoyer
    Remove-Item $installerPath -Force
    
    Write-Host "✅ Installation terminée. Redémarrez PowerShell et relancez ce script." -ForegroundColor Green
    Read-Host "Appuyez sur Entrée pour continuer..."
    exit
}

# Étape 3: Authentification
Write-Host "[3/8] Authentification Google Cloud..." -ForegroundColor Yellow
gcloud auth login

# Étape 4: Configuration du projet
Write-Host "[4/8] Configuration du projet..." -ForegroundColor Yellow
$projectId = Read-Host "Entrez votre PROJECT_ID Google Cloud"
gcloud config set project $projectId

# Étape 5: Configuration du bucket
Write-Host "[5/8] Configuration du bucket..." -ForegroundColor Yellow
$bucketName = Read-Host "Entrez le nom de votre bucket (ex: mon-bucket-ia)"
if (-not $bucketName) {
    $bucketName = "$projectId-ia-bucket"
    Write-Host "Utilisation du nom de bucket par défaut: $bucketName" -ForegroundColor Cyan
}

# Étape 6: Activation des APIs
Write-Host "[6/8] Activation des APIs Google Cloud..." -ForegroundColor Yellow
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable aiplatform.googleapis.com
gcloud services enable storage.googleapis.com

# Étape 7: Création du bucket et upload des données
Write-Host "[7/8] Préparation du stockage..." -ForegroundColor Yellow
try {
    gsutil mb -l europe-west1 gs://$bucketName 2>$null
    Write-Host "✅ Bucket créé ou existe déjà" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Erreur lors de la création du bucket, continuation..." -ForegroundColor Yellow
}

# Upload des données d'entraînement
if (Test-Path "ia_training/data/humanization_pairs.csv") {
    Write-Host "📤 Upload des données d'entraînement..." -ForegroundColor Cyan
    gsutil cp ia_training/data/humanization_pairs.csv gs://$bucketName/data/
    Write-Host "✅ Données uploadées" -ForegroundColor Green
} else {
    Write-Host "⚠️  Fichier de données non trouvé" -ForegroundColor Yellow
}

# Étape 8: Déploiement
Write-Host "[8/8] Déploiement du projet..." -ForegroundColor Yellow
Write-Host "🏗️  Construction et déploiement en cours..." -ForegroundColor Cyan
gcloud builds submit --config cloudbuild.yaml .

Write-Host ""
Write-Host "🎉 DÉPLOIEMENT TERMINÉ!" -ForegroundColor Green
Write-Host "=======================" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Informations du déploiement:" -ForegroundColor Cyan
Write-Host "   Project ID: $projectId" -ForegroundColor White
Write-Host "   Bucket: $bucketName" -ForegroundColor White
Write-Host "   Service URL: https://ia-training-service-$projectId.run.app" -ForegroundColor White
Write-Host ""
Write-Host "🔗 Liens utiles:" -ForegroundColor Cyan
Write-Host "   Console Google Cloud: https://console.cloud.google.com/" -ForegroundColor White
Write-Host "   Cloud Build: https://console.cloud.google.com/cloud-build/builds" -ForegroundColor White
Write-Host "   Cloud Run: https://console.cloud.google.com/run" -ForegroundColor White
Write-Host ""
Write-Host "📈 Pour monitorer l'entraînement:" -ForegroundColor Cyan
Write-Host "   gcloud run services logs tail ia-training-service --region=europe-west1" -ForegroundColor White
Write-Host ""
Write-Host "💰 Coûts estimés: ~$2-5 par session d'entraînement" -ForegroundColor Yellow

Read-Host "Appuyez sur Entrée pour terminer..." 