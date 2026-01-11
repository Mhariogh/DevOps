# Terraform Complete Guide: Zero to Hero 🚀

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

# Install Terraform
choco install terraform

# Verify installation
terraform version
```

#### macOS (using Homebrew)
```bash
# Install Homebrew if you haven't already
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Terraform
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Verify installation
terraform version
```

#### Linux (Ubuntu/Debian)
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

### Step 2: Install and Configure VS Code

1. **Download and Install VS Code**
   - Visit https://code.visualstudio.com/
   - Download and install for your OS

2. **Install Terraform Extension**
   - Open VS Code
   - Press `Ctrl+Shift+X` (Windows/Linux) or `Cmd+Shift+X` (Mac)
   - Search for "HashiCorp Terraform"
   - Click Install on the official HashiCorp extension

3. **Configure VS Code Settings**

Press `Ctrl+,` (Windows/Linux) or `Cmd+,` (Mac) to open settings, then click the "Open Settings (JSON)" icon in the top right.

Add these settings:
```json
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

4. **Install Additional Helpful Extensions**
   - "Terraform Autocomplete" by Richard Sentino
   - "Better Comments" for better code documentation
   - "GitLens" for version control

### Step 3: Set Up AWS CLI and Credentials
```bash
# Install AWS CLI
# Windows: choco install awscli
# macOS: brew install awscli
# Linux: sudo apt install awscli

# Configure AWS credentials
aws configure

# You'll be prompted for:
# AWS Access Key ID: YOUR_ACCESS_KEY
# AWS Secret Access Key: YOUR_SECRET_KEY
# Default region name: us-east-1
# Default output format: json
```

**Alternative: Using Environment Variables**
```bash
# Linux/macOS
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
export AWS_DEFAULT_REGION="us-east-1"

# Windows PowerShell
$env:AWS_ACCESS_KEY_ID="your_access_key"
$env:AWS_SECRET_ACCESS_KEY="your_secret_key"
$env:AWS_DEFAULT_REGION="us-east-1"
```

---

## Phase 2: Terraform Fundamentals

### Understanding Core Concepts

#### Infrastructure as Code (IaC)
Infrastructure as Code is the practice of managing and provisioning infrastructure through machine-readable definition files rather than physical hardware configuration or interactive configuration tools.

#### Key Terraform Concepts

1. **Provider**: Plugins that allow Terraform to interact with cloud platforms, SaaS providers, and APIs
2. **Resource**: Components of your infrastructure (EC2 instances, S3 buckets, databases, etc.)
3. **Data Source**: Allows Terraform to fetch information from external sources
4. **State**: Terraform's representation of your infrastructure
5. **Module**: Container for multiple resources that are used together
6. **Variable**: Input parameters for your Terraform configurations
7. **Output**: Return values from your Terraform configurations

### The Terraform Workflow
```
terraform init    → Initialize working directory
       ↓
terraform plan    → Preview changes
       ↓
terraform apply   → Apply changes
       ↓
terraform destroy → Destroy infrastructure (when needed)
```

### Your First Terraform Configuration

Create a directory for your project:
```bash
mkdir terraform-learning
cd terraform-learning
```

Create a file named `main.tf`:
```hcl
# Configure the AWS Provider
terraform {
  required_version = ">= 1.0"
  
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
  bucket = "my-terraform-learning-bucket-12345"  # Must be globally unique
  
  tags = {
    Name        = "My First Bucket"
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}

# Output the bucket name
output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.my_first_bucket.id
}
```

### Essential Terraform Commands
```bash
# Initialize the working directory (downloads provider plugins)
terraform init

# Validate the configuration syntax
terraform validate

# Format your code to canonical style
terraform fmt

# Preview changes before applying
terraform plan

# Apply changes to create/update infrastructure
terraform apply

# Apply without interactive approval (use carefully)
terraform apply -auto-approve

# Show current state
terraform show

# List all resources in state
terraform state list

# Get specific output values
terraform output

# Destroy all resources defined in your configuration
terraform destroy
```

**Run your first configuration:**
```bash
terraform init
terraform plan
terraform apply
```

Type `yes` when prompted. Congratulations! You've created your first infrastructure with Terraform! 🎉

---

