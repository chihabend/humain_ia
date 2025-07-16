# 🚀 GUIDE RAPIDE - Déploiement IA sur Google Cloud

## ⚡ Démarrage Ultra-Rapide (5 minutes)

### 1. **Installer Google Cloud SDK**
- Allez sur : https://cloud.google.com/sdk/docs/install
- Téléchargez et installez pour Windows
- **OU** double-cliquez sur `START_HERE.bat` (il vous guidera)

### 2. **Créer un Projet Google Cloud**
- Allez sur : https://console.cloud.google.com/
- Créez un nouveau projet
- Notez le **PROJECT_ID** (ex: `mon-projet-ia-123`)

### 3. **Activer la Facturation**
- Dans la console Google Cloud
- Allez dans "Facturation"
- Activez la facturation pour votre projet

### 4. **Lancer le Déploiement**

#### Option A : Script Automatique (Recommandé)
```bash
# Double-cliquez sur START_HERE.bat
# Ou dans PowerShell/Git Bash :
./deploy_gcp.sh VOTRE_PROJECT_ID VOTRE_BUCKET_NAME
```

#### Option B : Commandes Manuelles
```bash
# 1. Authentification
gcloud auth login

# 2. Configuration du projet
gcloud config set project VOTRE_PROJECT_ID

# 3. Activation des APIs
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable aiplatform.googleapis.com

# 4. Création du bucket
gsutil mb -l europe-west1 gs://VOTRE_BUCKET_NAME

# 5. Upload des données
gsutil cp ia_training/data/humanization_pairs.csv gs://VOTRE_BUCKET_NAME/data/

# 6. Déploiement
gcloud builds submit --config cloudbuild.yaml .
```

## 🎯 Résultat Attendu

Après le déploiement, vous aurez :
- ✅ Votre modèle d'IA déployé sur Google Cloud
- ✅ Un service web accessible via URL
- ✅ TensorBoard pour monitorer l'entraînement
- ✅ Stockage sécurisé de vos données et modèles

## 💰 Coûts Estimés

- **Entraînement** : ~$2-5 par session
- **Stockage** : ~$0.02/GB/mois
- **Service web** : ~$0.00002400/second (quand utilisé)

## 🔧 Dépannage Rapide

### Erreur "gcloud not found"
- Installez Google Cloud SDK
- Redémarrez PowerShell

### Erreur "Permission denied"
```bash
gcloud auth application-default login
```

### Erreur "Quota exceeded"
- Vérifiez votre facturation
- Attendez quelques minutes

## 📞 Support

- **Documentation** : https://cloud.google.com/docs
- **Console** : https://console.cloud.google.com/
- **Facturation** : https://console.cloud.google.com/billing

## 🎉 Félicitations !

Votre projet d'IA est maintenant sur Google Cloud ! 🚀 