# 🟧 AWS Auto Scaling + Load Balancer Project

## 🎯 Goal
Deploy a scalable web application using:
- Launch Template  
- Auto Scaling Group  
- Application Load Balancer  

---

## 🧩 Architecture

```mermaid
graph TD
    User --> ALB
    ALB --> ASG
    ASG --> EC2[EC2 Instances]
```
