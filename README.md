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
```powershell
choco install terraform
```

##### Verify installation
```hcl
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
```hcl
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

```powershell
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
```hcl
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
```hcl
# Initialize the working directory (downloads provider plugins)
terraform init
```

```hcl
# Preview changes before applying
terraform plan
```
```hcl
# Apply changes to create/update infrastructure
terraform apply
```
```hcl
# Destroy all resources defined in your configuration
terraform destroy
```
```hcl
# Format your code to canonical style
terraform fmt
```
```hcl

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
```hcl
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
### Step 11: Workspaces
Manage multiple environments:
```bash
# Create new workspace
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# List workspaces
terraform workspace list

# Switch workspace
terraform workspace select dev

# Show current workspace
terraform workspace show
```
```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = terraform.workspace == "prod" ? "t3.large" : "t2.micro"
  
  tags = {
    Environment = terraform.workspace
  }
}
```

## Phase 5: Advanced Concepts
### Step 12: Dynamic Blocks
Create repeatable nested blocks:

```hcl
variable "ingress_rules" {
  type = list(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

resource "aws_security_group" "web" {
  name = "web-sg"
  
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
```
### Step 13: Provisioners
Execute scripts on resources (use sparingly):
```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  # Run command on resource creation
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
    
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
  
  # Run command on resource destruction
  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Instance ${self.id} is being destroyed'"
  }
}
```

### Step 14: For Expressions and Loops
Advanced iteration techniques:
```hcl
# for_each with map
resource "aws_s3_bucket" "buckets" {
  for_each = {
    dev  = "dev-bucket"
    prod = "prod-bucket"
  }
  
  bucket = "${each.value}-${each.key}"
  
  tags = {
    Environment = each.key
  }
}

# for expression
locals {
  uppercase_names = [for name in var.names : upper(name)]
  
  name_map = {
    for idx, name in var.names : idx => name
  }
}
```
### Step 15: Conditional Expressions
```hcl
variable "environment" {
  type = string
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.environment == "prod" ? "t3.large" : "t2.micro"
  
  count = var.environment == "prod" ? 3 : 1
  
  tags = {
    Name = "web-${count.index}"
  }
}

# Ternary operator
locals {
  bucket_name = var.custom_bucket_name != "" ? var.custom_bucket_name : "default-bucket"
}
```

---

## Phase 6: Best Practices & Production

### Step 16: Project Structure

Organize your Terraform code:
```
terraform-project/
├── modules/
│   ├── networking/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/
│   └── database/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   ├── staging/
│   └── prod/
├── .gitignore
└── README.md
```

**.gitignore:**
```
# Local .terraform directories
**/.terraform/*

# .tfstate files
*.tfstate
*.tfstate.*

# Crash log files
crash.log

# Sensitive files
*.tfvars
!example.tfvars

# Override files
override.tf
override.tf.json

# CLI configuration files
.terraformrc
terraform.rc
```

### Step 17: Security Best Practices
```hcl
# Never hardcode secrets
# Bad:
resource "aws_db_instance" "db" {
  password = "supersecret123"  # DON'T DO THIS
}

# Good: Use variables and external secret management
variable "db_password" {
  type      = string
  sensitive = true
}

resource "aws_db_instance" "db" {
  password = var.db_password
}

# Mark sensitive outputs
output "db_password" {
  value     = aws_db_instance.db.password
  sensitive = true
}

# Use data sources for secrets
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "prod/db/password"
}
```
### Step 18: Testing Strategies
```bash
# Validate syntax
terraform validate

# Check formatting
terraform fmt -check -recursive

# Security scanning (use tools like tfsec)
# Install: brew install tfsec (Mac) or choco install tfsec (Windows)
tfsec .

# Compliance checking (use tools like checkov)
pip install checkov
checkov -d .

# Plan and review
terraform plan -out=tfplan

# Cost estimation (use Infracost)
# Install: brew install infracost (Mac) or choco install infracost (Windows)
infracost breakdown --path .
```

### Step 19: CI/CD Integration
Example GitHub Actions workflow:

```yaml
name: Terraform

on:
  push:
    branches: [ main ]
  pull_request:

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        
      - name: Terraform Format
        run: terraform fmt -check
        
      - name: Terraform Init
        run: terraform init
        
      - name: Terraform Validate
        run: terraform validate
        
      - name: Terraform Plan
        run: terraform plan
```

### Step 20: Advanced State Management
```hcl
# Import existing resources
# terraform import aws_instance.web i-1234567890abcdef0

# Taint resources (mark for recreation)
terraform taint aws_instance.web

# Untaint resources
terraform untaint aws_instance.web

# Refresh state (sync with actual infrastructure)
terraform refresh

# Replace specific resource
terraform apply -replace="aws_instance.web"
```

## Phase 7: Practice Projects

#### Project 1: Simple Web Server
Create an EC2 instance with a web server, security group, and elastic IP.

#### Project 2: Multi-Tier Architecture
Build a VPC with public/private subnets, load balancer, auto-scaling group, and RDS database.

#### Project 3: Modular Infrastructure
Create reusable modules for networking, compute, and storage. Use them across multiple environments.

#### Project 4: Complete CI/CD Pipeline
Set up infrastructure for a CI/CD pipeline including version control, build servers, and deployment targets.


## Additional Resources

- Official Documentation: https://www.terraform.io/docs
- Terraform Registry: https://registry.terraform.io (find providers and modules)
- HashiCorp Learn: https://learn.hashicorp.com/terraform
- Terraform Best Practices: https://www.terraform-best-practices.com
- Community: Join Terraform community forums and Discord servers