## Phase 3: Core Concepts with Examples

### Working with Variables

#### variables.tf
```hcl
# String variable
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

# Number variable
variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}

# Boolean variable
variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}

# List variable
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# Map variable
variable "instance_tags" {
  description = "Tags for EC2 instances"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "Learning"
  }
}

# Object variable
variable "database_config" {
  description = "Database configuration"
  type = object({
    allocated_storage = number
    engine            = string
    engine_version    = string
    instance_class    = string
  })
  default = {
    allocated_storage = 20
    engine            = "mysql"
    engine_version    = "8.0"
    instance_class    = "db.t3.micro"
  }
}

# Sensitive variable (won't be displayed in logs)
variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

# Variable with validation
variable "environment" {
  description = "Environment name"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
```

#### terraform.tfvars (Values file)
```hcl
aws_region         = "us-west-2"
instance_count     = 2
enable_monitoring  = true
availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

instance_tags = {
  Environment = "Production"
  Project     = "WebApp"
  Owner       = "DevOps Team"
}

environment = "prod"
```

#### Using Variables in Resources
```hcl
provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "web" {
  count                = var.instance_count
  ami                  = "ami-0c55b159cbfafe1f0"
  instance_type        = "t2.micro"
  availability_zone    = var.availability_zones[count.index % length(var.availability_zones)]
  monitoring           = var.enable_monitoring
  
  tags = merge(
    var.instance_tags,
    {
      Name = "web-server-${count.index + 1}"
    }
  )
}
```

### Working with Outputs

#### outputs.tf
```hcl
# Simple output
output "instance_ids" {
  description = "IDs of EC2 instances"
  value       = aws_instance.web[*].id
}

# Output with formatting
output "instance_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = [for instance in aws_instance.web : instance.public_ip]
}

# Sensitive output
output "database_password" {
  description = "Database administrator password"
  value       = var.db_password
  sensitive   = true
}

# Conditional output
output "environment_info" {
  description = "Environment configuration"
  value = {
    environment = var.environment
    region      = var.aws_region
    is_prod     = var.environment == "prod"
  }
}

# Output from data source
output "vpc_id" {
  description = "Default VPC ID"
  value       = data.aws_vpc.default.id
}
```

### Data Sources

Data sources allow Terraform to fetch information defined outside of Terraform or by another Terraform configuration.
```hcl
# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Get current AWS region
data "aws_region" "current" {}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Get available availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Use data sources in resources
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnets.default.ids[0]
  
  tags = {
    Name      = "WebServer"
    Region    = data.aws_region.current.name
    AccountID = data.aws_caller_identity.current.account_id
  }
}
```

---

## Phase 4: Intermediate Concepts

### Complete EC2 Instance with Security Group and Key Pair

#### Generate SSH Key Pair
```bash
# Generate SSH key pair on your local machine
ssh-keygen -t rsa -b 4096 -f ~/.ssh/terraform-demo -N ""

# This creates:
# ~/.ssh/terraform-demo (private key)
# ~/.ssh/terraform-demo.pub (public key)
```

#### Complete Configuration

**main.tf:**
```hcl
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Create a Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-key"
  public_key = file("~/.ssh/terraform-demo.pub")
  
  tags = {
    Name = "${var.project_name}-keypair"
  }
}

# Create a Security Group
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Security group for web servers"
  vpc_id      = data.aws_vpc.default.id
  
  # SSH access
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # In production, restrict this!
  }
  
  # HTTP access
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # HTTPS access
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Custom application port
  ingress {
    description = "Application port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Outbound internet access
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-web-sg"
  }
}

# Create EC2 Instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  
  # User data script to install and start nginx
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Hello from Terraform!</h1>" > /usr/share/nginx/html/index.html
              EOF
  
  # Root volume configuration
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
    tags = {
      Name = "${var.project_name}-root-volume"
    }
  }
  
  # Additional EBS volume
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 10
    volume_type = "gp3"
    encrypted   = true
  }
  
  tags = {
    Name        = "${var.project_name}-web-server"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Create Elastic IP
resource "aws_eip" "web" {
  instance = aws_instance.web.id
  domain   = "vpc"
  
  tags = {
    Name = "${var.project_name}-eip"
  }
}

# Data Sources
data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
```

