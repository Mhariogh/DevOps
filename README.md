#  Advanced End-to-End DevSecOps Kubernetes Three-Tier Project

 A production-grade, secure, and scalable Three-Tier application deployed on AWS EKS with a full DevSecOps CI/CD pipeline — integrating Jenkins, ArgoCD, SonarQube, Trivy, OWASP, Prometheus, and Grafana.

---

##  Table of Contents

- [Project Overview](#-project-overview)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Prerequisites](#-prerequisites)
- [Phase 1 — CI Pipeline Setup](#phase-1--continuous-integration-ci-pipeline)
- [Phase 2 — CD & Infrastructure](#phase-2--continuous-deployment--infrastructure)
- [Phase 3 — Monitoring](#phase-3--monitoring--optimization)
  
- [Step-by-Step Setup Guide](#-step-by-step-setup-guide)
  - [Step 1: IAM User Setup](#step-1-create-an-iam-user--generate-access-keys)
  - [Step 2: Install Terraform & AWS CLI](#step-2-install-terraform--aws-cli)
  - [Step 3: Deploy Jenkins Server with Terraform](#step-3-deploy-jenkins-server-ec2-with-terraform)
  - [Step 4: Deploy EKS Cluster](#step-4-deploy-eks-cluster)
  - [Step 5: Configure Load Balancer](#step-5-configure-load-balancer-on-eks)
  - [Step 6: Create ECR Repositories](#step-6-create-amazon-ecr-repositories)
  - [Step 7: Install & Configure ArgoCD](#step-7-install--configure-argocd)
  - [Step 8: Configure SonarQube](#step-8-configure-sonarqube)
  - [Step 9: Configure Jenkins Plugins & Pipelines](#step-9-configure-jenkins-plugins--pipelines)
  - [Step 10: Deploy App with ArgoCD](#step-10-deploy-three-tier-app-with-argocd)
  - [Step 11: Setup Monitoring](#step-11-monitoring-setup-prometheus--grafana)

---

##  Project Overview

This project walks through setting up a robust **Three-Tier Architecture** on AWS using Kubernetes, DevOps best practices, and advanced security measures. It covers:

| Area | Details |
|------|---------|
| **IAM User Setup** | Secure, controlled access to AWS resources |
| **Infrastructure as Code** | Jenkins EC2 provisioned via Terraform |
| **CI/CD Pipeline** | Jenkins for builds, ArgoCD for deployments |
| **Security Scanning** | SonarQube, OWASP Dependency-Check, Trivy |
| **Container Registry** | Amazon ECR (private repos for frontend & backend) |
| **Orchestration** | Amazon EKS (managed Kubernetes) |
| **GitOps** | ArgoCD syncing manifests from GitHub |
| **Monitoring** | Prometheus + Grafana on EKS |

---

##  Architecture

```
                          ┌─────────────────────────────────────────┐
                          │             AWS Cloud (us-east-1)        │
                          │                                           │
  Developer ──Push──▶ GitHub ──Trigger──▶ Jenkins CI Pipeline        │
                          │        │                                  │
                          │        ├──▶ SonarQube (Code Quality)      │
                          │        ├──▶ OWASP Scan (Dependencies)     │
                          │        ├──▶ Trivy (File + Image Scan)     │
                          │        ├──▶ Docker Build                  │
                          │        ├──▶ Push to Amazon ECR            │
                          │        └──▶ Update K8s Manifests in Git   │
                          │                    │                      │
                          │                    ▼                      │
                          │            ArgoCD (GitOps CD)             │
                          │                    │                      │
                          │                    ▼                      │
                          │         ┌─────────────────┐               │
                          │         │   Amazon EKS     │               │
                          │         │  ┌────────────┐  │               │
        Internet ──▶ ALB ──────────▶│  │  Frontend  │  │               │
                          │         │  │  Backend   │  │               │
                          │         │  │  Database  │  │               │
                          │         │  └────────────┘  │               │
                          │         └─────────────────┘               │
                          │                    │                      │
                          │         Prometheus + Grafana               │
                          └─────────────────────────────────────────┘
```

---

##  Tech Stack

| Category | Tools |
|----------|-------|
| **Cloud** | AWS (EKS, ECR, IAM, ALB, EC2, S3, DynamoDB) |
| **IaC** | Terraform |
| **CI** | Jenkins |
| **CD / GitOps** | ArgoCD |
| **Containerization** | Docker |
| **Orchestration** | Kubernetes (EKS) |
| **Code Quality** | SonarQube |
| **Security Scanning** | OWASP Dependency-Check, Trivy |
| **Monitoring** | Prometheus, Grafana |
| **DNS** | GoDaddy / Route 53 |
| **Package Manager** | Helm |

---

##  Prerequisites

Before starting, ensure you have:

-  An AWS account with permissions to create resources
-  Terraform installed on your local machine
-  AWS CLI installed and configured
-  Basic knowledge of Kubernetes, Docker, Jenkins, and DevOps

---

## Phase 1 — Continuous Integration (CI) Pipeline

The Jenkins CI pipeline runs the following stages automatically on every push:

| Stage | Description |
|-------|-------------|
| 1. Tool Install | Installs JDK, Node.js, and all required dependencies |
| 2. Clean Workspace | Clears residual data from previous builds |
| 3. Checkout from Git | Pulls latest code from the repository |
| 4. SonarQube Analysis | Static code analysis — detects bugs, smells, vulnerabilities |
| 5. Quality Gate | Validates code quality before proceeding |
| 6. OWASP Dependency-Check | Scans dependencies for known CVEs |
| 7. Trivy File Scan | Scans source files for vulnerabilities |
| 8. Docker Image Build | Packages the application into a Docker container |
| 9. ECR Image Push | Pushes validated image to Amazon ECR |
| 10. Trivy Image Scan | Scans the Docker image for vulnerabilities |
| 11. Checkout Code | Re-syncs code for manifest update |
| 12. Update K8s Deployment | Updates image tag in `deployment.yaml` and pushes to Git |
| 13. Post Actions | Cleanup, notifications, and build status logging |

---

## Phase 2 — Continuous Deployment & Infrastructure

ArgoCD manages deployments using GitOps — it watches your GitHub repo and automatically syncs any changes to the EKS cluster.

**Infrastructure components:**
- **Application Load Balancer (ALB)** — Distributes traffic across Kubernetes pods
- **Three-Tier App Architecture:**
  -  **Frontend Tier** — Kubernetes pods serving the UI
  -  **Backend Tier** — Pods handling business logic
  -  **Database Tier** — Pods with persistent storage secured by K8s secrets
- **DNS Management** — via GoDaddy / Route 53

---

## Phase 3 — Monitoring & Optimization

Deployed via Helm on EKS:
- **Prometheus** — Collects metrics (traffic, CPU, memory, pod health)
- **Grafana** — Visualizes metrics via dashboards

---

##  Step-by-Step Setup Guide

---

### Step 1: Create an IAM User & Generate Access Keys

1. Sign in to [AWS Console](https://console.aws.amazon.com)
2. Navigate to **IAM → Users → Create user**
3. Set username (e.g., `devops-user`)
4. Attach policy: `AdministratorAccess` *(restrict in production)*
5. Go to **Security credentials → Access keys → Create access key**
6. Select **CLI** as use case, then download the `.csv` file

 **Security Best Practices**
> - Never commit access keys to Git
> - Use IAM Roles instead of long-term keys where possible
> - Rotate keys regularly
> - Apply least privilege in production

---

### Step 2: Install Terraform & AWS CLI

#### A. Install AWS CLI

```bash
# Linux/Ubuntu
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# macOS
brew install awscli

# Verify
aws --version
```

#### B. Configure AWS CLI

```bash
aws configure
# Enter: Access Key ID, Secret Access Key, Region (us-east-1), Output (json)

# Verify
aws sts get-caller-identity
```

#### C. Install Terraform

```bash
# Linux/Ubuntu
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor \
  -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update && sudo apt-get install terraform -y

# macOS
brew tap hashicorp/tap && brew install hashicorp/tap/terraform

# Verify
terraform --version
```

---

### Step 3: Deploy Jenkins Server (EC2) with Terraform

```bash
# Clone the repo
git clone --branch e2e-3-tier-DevSecOps https://github.com/Mhariogh/DevOps.git e2e-3-tier-DevSecOps

cd e2e-3-tier-DevSecOps/Jenkins-Server-TF
```

#### Configure Remote Backend (S3 + DynamoDB)

```bash
# Create S3 bucket for Terraform state
aws s3api create-bucket \
  --bucket your-terraform-state-bucket \
  --region us-east-1

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name Lock-Files \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

Update `backend.tf` with your S3 bucket and DynamoDB table names, then:

```bash
terraform init
terraform validate
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars --auto-approve
```

#### Connect to Jenkins EC2

```bash
# SSH method
chmod 400 jenkins_key.pem
ssh -i jenkins_key.pem ubuntu@<YOUR_PUBLIC_IP>
```

Or use **EC2 Instance Connect** directly from the AWS Console.

#### Access Jenkins

```
http://<YOUR_PUBLIC_IP>:8080
```

```bash
# Get initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

> Make sure port **8080** is open in your EC2 Security Group.

#### Verify Installed Tools

```bash
jenkins --version
docker --version
terraform --version
kubectl version --client
aws --version
trivy --version
eksctl version
```

<details>
<summary> Manual Tool Installation (if needed)</summary>

```bash
# Update system
sudo apt update -y && sudo apt upgrade -y

# Java (Jenkins dependency)
sudo apt install openjdk-17-jdk -y

# Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
  sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y && sudo apt install jenkins -y
sudo systemctl start jenkins && sudo systemctl enable jenkins

# Docker
sudo apt install docker.io -y
sudo systemctl start docker && sudo systemctl enable docker
sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins
sudo reboot

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && sudo mv kubectl /usr/local/bin/

# eksctl
curl --silent --location \
  "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
  | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Trivy
sudo apt install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | \
  sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt update -y && sudo apt install trivy -y
```

</details>

---

### Step 4: Deploy EKS Cluster

#### Install Jenkins Plugins

Go to **Manage Jenkins → Plugins → Available Plugins** and install:
- `AWS Credentials`
- `Pipeline: AWS Steps`

Restart Jenkins after installation.

#### Add Credentials in Jenkins

Navigate to **Manage Jenkins → Credentials → (global) → Add Credentials**:

| Kind | ID | Value |
|------|----|-------|
| AWS Credentials | `aws-creds` | Your AWS Access & Secret Key |
| Username with password | `github-token` | GitHub username + PAT |

#### Configure AWS on Jenkins Server

```bash
aws configure
aws sts get-caller-identity  # Verify
```

#### Create EKS Cluster

```bash
# Takes 10–20 minutes
eksctl create cluster \
  --name Three-Tier-K8s-EKS-Cluster \
  --region us-east-1 \
  --node-type t2.medium \
  --nodes-min 2 \
  --nodes-max 2

aws eks update-kubeconfig --region us-east-1 --name Three-Tier-K8s-EKS-Cluster

# Verify
kubectl get nodes
```

---

### Step 5: Configure Load Balancer on EKS

```bash
# Step 1: Download IAM Policy
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json

# Step 2: Create IAM Policy
aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json

# Step 3: Associate OIDC Provider
eksctl utils associate-iam-oidc-provider \
  --region us-east-1 \
  --cluster Three-Tier-K8s-EKS-Cluster \
  --approve

# Step 4: Create IAM Service Account (replace <your_account_id>)
eksctl create iamserviceaccount \
  --cluster Three-Tier-K8s-EKS-Cluster \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn arn:aws:iam::<your_account_id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve \
  --region us-east-1

# Step 5: Install Helm
sudo snap install helm --classic

# Step 6: Install AWS Load Balancer Controller
helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=Three-Tier-K8s-EKS-Cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller

# Verify (wait ~2 minutes)
kubectl get deployment -n kube-system aws-load-balancer-controller
```

---

### Step 6: Create Amazon ECR Repositories

1. Go to **AWS Console → ECR → Repositories → Create repository**
2. Create two repositories:
   - `frontend`
   - `backend`

#### Authenticate & Push Images

```bash
# Login to ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com

# Backend
cd Application-Code/backend
docker build -t backend .
docker tag backend:latest <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/backend:latest
docker push <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/backend:latest

# Frontend
cd ../frontend
docker build -t frontend .
docker tag frontend:latest <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/frontend:latest
docker push <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/frontend:latest
```

---

### Step 7: Install & Configure ArgoCD

```bash
# Create app namespace
kubectl create namespace three-tier

# Create ECR pull secret
kubectl create secret generic ecr-registry-secret \
  --from-file=.dockerconfigjson=$HOME/.docker/config.json \
  --type=kubernetes.io/dockerconfigjson \
  --namespace three-tier

# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f \
  https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.7/manifests/install.yaml

# Wait for pods
kubectl get pods -n argocd

# Expose ArgoCD via LoadBalancer
kubectl patch svc argocd-server -n argocd \
  -p '{"spec": {"type": "LoadBalancer"}}'

# Get external URL
kubectl get svc argocd-server -n argocd

# Get admin password
kubectl get secret argocd-initial-admin-secret \
  -n argocd \
  -o jsonpath='{.data.password}' | base64 -d; echo
```

Access ArgoCD at `https://<EXTERNAL-IP>` with **username: `admin`**.

>  In ArgoCD UI, go to **Settings → Repositories** to connect your GitHub repo using your PAT.

>  Add `imagePullSecrets` to your deployment YAMLs:
> ```yaml
> imagePullSecrets:
>   - name: ecr-registry-secret
> ```

---

### Step 8: Configure SonarQube

Access SonarQube at `http://<JENKINS_SERVER_IP>:9000` (default: `admin/admin`)

1. **Generate Token:** Administration → Security → Users → Update Tokens → Generate
2. **Configure Webhook:** Administration → Configuration → Webhooks → Create
   - URL: `http://<JENKINS_IP>:8080/sonarqube-webhook/`
3. **Create Projects:** Create Project → Manually → name: `backend` & `frontend`

#### Add Credentials in Jenkins

Navigate to **Manage Jenkins → Credentials → (global)**:

| Kind | ID | Value |
|------|----|-------|
| Secret text | `sonar-token` | SonarQube token |
| Secret text | `github-token` | GitHub PAT |
| Secret text | `ACCOUNT_ID` | AWS Account ID |
| Secret text | `ECR_REPO1` | `frontend` |
| Secret text | `ECR_REPO2` | `backend` |

---

### Step 9: Configure Jenkins Plugins & Pipelines

#### Install Plugins

**Manage Jenkins → Plugins → Available Plugins:**

- `Docker`, `Docker Commons`, `Docker Pipeline`, `Docker API`, `docker-build-step`
- `Eclipse Temurin installer`
- `NodeJS`
- `OWASP Dependency-Check`
- `SonarQube Scanner`

Restart Jenkins after installation.

#### Configure Tools

**Manage Jenkins → Tools:**

| Tool | Name | Version |
|------|------|---------|
| JDK | `jdk17` | JDK 17.0.12+7 |
| SonarQube Scanner | `sonar-scanner` | 6.2.0.4584 |
| NodeJS | `nodejs` | 22.9.0 |
| Dependency-Check | `DP-Check` | 10.0.4 |
| Docker | `docker` | Latest |

#### Configure SonarQube Server

**Manage Jenkins → System → SonarQube installations:**
- Name: `sonar-server`
- Server URL: `http://<YOUR_EC2_IP>:9000`
- Credentials: `sonar-token`

#### Create Pipelines

**Jenkins Dashboard → New Item → Pipeline**

For **Backend**:
- SCM: Git
- Repo URL: `https://github.com/Mhariogh/DevOps.git`
- Branch: `e2e-3-tier-DevSecOps`
- Script Path: `Jenkins-Pipeline-Code/Jenkinsfile-Backend`

For **Frontend**:
- SCM: Git
- Repo URL: `https://github.com/Mhariogh/DevOps.git`
- Branch: `e2e-3-tier-DevSecOps`
- Script Path: `Jenkins-Pipeline-Code/Jenkinsfile-Frontend`

Click **Build Now** to run each pipeline.

---

### Step 10: Deploy Three-Tier App with ArgoCD

Create **4 ArgoCD Applications** in this order:

| App Name | Manifest Path | Namespace |
|----------|--------------|-----------|
| `database` | `Kubernetes-Manifests-file/Database` | `three-tier` |
| `backend` | `Kubernetes-Manifests-file/Backend` | `three-tier` |
| `frontend` | `Kubernetes-Manifests-file/Frontend` | `three-tier` |
| `ingress` | `Kubernetes-Manifests-file/Ingress` | `three-tier` |

> Deploy in this order — backend depends on DB, frontend depends on backend, ingress exposes everything.

#### Connect Domain (DNS)

After ingress deploys, you'll get an ALB DNS name. Add CNAME records at your DNS provider:

```
backend.yourdomain.com  →  k8s-three-xxxx.elb.amazonaws.com
frontend.yourdomain.com →  k8s-three-xxxx.elb.amazonaws.com
```

#### Verify Deployment

```bash
kubectl get pods -n three-tier
kubectl get svc -n three-tier
```

---

### Step 11: Monitoring Setup (Prometheus + Grafana)

```bash
# Add Helm repos
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Prometheus
helm install prometheus prometheus-community/prometheus

# Install Grafana
helm install grafana grafana/grafana

# Get Grafana admin password
kubectl get secret grafana -o jsonpath="{.data.admin-password}" | base64 --decode

# Port-forward to access locally
kubectl port-forward svc/grafana 3000:80
```

Access Grafana at `http://localhost:3000`

---

## Jenkins Credentials Summary

| Credential ID | Type | Description |
|--------------|------|-------------|
| `ACCOUNT_ID` | Secret text | AWS Account ID |
| `ECR_REPO1` | Secret text | Frontend ECR repo name |
| `ECR_REPO2` | Secret text | Backend ECR repo name |
| `github-token` | Secret text | GitHub Personal Access Token |
| `sonar-token` | Secret text | SonarQube authentication token |
| `aws-creds` | AWS Credentials | AWS Access & Secret Key |

---

## Repository Structure

```
DevOps/
├── Application-Code/
│   ├── frontend/
│   └── backend/
├── Jenkins-Server-TF/          # Terraform for Jenkins EC2
├── Jenkins-Pipeline-Code/
│   ├── Jenkinsfile-Backend
│   └── Jenkinsfile-Frontend
└── Kubernetes-Manifests-file/
    ├── Database/
    ├── Backend/
    ├── Frontend/
    └── Ingress/
```

---



