# Terraform Complete Guide: Zero to Hero 

A comprehensive guide to master Terraform from installation to advanced production-ready infrastructure.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Phase 1: Installation & Setup](#phase-1-installation--setup)
- [Phase 2: Terraform Fundamentals](#phase-2-terraform-fundamentals)
- [Phase 3: Core Concepts with Examples](#phase-3-core-concepts-with-examples)
- [Phase 4: Intermediate Concepts](#phase-4-intermediate-concepts)
- [Phase 5: Advanced Topics](#phase-5-advanced-topics)
- [Phase 6: Production Best Practices](#phase-6-production-best-practices)
- [Phase 7: Complete Real-World Projects](#phase-7-complete-real-world-projects)
- [Additional Resources](#additional-resources)

---

## Prerequisites

- Basic understanding of command line/terminal
- Familiarity with cloud concepts (AWS, Azure, or GCP)
- A code editor (VS Code recommended)
- An AWS account (Free Tier is sufficient)
- Basic understanding of networking concepts

---

## Phase 1: Installation & Setup

### Step 1: Install Terraform

#### Windows (using Chocolatey)
```powershell
# Install Chocolatey if you haven't already (Run PowerShell as Administrator)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```
##### Install Terraform
```
choco install terraform
```

##### Verify installation
```
terraform version
```

#### macOS (using Homebrew)
```
# Install Homebrew if you haven't already

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
##### Install Terraform
```
brew tap hashicorp/tap
```
```
brew install hashicorp/tap/terraform
```

##### Verify installation
```
terraform version
```

#### Linux (Ubuntu/Debian)
```
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```
```
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```
```
sudo apt update && sudo apt install terraform
```

### Step 2: Install and Configure VS Code

#### Download and Install VS Code

```
# Windows: Open powershell as administrative user
choco install vscode -y
```


Install Terraform Extension

###### Open VS Code
- Press Ctrl+Shift+X (Windows/Linux) or Cmd+Shift+X (Mac)
- Search for "HashiCorp Terraform"
- Click Install on the official HashiCorp extension


Configure VS Code Settings

- Press Ctrl+, (Windows/Linux) or Cmd+, (Mac) to open settings, 
- Then click the "Open Settings (JSON)" icon in the top right.
- Add these settings:
```
{
  "terraform.languageServer.enable": true,
  "terraform.experimentalFeatures.validateOnSave": true,
  "terraform.experimentalFeatures.prefillRequiredFields": true,
  "editor.formatOnSave": true,
  "[terraform]": {
    "editor.defaultFormatter": "hashicorp.terraform",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.formatAll.terraform": true
    }
  },
  "[terraform-vars]": {
    "editor.defaultFormatter": "hashicorp.terraform",
    "editor.formatOnSave": true
  }
}
  ```
## Phase 2: Terraform Fundamentals
### Step 3: Understand Core Concepts
Learn these fundamental concepts:

- Infrastructure as Code (IaC): Managing infrastructure through code rather than manual processes
- Declarative vs Imperative: Terraform is declarative (you define what you want, not how to get there)
- Provider: Plugins that allow Terraform to interact with cloud platforms, SaaS providers, and APIs
- Resource: Components of your infrastructure (EC2 instances, S3 buckets, etc.)
- State: Terraform tracks the current state of your infrastructure in a state file

### Step 4: Your First Terraform Configuration
Create a project folder and a file named `main.tf`:
```
# Configure the provider (AWS example)
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create a simple S3 bucket
resource "aws_s3_bucket" "my_first_bucket" {
  bucket = "my-unique-terraform-bucket-12345"
  
  tags = {
    Name        = "My First Bucket"
    Environment = "Learning"
  }
}
```
### Step 5: Master the Terraform Workflow
Learn and practice these essential commands:
```
# Initialize the working directory (downloads provider plugins)
terraform init
```

```
# Preview changes before applying
terraform plan
```
```
# Apply changes to create/update infrastructure
terraform apply
```
```
# Destroy all resources defined in your configuration
terraform destroy
```
```
# Format your code to canonical style
terraform fmt
```
```

# Validate configuration syntax
terraform validate

# Show current state
terraform show

# List all resources in state
terraform state list
```

## Phase 3: Core Terraform Concepts
### Step 6: Variables and Outputs
`variables.tf`:
```
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

```
`outputs.tf:`
```
output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.my_bucket.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.my_bucket.arn
}
```
Using variables:
```
resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = merge(
    var.tags,
    {
      Name = "web-${count.index}"
      Environment = var.environment
    }
  )
}
```
### Step 7: Data Sources
Learn to query existing infrastructure:
```
# Get latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Use the data source
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
}
```
### Step 8: Resource Dependencies
Understanding implicit and explicit dependencies:
```
# Implicit dependency (Terraform detects automatically)
resource "aws_eip" "ip" {
  instance = aws_instance.web.id
}

# Explicit dependency (use depends_on)
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  depends_on = [aws_s3_bucket.config]
}
```

## Phase 4: Intermediate Concepts
### Step 9: Modules
Create reusable infrastructure components:
`modules/webserver/main.tf`:
```
variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  
  tags = {
    Name = "WebServer"
  }
}

output "instance_id" {
  value = aws_instance.web.id
}
```

Using the module:
```
module "webserver" {
  source        = "./modules/webserver"
  instance_type = "t2.micro"
  ami_id        = data.aws_ami.amazon_linux.id
}
```

### Step 10: State Management
Understanding and managing Terraform state:

```
# View state
terraform state list
```
```
# Show specific resource
terraform state show aws_instance.web
```
```
# Move resource in state
terraform state mv aws_instance.old aws_instance.new
```
```
# Remove resource from state (doesn't destroy actual resource)
terraform state rm aws_instance.web
```
```
# Pull remote state
terraform state pull
```
```
# Push local state to remote
terraform state push
```
Remote State Configuration (S3 backend):
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```
