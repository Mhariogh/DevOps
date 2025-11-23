# Classroom Assignments

## Assignment 1 — Account Setup (due: Day 1)
- Create AWS account and enable MFA
- Create instructor IAM user and a student IAM user
- Create budget alert set to $5

Deliverable: screenshot of IAM user list and budget alert.

## Assignment 2 — EC2 Web Server (due: Day 2)
- Launch EC2 t2/t3.micro with keypair
- Create security group allowing SSH from your IP and HTTP from everywhere
- Install Apache and host a simple index.html

Deliverable: public URL and a short 3-line reflection.

## Assignment 3 — Load Balancer & ASG (due: Day 3)
- Create ALB with target group
- Create Launch Template + Auto Scaling Group (min 1, desired 2)
- Attach ASG to target group

Deliverable: ALB DNS and # of instances observed.

## Assignment 4 — RDS Connection (due: Day 4)
- Create a private RDS MySQL instance (no public access)
- Update DB SG to accept traffic from web SG only
- Connect from EC2 and create a test table

Deliverable: SQL query results screenshot and cleanup confirmation.

