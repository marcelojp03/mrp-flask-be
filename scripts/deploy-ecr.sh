#!/bin/bash
# scripts/deploy-ecr.sh
# Script para deploy a AWS ECR (Elastic Container Registry)
# Uso: ./scripts/deploy-ecr.sh [tag]

set -e  # Exit on error

# Configuración
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="851725478821"
ECR_REPOSITORY="si2-mrp-be"
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
IMAGE_NAME="${ECR_REGISTRY}/${ECR_REPOSITORY}"

# Tag por defecto: fecha + commit corto
TAG="${1:-$(date +%Y%m%d)-$(git rev-parse --short HEAD 2>/dev/null || echo 'local')}"

echo "🚀 Iniciando deploy a AWS ECR..."
echo "📦 Imagen: ${IMAGE_NAME}:${TAG}"
echo ""

# 1. Login a ECR
echo "🔐 Step 1/5: Autenticando con AWS ECR..."
aws ecr get-login-password --region ${AWS_REGION} | \
    docker login --username AWS --password-stdin ${ECR_REGISTRY}

# 2. Build de la imagen
echo "🔨 Step 2/5: Construyendo imagen Docker..."
docker build -t ${ECR_REPOSITORY}:${TAG} .
docker tag ${ECR_REPOSITORY}:${TAG} ${IMAGE_NAME}:${TAG}
docker tag ${ECR_REPOSITORY}:${TAG} ${IMAGE_NAME}:latest

# 3. Push de la imagen con tag específico
echo "📤 Step 3/5: Subiendo imagen con tag ${TAG}..."
docker push ${IMAGE_NAME}:${TAG}

# 4. Push de latest
echo "📤 Step 4/5: Actualizando imagen :latest..."
docker push ${IMAGE_NAME}:latest

# 5. Limpieza local (opcional)
echo "🧹 Step 5/5: Limpiando imágenes locales antiguas..."
docker image prune -f

echo ""
echo "✅ Deploy completado exitosamente!"
echo "📍 Imagen disponible en:"
echo "   ${IMAGE_NAME}:${TAG}"
echo "   ${IMAGE_NAME}:latest"
echo ""
echo "💡 Para usar en ECS/Fargate:"
echo "   docker pull ${IMAGE_NAME}:${TAG}"
