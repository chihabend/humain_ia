# 🚀 ÉTAPES EXACTES - Déploiement Google Cloud

## ⚠️ IMPORTANT: Suivez ces étapes dans l'ordre exact !

### ÉTAPE 1: Installation de Google Cloud SDK

1. **Allez sur** : https://cloud.google.com/sdk/docs/install
2. **Téléchargez** "Google Cloud CLI" pour Windows
3. **Installez** en suivant les instructions
4. **Redémarrez PowerShell** après installation

### ÉTAPE 2: Vérification de l'installation

Ouvrez un **nouveau** PowerShell et tapez :
```powershell
gcloud --version
```

Si vous voyez la version, c'est bon ! Sinon, réinstallez.

### ÉTAPE 3: Création du projet Google Cloud

1. **Allez sur** : https://console.cloud.google.com/
2. **Créez un nouveau projet** (ou utilisez un existant)
3. **Notez le PROJECT_ID** (ex: `mon-projet-ia-123`)
4. **Activez la facturation** pour ce projet

### ÉTAPE 4: Commandes de déploiement

**Copiez et collez ces commandes une par une** :

```powershell
# 1. Authentification
gcloud auth login

# 2. Configuration du projet (remplacez YOUR_PROJECT_ID)
gcloud config set project YOUR_PROJECT_ID

# 3. Activation des APIs
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable aiplatform.googleapis.com
gcloud services enable storage.googleapis.com

# 4. Création du bucket (remplacez YOUR_BUCKET_NAME)
gsutil mb -l europe-west1 gs://YOUR_BUCKET_NAME

# 5. Upload des données
gsutil cp ia_training/data/humanization_pairs.csv gs://YOUR_BUCKET_NAME/data/

# 6. Déploiement
gcloud builds submit --config cloudbuild.yaml .

# 7. Configuration des variables d'environnement
gcloud run services update ia-training-service --region=europe-west1 --set-env-vars="GCS_BUCKET_NAME=YOUR_BUCKET_NAME,DOWNLOAD_FROM_GCS=true,UPLOAD_TO_GCS=true,BATCH_SIZE=8,NUM_EPOCHS=3,LEARNING_RATE=5e-5,USE_TENSORBOARD=true"
```

### ÉTAPE 5: Vérification

```powershell
# Voir les services déployés
gcloud run services list --region=europe-west1

# Voir les logs
gcloud run services logs tail ia-training-service --region=europe-west1
```

## 🎯 Exemple avec des vraies valeurs

Si votre PROJECT_ID est `mon-projet-ia-123` et votre bucket `mon-bucket-ia` :

```powershell
gcloud config set project mon-projet-ia-123
gsutil mb -l europe-west1 gs://mon-bucket-ia
gsutil cp ia_training/data/humanization_pairs.csv gs://mon-bucket-ia/data/
gcloud builds submit --config cloudbuild.yaml .
gcloud run services update ia-training-service --region=europe-west1 --set-env-vars="GCS_BUCKET_NAME=mon-bucket-ia,DOWNLOAD_FROM_GCS=true,UPLOAD_TO_GCS=true,BATCH_SIZE=8,NUM_EPOCHS=3,LEARNING_RATE=5e-5,USE_TENSORBOARD=true"
```

## 🔗 URLs importantes

- **Console Google Cloud** : https://console.cloud.google.com/
- **Cloud Build** : https://console.cloud.google.com/cloud-build/builds
- **Cloud Run** : https://console.cloud.google.com/run
- **Facturation** : https://console.cloud.google.com/billing

## 💰 Coûts

- **Entraînement** : ~$2-5 par session
- **Stockage** : ~$0.02/GB/mois
- **Service web** : ~$0.00002400/second

## 🆘 En cas de problème

### Erreur "gcloud not found"
- Réinstallez Google Cloud SDK
- Redémarrez PowerShell

### Erreur "Permission denied"
```powershell
gcloud auth application-default login
```

### Erreur "Quota exceeded"
- Vérifiez votre facturation
- Attendez quelques minutes

## 🎉 Résultat final

Après le déploiement, vous aurez :
- ✅ Votre modèle d'IA sur Google Cloud
- ✅ URL : https://ia-training-service-YOUR_PROJECT_ID.run.app
- ✅ TensorBoard pour le monitoring
- ✅ Stockage sécurisé de vos données

**Commencez par l'installation de Google Cloud SDK !** 🚀 