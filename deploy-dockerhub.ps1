# Docker Hub Deployment Script for Windows
# Prerequisites: Docker Hub account and docker login

$DOCKER_USERNAME = "your-dockerhub-username"
$IMAGE_NAME = "trip-planner"
$VERSION = "latest"

Write-Host "=== Building Docker Image ===" -ForegroundColor Green
docker build -t ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION} .

Write-Host "=== Pushing to Docker Hub ===" -ForegroundColor Green
# Login to Docker Hub
docker login

# Push image
docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}

Write-Host "=== Image pushed successfully! ===" -ForegroundColor Green
Write-Host "Image: ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"
Write-Host ""
Write-Host "To pull and run:"
Write-Host "docker pull ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"
Write-Host "docker run -p 8000:8000 -p 8501:8501 ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"