**variables.tf:**
```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "terraform-demo"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```

**outputs.tf:**
```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.web.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.web.private_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.web_sg.id
}

output "ssh_connection_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i ~/.ssh/terraform-demo ec2-user@${aws_eip.web.public_ip}"
}
```

**Deploy and test:**
```bash
terraform init
terraform plan
terraform apply

# After apply completes, SSH into your instance:
terraform output ssh_connection_command
# Copy and run the output command
```

### Remote State with S3 Backend

Remote state is essential for team collaboration and production environments.

#### Step 1: Create S3 Bucket and DynamoDB Table (One-time setup)

**setup-backend.tf:**
```hcl
# This file creates the S3 bucket and DynamoDB table for remote state
# Run this FIRST, then move your state to remote backend

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

# S3 bucket for storing Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket-unique-12345"  # Must be globally unique
  
  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Production"
  }
}

# Enable versioning for state file history
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  
  attribute {
    name = "LockID"
    type = "S"
  }
  
  tags = {
    Name        = "Terraform State Lock Table"
    Environment = "Production"
  }
}

# Outputs
output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}
```

**Create the backend infrastructure:**
```bash
terraform init
terraform apply
```

#### Step 2: Configure Backend in Your Project

**backend.tf:**
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-unique-12345"  # Your bucket name
    key            = "prod/terraform.tfstate"                   # State file path
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
    
    # Optional: Use a specific profile
    # profile = "terraform"
  }
}
```

**Migrate existing local state to remote backend:**
```bash
# Initialize backend (will prompt to migrate state)
terraform init -migrate-state

# Verify state is now remote
terraform state list
```

#### Step 3: Multi-Environment Backend Configuration

For different environments, use different state files:

**backend-dev.tf:**
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-unique-12345"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
  }
}
```

**backend-prod.tf:**
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-unique-12345"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
  }
}
```

#### Working with Remote State
```bash
# Pull remote state to view
terraform state pull

# Force unlock if locked (use carefully!)
terraform force-unlock LOCK_ID

# Refresh state from real infrastructure
terraform refresh

# View state
terraform show
```

### Advanced Security Group Examples

**security-groups.tf:**
```hcl
# Web tier security group
resource "aws_security_group" "web_tier" {
  name        = "${var.project_name}-web-tier-sg"
  description = "Security group for web tier"
  vpc_id      = aws_vpc.main.id
  
  # Allow HTTP from anywhere
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow HTTPS from anywhere
  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow SSH from specific IP
  ingress {
    description = "SSH from admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip]
  }
  
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-web-sg"
    Tier = "Web"
  }
}

# Application tier security group
resource "aws_security_group" "app_tier" {
  name        = "${var.project_name}-app-tier-sg"
  description = "Security group for application tier"
  vpc_id      = aws_vpc.main.id
  
  # Allow traffic from web tier only
  ingress {
    description     = "Traffic from web tier"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_tier.id]
  }
  
  # Allow SSH from bastion
  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-app-sg"
    Tier = "Application"
  }
}

# Database tier security group
resource "aws_security_group" "db_tier" {
  name        = "${var.project_name}-db-tier-sg"
  description = "Security group for database tier"
  vpc_id      = aws_vpc.main.id
  
  # Allow MySQL from application tier only
  ingress {
    description     = "MySQL from app tier"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_tier.id]
  }
  
  # No outbound internet access for database
  egress {
    description = "Allow outbound to VPC only"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
  
  tags = {
    Name = "${var.project_name}-db-sg"
    Tier = "Database"
  }
}

# Bastion host security group
resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    description = "SSH from admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-bastion-sg"
  }
}
```

### Dynamic Security Group Rules
```hcl
variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  
  default = [
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    }
  ]
}

resource "aws_security_group" "dynamic_sg" {
  name        = "dynamic-sg"
  description = "Security group with dynamic rules"
  vpc_id      = aws_vpc.main.id
  
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

### Terraform Modules

Modules allow you to organize and reuse your Terraform code.

#### Creating a VPC Module

**modules/vpc/main.tf:**
```hcl
# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "${var.name}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.name}-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.name}-public-subnet-${count.index + 1}"
    Type = "Public"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.
