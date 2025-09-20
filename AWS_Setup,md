# AWS Setup Guide - DevOps Class

This guide will help you configure AWS for your DevOps projects, including account creation, IAM setup, CLI configuration, and billing alarms.

---

## 1. Create an AWS Account

1. Go to [https://aws.amazon.com/](https://aws.amazon.com/) and sign up.
2. Use a personal or course-provided email.
3. Select the **Free Tier** plan to avoid charges during practice.
4. Verify your email and phone number to activate the account.

---

## 2. Configure IAM User & Permissions

1. Log in to the AWS Management Console.
2. Navigate to **IAM > Users > Add user**.
3. Create a user with:
   - **Access type:** Programmatic access (for CLI)
   - **Permissions:** Attach `AdministratorAccess` (or course-specific policies)
4. Save the **Access Key ID** and **Secret Access Key** securely.

> ⚠️ Never share your access keys publicly.

5. Optional: Create **IAM groups** to manage multiple users with similar permissions.

---

## 3. Install and Configure AWS CLI

1. Install AWS CLI:
   - **Windows:** [Download installer](https://aws.amazon.com/cli/)
   - **macOS:** `brew install awscli`
   - **Linux:** `sudo apt install awscli`
2. Verify installation:
   ```bash
   aws --version
3. Configure CLI with your IAM credentials:
```
   aws configure
```
Enter:
Access Key ID
Secret Access Key
Default region (e.g., us-east-1)
Default output format (e.g., json)
4 Test CLI access:
```
 aws s3 ls
```

## 4. Set Up Billing Alerts

AWS can notify you when your costs exceed a certain threshold using **CloudWatch Alarms**.

---

### Step 1: Enable Billing Alerts

1. Go to **Billing > Preferences** in the AWS Console.
2. Check **Receive Billing Alerts** and save.

---

### Step 2: Create a CloudWatch Billing Alarm

1. Navigate to **CloudWatch > Alarms > Create alarm**.
2. Click **Select metric → Billing → Total Estimated Charge**.
3. Select **Currency (USD)** and metric **EstimatedCharges**.
4. Click **Select metric**.
5. Configure the alarm:
   - **Condition:** Greater/Equal
   - **Threshold:** e.g., 10 USD (adjust as needed)
6. Click **Next**.

---

### Step 3: Configure Alarm Actions

1. Choose **In Alarm → Send notification**.
2. Select an **SNS topic** or create a new one:
   - Go to **SNS > Topics > Create topic**
   - Name the topic (e.g., `BillingAlerts`)
   - Add your email as a subscriber
   - Confirm subscription via email
3. Click **Next**, review the alarm, and **Create alarm**.

> ✅ You will now receive email alerts whenever your AWS billing exceeds the set threshold.

## 5. Optional: Explore AWS Resources


Test EC2, S3, Lambda, and other services using the AWS CLI or Management Console.

Example CLI commands:
