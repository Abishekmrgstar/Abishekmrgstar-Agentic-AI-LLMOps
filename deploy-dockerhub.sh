#!/bin/bash

# Docker Hub Deployment Script
# Prerequisites: Docker Hub account and docker login

set -e

DOCKER_USERNAME="your-dockerhub-username"
IMAGE_NAME="trip-planner"
VERSION="latest"

echo "=== Building Docker Image ==="
docker build -t $DOCKER_USERNAME/$IMAGE_NAME:$VERSION .

echo "=== Pushing to Docker Hub ==="
# Login to Docker Hub (you'll be prompted for credentials)
docker login

# Push image
docker push $DOCKER_USERNAME/$IMAGE_NAME:$VERSION

echo "=== Image pushed successfully! ==="
echo "Image: $DOCKER_USERNAME/$IMAGE_NAME:$VERSION"
echo ""
echo "To pull and run:"
echo "docker pull $DOCKER_USERNAME/$IMAGE_NAME:$VERSION"
echo "docker run -p 8000:8000 -p 8501:8501 $DOCKER_USERNAME/$IMAGE_NAME:$VERSION"
