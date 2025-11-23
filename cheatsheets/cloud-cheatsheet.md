# Cloud Cheatsheet (Quick Commands & Tips)

## AWS
- SSH into EC2:
  ssh -i key.pem ec2-user@<ip>
- Stop an EC2:
  aws ec2 stop-instances --instance-ids i-0123456789abcdef0
- Describe RDS:
  aws rds describe-db-instances --db-instance-identifier cloud101-db

## Azure
- Login:
  az login
- Create resource group:
  az group create -n cloud101-rg -l eastus
- Create VM:
  az vm create -g cloud101-rg -n cloud101vm --image UbuntuLTS --admin-username azureuser

## Tips
- Always tag resources with Course and Student
- Use budgets/alerts
- Delete resources after labs
