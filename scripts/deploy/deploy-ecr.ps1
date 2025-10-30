# scripts/deploy-ecr.ps1
# Script para deploy a AWS ECR (PowerShell version para Windows)
# Uso: .\scripts\deploy-ecr.ps1 [tag]

param(
    [string]$Tag = ""
)

$ErrorActionPreference = "Stop"

# Configuración
$AWS_REGION = "us-east-1"
$AWS_ACCOUNT_ID = "851725478821"
$ECR_REPOSITORY = "si2-mrp-be"
$ECR_REGISTRY = "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
$IMAGE_NAME = "$ECR_REGISTRY/$ECR_REPOSITORY"

# Tag por defecto: fecha + commit corto o 'local'
if (-not $Tag) {
    $DateTag = Get-Date -Format "yyyyMMdd"
    try {
        $GitHash = (git rev-parse --short HEAD 2>$null)
        $Tag = "$DateTag-$GitHash"
    } catch {
        $Tag = "$DateTag-local"
    }
}

Write-Host "🚀 Iniciando deploy a AWS ECR..." -ForegroundColor Cyan
Write-Host "📦 Imagen: ${IMAGE_NAME}:${Tag}" -ForegroundColor Yellow
Write-Host ""

# 1. Login a ECR
Write-Host "🔐 Step 1/5: Autenticando con AWS ECR..." -ForegroundColor Green
$LoginCommand = aws ecr get-login-password --region $AWS_REGION
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al obtener credenciales de ECR" -ForegroundColor Red
    exit 1
}
$LoginCommand | docker login --username AWS --password-stdin $ECR_REGISTRY
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al hacer login en ECR" -ForegroundColor Red
    exit 1
}

# 2. Build de la imagen
Write-Host "🔨 Step 2/5: Construyendo imagen Docker..." -ForegroundColor Green
docker build -t "${ECR_REPOSITORY}:${Tag}" .
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al construir la imagen" -ForegroundColor Red
    exit 1
}

docker tag "${ECR_REPOSITORY}:${Tag}" "${IMAGE_NAME}:${Tag}"
docker tag "${ECR_REPOSITORY}:${Tag}" "${IMAGE_NAME}:latest"

# 3. Push de la imagen con tag específico
Write-Host "📤 Step 3/5: Subiendo imagen con tag ${Tag}..." -ForegroundColor Green
docker push "${IMAGE_NAME}:${Tag}"
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al subir imagen con tag" -ForegroundColor Red
    exit 1
}

# 4. Push de latest
Write-Host "📤 Step 4/5: Actualizando imagen :latest..." -ForegroundColor Green
docker push "${IMAGE_NAME}:latest"
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al subir imagen latest" -ForegroundColor Red
    exit 1
}

# 5. Limpieza local (opcional)
Write-Host "🧹 Step 5/5: Limpiando imágenes locales antiguas..." -ForegroundColor Green
docker image prune -f | Out-Null

Write-Host ""
Write-Host "✅ Deploy completado exitosamente!" -ForegroundColor Green
Write-Host "📍 Imagen disponible en:" -ForegroundColor Cyan
Write-Host "   ${IMAGE_NAME}:${Tag}" -ForegroundColor Yellow
Write-Host "   ${IMAGE_NAME}:latest" -ForegroundColor Yellow
Write-Host ""
Write-Host "💡 Para usar en ECS/Fargate:" -ForegroundColor Cyan
Write-Host "   docker pull ${IMAGE_NAME}:${Tag}" -ForegroundColor White
