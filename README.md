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
   ```bash
   docker build -t my-web-app .
   ```
4. Run the Docker container
```bash
docker run -p 8080:80 my-web-app
```

## CI/CD Pipeline
The CI/CD pipeline is configured using GitHub Actions. It will:

Build the Docker image on every push to the main branch.
Optionally, push the Docker image to Docker Hub.

## Deployment
### AWS ECS
To deploy the Docker container to AWS ECS:

1. Set up AWS CLI and configure credentials.
2. Run the deployment script:
```bash
 ./aws-deploy.sh
```
