# Script pour créer automatiquement un dépôt GitHub
param(
    [string]$RepoName = "humain_ia",
    [string]$Description = "Projet IA Humanizer avec déploiement Google Cloud"
)

Write-Host "🚀 Création du dépôt GitHub..." -ForegroundColor Green

# Demander le token GitHub
$token = Read-Host "Entrez votre token GitHub (ou appuyez sur Entrée pour créer manuellement)"

if (-not $token) {
    Write-Host "📝 Création manuelle du dépôt GitHub:" -ForegroundColor Yellow
    Write-Host "1. Allez sur: https://github.com/new" -ForegroundColor Cyan
    Write-Host "2. Nom du dépôt: $RepoName" -ForegroundColor Cyan
    Write-Host "3. Description: $Description" -ForegroundColor Cyan
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
        
        Write-Host "✅ Dépôt créé et code envoyé!" -ForegroundColor Green
        Write-Host "URL: $repoUrl" -ForegroundColor Cyan
    }
} else {
    # Création automatique via API GitHub
    $headers = @{
        "Authorization" = "token $token"
        "Accept" = "application/vnd.github.v3+json"
    }
    
    $body = @{
        name = $RepoName
        description = $Description
        private = $false
        auto_init = $false
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body -ContentType "application/json"
        
        $repoUrl = $response.clone_url
        Write-Host "✅ Dépôt créé: $repoUrl" -ForegroundColor Green
        
        # Ajouter le remote et pousser
        git remote add origin $repoUrl
        git branch -M main
        git push -u origin main
        
        Write-Host "✅ Code envoyé vers GitHub!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Erreur lors de la création: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Essayez la création manuelle ci-dessus." -ForegroundColor Yellow
    }
} 