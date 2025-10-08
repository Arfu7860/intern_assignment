Structure

Next.js Application Deployment with Docker, GitHub Actions, and Minikube
This repository contains a containerized Next.js application, automated build/push via GitHub Actions to GHCR, and deployment manifests for Kubernetes (Minikube).

Prerequisites
Git

Node.js (for local testing)

Docker

Minikube (and a hypervisor like VirtualBox or Docker Desktop)

kubectl

Local Setup Instructions
Clone the repository:

Bash

git clone [YOUR_REPO_URL]
cd [YOUR_REPO_NAME]
Install dependencies:

Bash

npm install
Local Run Commands
1. Next.js Development Server
Bash

npm run dev
# Access the app at http://localhost:3000
2. Docker Build and Run
Bash

# Build the image locally
docker build -t nextjs-local:latest .

# Run the container
docker run -d -p 3000:3000 --name nextjs-local-container nextjs-local:latest

# Access the app at http://localhost:3000
docker logs nextjs-local-container
GitHub Actions (CI/CD)
The workflow defined in .github/workflows/docker-build-push.yaml automatically runs on every push to the main branch.

Action: Build the Docker image using a multi-stage build.

Registry: Push the built image to GitHub Container Registry (GHCR).

Tagging: Images are tagged with latest and a unique SHA (sha-<commit-sha>).

GHCR Image URL: ghcr.io/your-github-username/my-next-app:latest (Replace with your actual URL)

Deployment Steps for Minikube
Start Minikube:

Bash

minikube start
Apply Kubernetes Manifests:
Navigate to the root of the repository and apply the files in the k8s/ folder.

Bash

kubectl apply -f k8s/
# Expected output:
# deployment.apps/nextjs-app-deployment created
# service/nextjs-app-service created
Verify Deployment:
Check the status of the Deployment and Pods.

Bash

kubectl get deployments
kubectl get pods
How to Access the Deployed Application
The application is exposed via a NodePort Service.

Get the Service URL and Port:
Use the Minikube command to automatically open the application in your browser or display the URL.

Bash

minikube service nextjs-app-service --url
Access the Application:
Navigate to the URL provided by the command above (e.g., http://192.168.49.2:32000).