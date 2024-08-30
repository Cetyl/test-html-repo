#!/bin/bash

# Variables
CLUSTER_NAME="my-cluster"
SERVICE_NAME="my-service"
TASK_DEFINITION="my-task-def"
REGION="us-east-1"

# Register task definition
aws ecs register-task-definition \
  --family $TASK_DEFINITION \
  --container-definitions '[{"name":"my-container","image":"my-dockerhub-username/my-web-app:latest","memory":512,"cpu":256,"essential":true}]' \
  --region $REGION

# Update service
aws ecs update-service \
  --cluster $CLUSTER_NAME \
  --service $SERVICE_NAME \
  --task-definition $TASK_DEFINITION \
  --region $REGION
