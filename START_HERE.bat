@echo off
echo ========================================
echo    DEPLOIEMENT IA SUR GOOGLE CLOUD
echo ========================================
echo.

echo [1/5] Verification de Google Cloud SDK...
gcloud --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Google Cloud SDK non installe!
    echo.
    echo 📥 TELECHARGEZ ET INSTALLEZ:
    echo https://cloud.google.com/sdk/docs/install
    echo.
    echo Apres installation, relancez ce script.
    pause
    exit /b 1
)
echo ✅ Google Cloud SDK OK

echo.
echo [2/5] Authentification Google Cloud...
gcloud auth login

echo.
echo [3/5] Configuration du projet...
set /p PROJECT_ID="Entrez votre PROJECT_ID Google Cloud: "
gcloud config set project %PROJECT_ID%

echo.
echo [4/5] Configuration du bucket...
set /p BUCKET_NAME="Entrez le nom de votre bucket (ex: mon-bucket-ia): "

echo.
echo [5/5] Lancement du deployement...
echo.
echo 🚀 Deploiement en cours...
echo Project ID: %PROJECT_ID%
echo Bucket: %BUCKET_NAME%
echo.

REM Rendre le script deploy_gcp.sh executable (si Git Bash disponible)
where bash >nul 2>&1
if %errorlevel% equ 0 (
    bash deploy_gcp.sh %PROJECT_ID% %BUCKET_NAME%
) else (
    echo ⚠️  Bash non trouve. Utilisez Git Bash ou WSL.
    echo.
    echo COMMANDES MANUELLES:
    echo 1. Ouvrez Git Bash
    echo 2. Naviguez vers ce dossier
    echo 3. Lancez: ./deploy_gcp.sh %PROJECT_ID% %BUCKET_NAME%
)

echo.
echo ✅ Configuration terminee!
echo.
echo 📋 PROCHAINES ETAPES:
echo 1. Installez Google Cloud SDK si pas fait
echo 2. Lancez ce script a nouveau
echo 3. Ou utilisez les commandes manuelles ci-dessus
echo.
pause 