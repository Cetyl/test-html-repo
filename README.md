# Simple Web Application with CI/CD

## Building and Running Docker Container Locally

1. Clone the repository:
   ```bash
   git clone https://github.com/Cetyl/test-html-repo.git
   ```
2.  Navigate to the project directory:
   ```bash
   cd simple-web-app
   ```
3. Build the Docker image
   Ensure you have Docker installed and running. Then, open your terminal and navigate to the directory containing your Dockerfile and your index.html file. Run the following command to build the Docker image
   ```bash
   docker build -t my-web-app .
   ```
4. Run the Docker container
   After building the image, you can run it with
```bash
docker run -p 8080:80 my-web-app
```
- -d runs the container in detached mode.
- -p 8080:80 maps port 80 in the container to port 8080 on your local machine.

## CI/CD Pipeline
GitHub Actions allows you to automate workflows, including CI/CD pipelines. Here’s how the CI/CD pipeline configured in .github/workflows/ci-cd.yml works:

### Trigger
The pipeline is triggered by a push event to the main branch. Every time you push code to main, GitHub Actions will:

- Checkout Code: Fetch the latest code from the repository.
- Set Up Docker Buildx: Prepare the Docker build environment.
- Cache Docker Layers: Store Docker build cache to speed up builds.
- Build Docker Image: Build the Docker image as specified in the Dockerfile.
- Log in to Docker Hub: Authenticate with Docker Hub (if you’re pushing the image).
- Push Docker Image: Tag and push the Docker image to Docker Hub (if configured).
- Deploy to AWS: Use the AWS CLI to deploy the container to an ECS service (if configured).

### Configuration
The pipeline is configured in the ci-cd.yml file:

- Jobs: Define the steps to be executed (e.g., build, push, deploy).
- Steps: Each step represents a specific action or command (e.g., building the image, logging in, pushing the image).

## Run Deployment Script or Commands
The deployment script or commands deploy the Docker container to a cloud service. Here’s how to deploy using AWS ECS (Elastic Container Service):

### Prerequisites
-AWS CLI: Make sure you have the AWS CLI installed and configured on your local machine or GitHub Actions runner.
-ECS Cluster and Service: Ensure you have an ECS cluster and service set up in AWS.

### Deployment Commands
To update the ECS service to use the new Docker image, you use the AWS CLI command:
```bash
aws ecs update-service --cluster my-cluster --service my-service --force-new-deployment
```
- cluster my-cluster: Replace my-cluster with the name of your ECS cluster.
- service my-service: Replace my-service with the name of your ECS service.
- force-new-deployment: Forces a new deployment to use the updated Docker image.

### Deployment Steps
1. Prepare the Image: Ensure the Docker image is available in your container registry (Docker Hub or Amazon ECR).
2. Update ECS Task Definition: Update the ECS task definition to point to the new Docker image version.
3. Update ECS Service: Deploy the updated task definition by running the aws ecs update-service command.
