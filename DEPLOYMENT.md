# AI Trip Planner - Deployment Guide

## Prerequisites

1. **Docker** installed on your machine
2. **AWS CLI** configured with credentials
3. **Jenkins** server (optional for CI/CD)
4. **Git** repository

## Local Testing

```bash
# Test with Docker Compose
docker-compose up --build

# Access applications:
# - Backend: http://localhost:8000
# - Frontend: http://localhost:8501
```

## AWS Deployment Steps

### 1. Setup AWS Resources

```bash
# Install AWS CLI
# Configure credentials
aws configure

# Set your region, access key, and secret key
```

### 2. Manual Deployment

```bash
# Make deploy script executable
chmod +x deploy-aws.sh

# Update VPC settings in deploy-aws.sh:
# - Replace subnet-xxxxx with your subnet ID
# - Replace sg-xxxxx with your security group ID

# Run deployment
./deploy-aws.sh
```

### 3. Jenkins CI/CD Setup

1. **Install Jenkins Plugins:**
   - Docker Pipeline
   - AWS Credentials
   - Git

2. **Configure AWS Credentials in Jenkins:**
   - Go to: Manage Jenkins → Credentials
   - Add AWS credentials (Access Key ID & Secret)

3. **Create Jenkins Pipeline:**
   - New Item → Pipeline
   - Point to your Git repository
   - Use Jenkinsfile from repo

4. **Add Environment Variables:**
   - API keys as Jenkins credentials
   - Reference in Jenkinsfile

### 4. Update ECS Task Definition

Edit `ecs-task-definition.json`:
- Add your API keys in environment variables
- Update subnet and security group IDs
- Adjust CPU/memory as needed

### 5. Cost Optimization

**Free Tier Eligible:**
- ECR: 500MB storage/month
- ECS Fargate: First month free (limited)

**Estimated Monthly Cost (after free tier):**
- Fargate (512 CPU, 1GB RAM): ~$15-20/month
- ECR storage: ~$1/month
- Data transfer: Varies

## Architecture

```
GitHub → Jenkins → Docker Build → AWS ECR → ECS Fargate
                                              ↓
                                   Load Balancer (optional)
                                              ↓
                                   Backend (port 8000)
                                   Frontend (port 8501)
```

## Monitoring

- CloudWatch Logs: `/ecs/trip-planner`
- ECS Service metrics in AWS Console

## Environment Variables (Set in AWS Secrets Manager or ECS Task Definition)

```
GROQ_API_KEY=your_key
TAVILAY_API_KEY=your_key
OPENWEATHERMAP_API_KEY=your_key
EXCHANGE_RATE_API_KEY=your_key
```
