# AWS EKS Managed Launch Template Guide

## Complete Guide to Creating an EKS Cluster with Managed Launch Templates

This guide will walk you through creating an Amazon EKS cluster that automatically generates a managed launch template with `Managed: true`.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Method 1: Using AWS Console](#method-1-using-aws-console-easiest-for-beginners)
3. [Method 2: Using AWS CLI](#method-2-using-aws-cli-faster)
4. [Verification Steps](#verification-steps)
5. [Cleanup Instructions](#cleanup-instructions)
6. [Cost Information](#cost-information)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before starting, ensure you have:

- [ ] An active AWS account
- [ ] AWS CLI installed and configured (for CLI method)
- [ ] IAM permissions for:
  - Amazon EKS
  - Amazon EC2
  - Amazon VPC
  - IAM roles
  - CloudFormation
- [ ] `kubectl` installed (optional, for managing the cluster)
- [ ] Basic understanding of AWS services

### Installing AWS CLI (if needed)

```bash
# For Linux/macOS
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify installation
aws --version

# Configure AWS CLI
aws configure
```

---

## Method 1: Using AWS Console (Easiest for Beginners)

### Step 1: Create an EKS Cluster IAM Role

1. Navigate to **IAM Console** → **Roles** → **Create role**
2. Under **Trusted entity type**, select **AWS service**
3. Under **Use case**, select **EKS** → **EKS - Cluster**
4. Click **Next**
5. The policy `AmazonEKSClusterPolicy` should be automatically attached
6. Click **Next**
7. **Role name:** `eksClusterRole`
8. **Description:** IAM role for EKS cluster
9. Click **Create role**

### Step 2: Create a VPC for EKS

You can use an existing VPC or create a new one using AWS CloudFormation:

1. Go to **CloudFormation Console**
2. Click **Create stack** → **With new resources (standard)**
3. Under **Specify template**, choose **Amazon S3 URL**
4. Paste this URL:
   ```
   https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/amazon-eks-vpc-private-subnets.yaml
   ```
5. Click **Next**
6. **Stack name:** `eks-vpc-stack`
7. Leave all parameters as default
8. Click **Next** → **Next**
9. Check the acknowledgment box
10. Click **Submit**
11. **Wait** for stack status to show **CREATE_COMPLETE** (approximately 5-10 minutes)

### Step 3: Create the EKS Cluster

1. Navigate to **EKS Console** → **Clusters** → **Create cluster**

2. **Configure cluster:**
   - **Name:** `my-first-eks-cluster`
   - **Kubernetes version:** Select the latest version (e.g., 1.28 or 1.29)
   - **Cluster service role:** Select `eksClusterRole` from the dropdown
   - Click **Next**

3. **Specify networking:**
   - **VPC:** Select the VPC created by CloudFormation stack (`eks-vpc-stack`)
   - **Subnets:** Select all available subnets (should be 6 subnets)
   - **Security groups:** Leave as default
   - **Cluster endpoint access:** Select **Public**
   - **Cluster IP family:** IPv4
   - Click **Next**

4. **Configure observability:**
   - Leave all defaults (you can enable logging later if needed)
   - Click **Next**

5. **Select add-ons:**
   - Leave default add-ons selected:
     - Amazon VPC CNI
     - kube-proxy
     - CoreDNS
   - Click **Next**

6. **Configure selected add-ons settings:**
   - Leave all as default
   - Click **Next**

7. **Review and create:**
   - Review all settings
   - Click **Create**

8. **Wait** for cluster creation (approximately 10-15 minutes)
   - Status will change from "Creating" to **"Active"**

### Step 4: Create Node Group IAM Role

1. Navigate to **IAM Console** → **Roles** → **Create role**
2. Under **Trusted entity type**, select **AWS service**
3. Under **Use case**, select **EC2**
4. Click **Next**
5. Attach the following managed policies:
   - `AmazonEKSWorkerNodePolicy`
   - `AmazonEC2ContainerRegistryReadOnly`
   - `AmazonEKS_CNI_Policy`
6. Click **Next**
7. **Role name:** `eksNodeGroupRole`
8. **Description:** IAM role for EKS worker nodes
9. Click **Create role**

### Step 5: Create Managed Node Group (This Creates the Managed Launch Template!)

This is the crucial step where EKS will automatically create a managed launch template.

1. In **EKS Console**, click on your cluster: `my-first-eks-cluster`
2. Go to **Compute** tab
3. Under **Node groups**, click **Add node group**

4. **Configure Node Group:**
   - **Name:** `my-node-group`
   - **Node IAM role:** Select `eksNodeGroupRole`
   - **Launch template:** **Leave unchecked** ⚠️ (This is critical - do NOT select a launch template)
   - Click **Next**

5. **Set compute and scaling configuration:**
   - **AMI type:** Amazon Linux 2 (AL2_x86_64)
   - **Capacity type:** On-Demand
   - **Instance types:** t3.medium (or t3.small to reduce costs)
   - **Disk size:** 20 GiB
   - **Desired size:** 2
   - **Minimum size:** 1
   - **Maximum size:** 3
   - **Maximum unavailable:** 1
   - Click **Next**

6. **Specify networking:**
   - **Subnets:** Select the same subnets from your VPC (all 6 subnets)
   - **Configure remote access to nodes (optional):**
     - You can leave this unchecked for now
     - Or enable SSH access if you need it
   - Click **Next**

7. **Review and create:**
   - Review all settings
   - Click **Create**

8. **Wait** for node group creation (approximately 5-10 minutes)
   - Status will change from "Creating" to **"Active"**

### Step 6: Verify the Managed Launch Template ✅

1. Navigate to **EC2 Console** → **Launch Templates** (in the left sidebar)
2. Look for a launch template with a name pattern like:
   ```
   eks-XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
   ```
   or
   ```
   eks-my-node-group-XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
   ```
3. Click on the launch template
4. Check the **"Managed"** column → It should display **`true`** ✅

**Success!** You now have a launch template with `Managed: true` created by Amazon EKS.

---

## Method 2: Using AWS CLI (Faster)

### Prerequisites for CLI Method

Ensure AWS CLI is configured:

```bash
# Verify AWS CLI is installed
aws --version

# Configure if not already done
aws configure

# Set your AWS region
export AWS_REGION=us-east-1

# Get your AWS Account ID
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo "Your Account ID: $AWS_ACCOUNT_ID"
```

### Step 1: Create IAM Roles

#### Create EKS Cluster Role

```bash
# Create trust policy document for EKS cluster
cat > eks-cluster-trust-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

# Create the cluster role
aws iam create-role \
  --role-name eksClusterRole \
  --assume-role-policy-document file://eks-cluster-trust-policy.json

# Attach the required policy
aws iam attach-role-policy \
  --role-name eksClusterRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy

echo "EKS Cluster Role ARN: arn:aws:iam::$AWS_ACCOUNT_ID:role/eksClusterRole"
```

#### Create EKS Node Group Role

```bash
# Create trust policy document for EC2
cat > eks-nodegroup-trust-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

# Create the node group role
aws iam create-role \
  --role-name eksNodeGroupRole \
  --assume-role-policy-document file://eks-nodegroup-trust-policy.json

# Attach required policies
aws iam attach-role-policy \
  --role-name eksNodeGroupRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy

aws iam attach-role-policy \
  --role-name eksNodeGroupRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly

aws iam attach-role-policy \
  --role-name eksNodeGroupRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy

echo "EKS Node Group Role ARN: arn:aws:iam::$AWS_ACCOUNT_ID:role/eksNodeGroupRole"
```

### Step 2: Create VPC Using CloudFormation

```bash
# Download the VPC CloudFormation template
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/amazon-eks-vpc-private-subnets.yaml

# Create the VPC stack
aws cloudformation create-stack \
  --stack-name eks-vpc-stack \
  --template-body file://amazon-eks-vpc-private-subnets.yaml

# Wait for stack creation to complete (takes 5-10 minutes)
aws cloudformation wait stack-create-complete --stack-name eks-vpc-stack

# Get the VPC ID and Subnet IDs
export VPC_ID=$(aws cloudformation describe-stacks \
  --stack-name eks-vpc-stack \
  --query "Stacks[0].Outputs[?OutputKey=='VpcId'].OutputValue" \
  --output text)

export SUBNET_IDS=$(aws cloudformation describe-stacks \
  --stack-name eks-vpc-stack \
  --query "Stacks[0].Outputs[?OutputKey=='SubnetIds'].OutputValue" \
  --output text)

echo "VPC ID: $VPC_ID"
echo "Subnet IDs: $SUBNET_IDS"
```

### Step 3: Create EKS Cluster

```bash
# Create the EKS cluster
aws eks create-cluster \
  --name my-first-eks-cluster \
  --role-arn arn:aws:iam::$AWS_ACCOUNT_ID:role/eksClusterRole \
  --resources-vpc-config subnetIds=$SUBNET_IDS,endpointPublicAccess=true

# Wait for cluster to become active (takes 10-15 minutes)
echo "Waiting for cluster to become active (this may take 10-15 minutes)..."
aws eks wait cluster-active --name my-first-eks-cluster

# Verify cluster is active
aws eks describe-cluster --name my-first-eks-cluster --query cluster.status
```

### Step 4: Create Managed Node Group

This is where EKS will automatically create the managed launch template!

```bash
# Create the managed node group (EKS creates the managed launch template automatically)
aws eks create-nodegroup \
  --cluster-name my-first-eks-cluster \
  --nodegroup-name my-node-group \
  --node-role arn:aws:iam::$AWS_ACCOUNT_ID:role/eksNodeGroupRole \
  --subnets ${SUBNET_IDS//,/ } \
  --instance-types t3.medium \
  --scaling-config minSize=1,maxSize=3,desiredSize=2 \
  --disk-size 20

# Wait for node group to become active (takes 5-10 minutes)
echo "Waiting for node group to become active (this may take 5-10 minutes)..."
aws eks wait nodegroup-active \
  --cluster-name my-first-eks-cluster \
  --nodegroup-name my-node-group

# Verify node group is active
aws eks describe-nodegroup \
  --cluster-name my-first-eks-cluster \
  --nodegroup-name my-node-group \
  --query nodegroup.status
```

### Step 5: Verify the Managed Launch Template

```bash
# List all launch templates (look for ones starting with "eks-")
aws ec2 describe-launch-templates \
  --query 'LaunchTemplates[*].[LaunchTemplateName,LaunchTemplateId]' \
  --output table

# Get detailed information about EKS-managed launch templates
aws ec2 describe-launch-templates \
  --filters "Name=tag:eks:nodegroup-name,Values=my-node-group" \
  --query 'LaunchTemplates[*].[LaunchTemplateName,LaunchTemplateId]' \
  --output table

# To see if it's managed, check the tags
aws ec2 describe-launch-templates \
  --filters "Name=tag:eks:nodegroup-name,Values=my-node-group" \
  --query 'LaunchTemplates[*].{Name:LaunchTemplateName,ID:LaunchTemplateId,Tags:Tags}' \
  --output json
```

---

## Verification Steps

### Via AWS Console

1. Go to **EC2 Console** → **Launch Templates**
2. Find the template with name starting with `eks-`
3. Verify the **Managed** column shows **`true`**

### Via AWS CLI

```bash
# Check all launch templates
aws ec2 describe-launch-templates \
  --query 'LaunchTemplates[].[LaunchTemplateName,LaunchTemplateId]' \
  --output table

# Check for EKS-related tags
aws ec2 describe-launch-templates \
  --filters "Name=tag-key,Values=eks:nodegroup-name" \
  --output json
```

### Via EKS Console

1. Go to **EKS Console** → **Clusters** → `my-first-eks-cluster`
2. Click on **Compute** tab
3. You should see your node group with status **Active**
4. Click on the node group name
5. Under **Node Group configuration**, you'll see **Launch template** is auto-generated

---

## Cleanup Instructions

**Important:** Remember to delete all resources to avoid ongoing charges!

### Using AWS Console

#### Step 1: Delete Node Group
1. Go to **EKS Console** → **Clusters** → `my-first-eks-cluster`
2. Click **Compute** tab
3. Select `my-node-group`
4. Click **Delete**
5. Type the node group name to confirm
6. Click **Delete**
7. Wait until the node group is deleted (5-10 minutes)

#### Step 2: Delete EKS Cluster
1. In **EKS Console**, select `my-first-eks-cluster`
2. Click **Delete cluster**
3. Type the cluster name to confirm
4. Click **Delete**
5. Wait until the cluster is deleted (5-10 minutes)

#### Step 3: Delete the Managed Launch Template
The launch template should be automatically deleted when the node group is deleted. If not:
1. Go to **EC2 Console** → **Launch Templates**
2. Find the EKS-managed template
3. Select it → **Actions** → **Delete template**

#### Step 4: Delete VPC Stack
1. Go to **CloudFormation Console**
2. Select `eks-vpc-stack`
3. Click **Delete**
4. Click **Delete** to confirm
5. Wait for deletion to complete

#### Step 5: Delete IAM Roles
1. Go to **IAM Console** → **Roles**
2. Search for `eksClusterRole` → Select → **Delete**
3. Search for `eksNodeGroupRole` → Select → **Delete**

### Using AWS CLI

```bash
# Step 1: Delete the node group
aws eks delete-nodegroup \
  --cluster-name my-first-eks-cluster \
  --nodegroup-name my-node-group

# Wait for node group deletion (5-10 minutes)
echo "Waiting for node group to be deleted..."
aws eks wait nodegroup-deleted \
  --cluster-name my-first-eks-cluster \
  --nodegroup-name my-node-group

# Step 2: Delete the EKS cluster
aws eks delete-cluster --name my-first-eks-cluster

# Wait for cluster deletion (5-10 minutes)
echo "Waiting for cluster to be deleted..."
aws eks wait cluster-deleted --name my-first-eks-cluster

# Step 3: Delete the VPC stack
aws cloudformation delete-stack --stack-name eks-vpc-stack

# Wait for stack deletion
echo "Waiting for VPC stack to be deleted..."
aws cloudformation wait stack-delete-complete --stack-name eks-vpc-stack

# Step 4: Detach policies and delete IAM roles
# Detach policies from cluster role
aws iam detach-role-policy \
  --role-name eksClusterRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy

# Delete cluster role
aws iam delete-role --role-name eksClusterRole

# Detach policies from node group role
aws iam detach-role-policy \
  --role-name eksNodeGroupRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy

aws iam detach-role-policy \
  --role-name eksNodeGroupRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly

aws iam detach-role-policy \
  --role-name eksNodeGroupRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy

# Delete node group role
aws iam delete-role --role-name eksNodeGroupRole

# Clean up local files
rm -f eks-cluster-trust-policy.json eks-nodegroup-trust-policy.json amazon-eks-vpc-private-subnets.yaml

echo "Cleanup complete!"
```

---

## Cost Information

### EKS Costs

Be aware of the following costs:

1. **EKS Control Plane:** $0.10 per hour (~$73 per month)
2. **EC2 Worker Nodes:**
   - t3.medium: ~$0.0416/hour per instance (~$60/month for 2 instances)
   - t3.small: ~$0.0208/hour per instance (~$30/month for 2 instances)
3. **Data Transfer:** Standard AWS data transfer rates apply
4. **EBS Volumes:** ~$0.10 per GB-month (20GB = $2/month per instance)

**Estimated Monthly Cost:**
- With t3.medium: ~$193/month
- With t3.small: ~$133/month

**Cost Saving Tips:**
- Use t3.small instances for testing
- Set desired capacity to 1 instead of 2
- Delete resources immediately after testing
- Use AWS Free Tier if eligible (first 12 months)

---

## Troubleshooting

### Common Issues and Solutions

#### Issue 1: "Insufficient permissions" error

**Solution:**
- Ensure your IAM user/role has the necessary permissions
- Required permissions: EKS, EC2, VPC, IAM, CloudFormation

#### Issue 2: "No subnets available" error

**Solution:**
- Ensure you have at least 2 subnets in different availability zones
- Subnets must have available IP addresses
- Check subnet route tables have proper internet/NAT gateway routes

#### Issue 3: Node group fails to create

**Solution:**
- Verify the node group IAM role has all three required policies attached
- Check that the subnets have enough available IP addresses
- Ensure the instance type is available in your region

#### Issue 4: Can't find the managed launch template

**Solution:**
- Wait a few minutes for the template to appear
- Ensure you didn't select "Use launch template" when creating the node group
- Check EC2 Console → Launch Templates → Look for names starting with "eks-"

#### Issue 5: Cluster creation stuck

**Solution:**
- Cluster creation typically takes 10-15 minutes
- If it takes longer than 20 minutes, check CloudTrail for errors
- Verify VPC and subnet configuration

####
