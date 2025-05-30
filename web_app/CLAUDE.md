# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Application Architecture

This is a simple Flask microservice with cloud-native design patterns:
- **Health Check Pattern**: Implements `/health` endpoint for container orchestration
- **Version Endpoint**: `/version` endpoint reads from APP_VERSION environment variable
- **Environment-Driven Configuration**: Uses environment variables for runtime configuration

## Common Development Commands

**Local Development:**
```bash
# Install dependencies
pip install -r requirements.txt

# Run application locally
python app.py
# Available at http://localhost:5000
```

**Docker Development:**
```bash
# Build image
docker build -t flask-app:1.0.0 .

# Build with custom version
docker build --build-arg APP_VERSION=1.2.3 -t flask-app:1.2.3 .

# Run container locally
docker run -p 5000:5000 flask-app:1.0.0
```

**AWS ECR Deployment:**
```bash
# Deploy to ECR (handles repo creation, build, and push)
./upload-to-ecr.sh
```

## Key Configuration

**Docker Build Args:**
- `APP_VERSION`: Sets application version (defaults to 0.0.1)

**AWS ECR Settings:**
- Repository: `nurlan.yagublu-skillup-flask`
- Region: `us-east-1`
- Auto-tags with duedate for resource management

**Dependencies:**
- Flask 3.1.1 ecosystem
- Note: Commented AWS dependency in requirements.txt may need attention

## Architecture Notes

The upload-to-ecr.sh script provides full deployment automation including ECR repository management, authentication, image building, and pushing. The Dockerfile uses multi-stage optimization with dependencies installed before source code copying for efficient builds.