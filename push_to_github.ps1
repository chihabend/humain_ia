Write-Host "🚀 Envoi vers GitHub" -ForegroundColor Green
Write-Host "====================" -ForegroundColor Green
Write-Host ""

Write-Host "📝 Instructions:" -ForegroundColor Yellow
Write-Host "1. Allez sur: https://github.com/new" -ForegroundColor Cyan
Write-Host "2. Nom du dépôt: humain_ia" -ForegroundColor Cyan
Write-Host "3. Description: Projet IA Humanizer avec déploiement Google Cloud" -ForegroundColor Cyan
Write-Host "4. Choisissez Public ou Private" -ForegroundColor Cyan
Write-Host "5. NE cochez PAS 'Initialize this repository'" -ForegroundColor Cyan
Write-Host "6. Cliquez sur 'Create repository'" -ForegroundColor Cyan
Write-Host ""

$repoUrl = Read-Host "Entrez l'URL de votre dépôt créé (ex: https://github.com/votreuser/humain_ia.git)"

if ($repoUrl) {
    Write-Host "🔗 Ajout du remote..." -ForegroundColor Yellow
    git remote add origin $repoUrl
    
    Write-Host "📤 Push vers GitHub..." -ForegroundColor Yellow
    git branch -M main
    git push -u origin main
    
    Write-Host "✅ Code envoyé vers GitHub!" -ForegroundColor Green
    Write-Host "URL: $repoUrl" -ForegroundColor Cyan
} else {
    Write-Host "❌ URL non fournie. Arrêt." -ForegroundColor Red
} 