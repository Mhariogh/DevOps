# AWS Hands-On Assignment

## Auto Scaling Group + Load Balancer + IAM + AWS CLI + S3

---

## Overview

In this assignment, you will build a full AWS infrastructure consisting of:

- IAM user
- AWS CLI configuration
- S3 bucket
- Local directory + test files copied to S3
- EC2 Launch Template
- Application Load Balancer (ALB)
- Auto Scaling Group (ASG)
- Traffic load simulation
- Monitoring scaling events

You will observe how ALB + ASG respond when traffic surges and reduces.

**Deliverable:** A folder containing screenshots, CLI outputs, and a short explanation of how scaling occurred.

---

## Part 1 — IAM User Creation

### Activity

Create an IAM user with programmatic access so you can use AWS CLI.

### Steps

1. Go to **IAM → Users → Create User**
2. Username: `student-asg-user`
3. Select: **Programmatic access**
4. Attach policy: **AdministratorAccess**
5. Download and save the **Access Key ID** and **Secret Access Key**
6. Confirm the user appears in the IAM console

### What to Submit

- Screenshot of the new IAM user (do NOT show Secret Key)

---

## Part 2 — Install & Configure AWS CLI

### Activity

Install AWS CLI and configure it using the IAM user created.

### Steps

#### Install AWS CLI

| Platform | Command |
|----------|---------|
| macOS | `brew install awscli` |
| Linux | `sudo apt install awscli` |
| Windows | Download the AWS CLI installer |

#### Configure the CLI

```bash
aws configure
```

Enter the following when prompted:

- Access Key
- Secret Key
- Region → `us-east-1`
- Output → `json`

#### Verify Identity

```bash
aws sts get-caller-identity
```

### What to Submit

- Screenshot or CLI output of `aws sts get-caller-identity`

---

## Part 3 — S3 Bucket + Local Directory + File Upload

### Activity

Create an S3 bucket, create local test files, and upload them using AWS CLI.

### Steps

#### 1. Create S3 Bucket

```bash
aws s3 mb s3://student-asg-bucket-<yourname>
```

#### 2. Create a Local Directory and Files

```bash
mkdir s3-test
cd s3-test
echo "Hello world" > file1.txt
echo "Sample data" > file2.txt
```

#### 3. Upload to S3

```bash
aws s3 cp . s3://student-asg-bucket-<yourname>/ --recursive
```

#### 4. Verify Upload

```bash
aws s3 ls s3://student-asg-bucket-<yourname>
```

### What to Submit

- Screenshot of S3 bucket with uploaded files

---

## Part 4 — Create an EC2 Launch Template

### Activity

Create a Launch Template that boots a simple web server.

### Steps

1. Navigate to **EC2 → Launch Templates → Create template**
2. Name: `asg-demo-template`
3. AMI: Amazon Linux 2 or Amazon Linux 2023
4. Instance type: `t2.micro`
5. Expand **"Advanced details"** → Paste User Data:

```bash
#!/bin/bash
yum install -y httpd
systemctl enable httpd
systemctl start httpd
echo "Hello from Auto Scaling instance" > /var/www/html/index.html
```

6. Save the template

### What to Submit

- Screenshot of the Launch Template

---

## Part 5 — Application Load Balancer (ALB)

### Activity

Create an ALB that distributes traffic across Auto Scaling instances.

### Steps

#### A. Create Target Group

1. Navigate to **EC2 → Target Groups → Create Target Group**
2. Target type: **Instances**
3. Name: `asg-target-group`
4. Protocol: HTTP, Port 80
5. Health check path: `/`
6. Click **Create**

#### B. Create the ALB

1. Navigate to **EC2 → Load Balancers → Create Load Balancer**
2. Choose **Application Load Balancer**
3. Name: `asg-load-balancer`
4. Scheme: **Internet-facing**
5. Add two public subnets
6. Security group → allow HTTP (port 80)
7. Listener → Forward to `asg-target-group`

### What to Submit

- Screenshot of ALB
- Screenshot of Target Group

---

## Part 6 — Create Auto Scaling Group (ASG)

### Activity

Use your Launch Template and ALB to create an ASG.

### Steps

1. Navigate to **EC2 → Auto Scaling Groups → Create**
2. Select `asg-demo-template`
3. Choose your VPC and subnets
4. Attach to Target Group: `asg-target-group`
5. Set Capacity:
   - Min: 1
   - Desired: 1
   - Max: 3

#### Scaling Policies

| Action | Trigger |
|--------|---------|
| Scale out | CPU > 40% |
| Scale in | CPU < 20% |

### What to Submit

- Screenshot of ASG details

---

## Part 7 — Simulate Traffic Surge (Stress Test)

### Activity

Generate CPU load to trigger Auto Scaling behavior.

### Steps

#### 1. SSH into the Instance

```bash
ssh ec2-user@<EC2-Public-IP>
```

#### 2. Install Stress Tool

```bash
sudo amazon-linux-extras install epel -y
sudo yum install stress -y
```

#### 3. Run Stress Test

```bash
stress --cpu 4 --timeout 120
```

### Expected Results

**During Load:**

- CPU spikes
- ASG launches 1–2 additional instances
- ALB registers new instances

**After Load Ends:**

- CPU drops
- ASG terminates excess instances

### What to Submit

- Screenshot of ASG scaling activity
- Screenshot of multiple instances launching

---

## Part 8 — Monitoring with AWS CLI + Console

### Activity

Verify scaling behavior through CLI and AWS Console.

### Steps

#### CLI Monitoring

```bash
aws autoscaling describe-auto-scaling-groups
```

```bash
aws autoscaling describe-scaling-activities
```

```bash
aws elbv2 describe-target-health --target-group-arn <TARGET-GROUP-ARN>
```

#### Console Monitoring

- **EC2 → Instances**
- **ASG → Activity**
- **CloudWatch → Metrics**
- **ALB → Target health**

### What to Submit

- Scaling events screenshot
- CLI output as a `.txt` file

---

## Final Deliverable Checklist

Students must submit:

- [ ] IAM user screenshot
- [ ] AWS CLI identity verification
- [ ] S3 bucket with uploaded files
- [ ] Launch Template screenshot
- [ ] Target Group + ALB screenshots
- [ ] ASG configuration screenshot
- [ ] Scaling activity screenshot
- [ ] 1–2 paragraph explanation describing:
  - How ASG scaled up during traffic surge
  - How ASG scaled down after load stopped
  - How ALB distributed traffic

---

**End of Assignment**
