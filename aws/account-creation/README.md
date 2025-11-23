# 🟧 AWS Account Creation & Setup (Step-by-Step)

## ✅ 1. Create AWS Account
1. Go to https://aws.amazon.com
2. Click **Create an AWS Account**
3. Enter email, password, and account name
4. Choose **Personal Account**
5. Enter contact information
6. Enter credit card information (AWS requires it but you won’t be charged)
7. Verify identity via SMS
8. Select **Basic Support – Free**

---

## ✅ 2. Secure the Root Account
Immediately after login:
- Go to **IAM → Users & Groups**
- **Do NOT** use root for daily work.

---

## ✅ 3. Enable MFA (Mandatory)
1. Open **IAM → Users → Security Credentials**
2. Under **MFA**, click **Assign MFA**
3. Choose:
   - Authenticator App (Google Auth / Authy)
4. Scan QR → Confirm → Save

---

## ✅ 4. Create an Admin User
1. Go to **IAM → Users → Create User**
2. Username: `admin-user`
3. Add to group: **Administrators**
4. Enable console access

Login as this user going forward.

---

## 🧹 Free-Tier Monitoring
Enable billing alerts:
1. Go to **Billing Dashboard**
2. Turn on:
   - Free Tier Alerts  
   - Billing Alerts
3. Set budget = `$5`

---

You’re now ready for AWS projects 🚀
