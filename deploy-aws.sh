#!/bin/bash

# AWS Deployment Script for Trip Planner
# Prerequisites: AWS CLI configured with proper credentials

set -e

# Configuration
AWS_REGION="us-east-1"
ECR_REPOSITORY="trip-planner"
ECS_CLUSTER="trip-planner-cluster"
ECS_SERVICE="trip-planner-service"
TASK_DEFINITION="trip-planner-task"

echo "=== AWS Deployment Script ==="

# Step 1: Get AWS Account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo "AWS Account ID: $AWS_ACCOUNT_ID"

# Step 2: Create ECR Repository (if not exists)
echo "Creating ECR repository..."
aws ecr describe-repositories --repository-names $ECR_REPOSITORY --region $AWS_REGION || \
aws ecr create-repository --repository-name $ECR_REPOSITORY --region $AWS_REGION

# Step 3: Build Docker Image
echo "Building Docker image..."
docker build -t $ECR_REPOSITORY:latest .

# Step 4: Tag and Push to ECR
echo "Logging in to ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

echo "Tagging image..."
docker tag $ECR_REPOSITORY:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:latest

echo "Pushing to ECR..."
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:latest

# Step 5: Create ECS Cluster (if not exists)
echo "Creating ECS cluster..."
aws ecs describe-clusters --clusters $ECS_CLUSTER --region $AWS_REGION || \
aws ecs create-cluster --cluster-name $ECS_CLUSTER --region $AWS_REGION

# Step 6: Register Task Definition
echo "Registering task definition..."
sed "s/{ACCOUNT_ID}/$AWS_ACCOUNT_ID/g" ecs-task-definition.json > ecs-task-definition-final.json
aws ecs register-task-definition --cli-input-json file://ecs-task-definition-final.json --region $AWS_REGION

# Step 7: Create or Update Service
echo "Creating/Updating ECS service..."
aws ecs describe-services --cluster $ECS_CLUSTER --services $ECS_SERVICE --region $AWS_REGION || \
aws ecs create-service \
    --cluster $ECS_CLUSTER \
    --service-name $ECS_SERVICE \
    --task-definition $TASK_DEFINITION \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-xxxxx],securityGroups=[sg-xxxxx],assignPublicIp=ENABLED}" \
    --region $AWS_REGION

echo "=== Deployment Complete ==="
echo "View your service at: https://console.aws.amazon.com/ecs/home?region=$AWS_REGION#/clusters/$ECS_CLUSTER/services/$ECS_SERVICE/tasks"
