
# 🟧 AWS EC2 Beginner Project — Host a Web Server

## 🎯 Goal
Launch an EC2 instance, secure it, and deploy a simple website.

---

## 🧩 Architecture

```mermaid
graph TD
    User -->|HTTP/SSH| SG(Security Group)
    SG --> EC2[EC2 Instance: Amazon Linux 2]
