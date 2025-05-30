#!/bin/bash

set -e

# -------- CONFIG -------- #
IMAGE_NAME="flask-app"
VERSION="1.0.0"
AWS_REGION="us-east-1"
DUEDATE="27.07.2025"  # Format: DD.MM.YYYY
REPO_NAME="nurlan.yagublu-skillup-flask"
# ------------------------ #

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REPO_URI="$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME"

echo "🔍 Checking if repository exists..."
if ! aws ecr describe-repositories --repository-names $REPO_NAME --region $AWS_REGION > /dev/null 2>&1; then
    echo "📦 Repository not found. Creating $REPO_NAME with duedate=$DUEDATE..."
    aws ecr create-repository \
        --repository-name $REPO_NAME \
        --tags Key=duedate,Value=$DUEDATE \
        --region $AWS_REGION
else
    echo "📦 Repository $REPO_NAME already exists. Tagging with duedate=$DUEDATE..."
    REPO_ARN=$(aws ecr describe-repositories \
        --repository-names $REPO_NAME \
        --region $AWS_REGION \
        --query "repositories[0].repositoryArn" --output text)

    aws ecr tag-resource \
        --resource-arn $REPO_ARN \
        --tags Key=duedate,Value=$DUEDATE \
        --region $AWS_REGION
fi

echo "💡 Logging in to ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $REPO_URI

echo "🔨 Building Docker image..."
docker build -t $IMAGE_NAME:$VERSION .

echo "🏷️ Tagging image..."
docker tag $IMAGE_NAME:$VERSION $REPO_URI:$VERSION

echo "📤 Pushing image to ECR..."
docker push $REPO_URI:$VERSION

echo "✅ Done! Image pushed to $REPO_URI:$VERSION"
