variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "public_key_path" {
  type = string
}

variable "instructor_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "user_data" {
  type = string
  default = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd
echo "<h1>Cloud 101 Auto-Scaled Web Server</h1>" > /var/www/html/index.html
EOF
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "db_engine" {
  type    = string
  default = "mysql"
}
variable "db_version" {
  type    = string
  default = "8.0"
}
variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}
variable "db_name" {
  type    = string
  default = "cloud101db"
}
variable "db_username" {
  type    = string
  default = "admin"
}
variable "db_password" {
  type    = string
  default = "ChangeMe123!"
}
variable "db_port" {
  type    = number
  default = 3306
}
