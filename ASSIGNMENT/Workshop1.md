# 📘 AWS Hands-On Assignment  
Auto Scaling Group + Load Balancer + IAM + AWS CLI + S3

---

## 🎯 Learning Objectives
- Create and configure IAM users for programmatic access  
- Install and configure AWS CLI  
- Create S3 buckets and upload files via CLI  
- Create a Launch Template  
- Configure an Auto Scaling Group (ASG)  
- Integrate an Application Load Balancer (ALB) with the ASG  
- Simulate traffic surge to trigger scaling  
- Monitor scaling events via AWS Console and CLI  

---

# 📌 PART 1: Create an IAM User

### Steps
1. IAM → Users → Create User  
2. Username: `student-asg-user`  
3. Select **Programmatic access**  
4. Attach **AdministratorAccess**  
5. Save access key and secret key  

---

# 📌 PART 2: Install & Configure AWS CLI

### Install
- macOS: `brew install awscli`
- Linux: `sudo apt install awscli`
- Windows: AWS CLI installer

### Configure
```bash
aws configure
```

### Verify
```bash
aws sts get-caller-identity
```

---

# 📌 PART 3: S3 – Local Directory, Test Files, Upload

### Create bucket
```bash
aws s3 mb s3://student-asg-bucket-<yourname>
```

### Create local files
```bash
mkdir s3-test
cd s3-test
echo "Hello world" > file1.txt
echo "Sample file" > file2.txt
```

### Upload
```bash
aws s3 cp . s3://student-asg-bucket-<yourname>/ --recursive
```

---

# 📌 PART 4: Create a Launch Template

User Data:
```bash
#!/bin/bash
yum install -y httpd
systemctl enable httpd
systemctl start httpd
echo "Hello from Auto Scaling instance" > /var/www/html/index.html
```

---

# 📌 PART 5: Create an Application Load Balancer

### Target Group
- Name: `asg-target-group`
- Protocol: HTTP  
- Port: 80  
- Health check path: `/`

### Load Balancer
- Type: **Application Load Balancer**  
- Scheme: **Internet-facing**  
- Listener: HTTP:80 → Forward to target group  

---

# 📌 PART 6: Create Auto Scaling Group

- Launch template: `asg-demo-template`
- Min: 1  
- Desired: 1  
- Max: 3  
- Attach to **asg-target-group**  
- Scaling:
  - Scale out: CPU > 40%  
  - Scale in: CPU < 20%  

---

# 📌 PART 7: Test Auto Scaling with Traffic Surge

### Load generation
SSH into instance then run:

```bash
sudo amazon-linux-extras install epel -y
sudo yum install stress -y
stress --cpu 4 --timeout 120
```

ASG will scale out → 2 or 3 instances  
When load stops → ASG scales in  

---

# 📌 PART 8: Monitoring

CLI:
```bash
aws autoscaling describe-auto-scaling-groups
aws autoscaling describe-scaling-activities
aws elbv2 describe-target-health --target-group-arn <TG-ARN>
```

Console:
- ASG → Activity  
- EC2 → Instances  
- ALB → Target Health  

---

# 📌 PART 9: Student Submission Checklist

- IAM user screenshot  
- AWS CLI verification  
- S3 bucket screenshot  
- Launch template screenshot  
- ALB screenshot  
- Target group screenshot  
- ASG screenshot  
- ASG scaling activity  
- Explanation of how ASG + ALB handle high/low traffic  
