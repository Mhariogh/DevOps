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
Press Ctrl+Shift+X (Windows/Linux) or Cmd+Shift+X (Mac)
Search for "HashiCorp Terraform"
Click Install on the official HashiCorp extension


Configure VS Code Settings

Press Ctrl+, (Windows/Linux) or Cmd+, (Mac) to open settings, then click the "Open Settings (JSON)" icon in the top right.
Add these settings:


