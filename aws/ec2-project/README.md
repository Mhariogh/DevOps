
# 🟧 AWS EC2 Beginner Project — Host a Web Server

## 🎯 Goal
Launch an EC2 instance, secure it, and deploy a simple website.

---

## 🧩 Architecture

```mermaid
graph TD
    User -->|HTTP/SSH| SG(Security Group)
    SG --> EC2[EC2 Instance: Amazon Linux 2]
```

## ✅ 1. Create a Key Pair

- Go to EC2 → Key Pairs

- Create: bootcamp-key

- Download .pem file


## ✅ 2. Launch EC2 Instance

- EC2 → Launch Instance

- Name: web-server

- AMI: Amazon Linux 2

- Instance type: t2.micro (free tier)

- Key Pair: bootcamp-key

- Security Group:

   -- Allow SSH (22) from your IP

Allow HTTP (80) from anywhere
