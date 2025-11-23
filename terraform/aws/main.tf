provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "boot_key" {
  key_name   = "cloud101-key"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "web_sg" {
  name        = "cloud101-web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH from instructor"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.instructor_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "web_lt" {
  name_prefix   = "cloud101-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  key_name = aws_key_pair.boot_key.key_name

  network_interfaces {
    security_groups = [aws_security_group.web_sg.id]
    associate_public_ip_address = true
  }

  user_data = base64encode(var.user_data)
}

resource "aws_lb" "alb" {
  name               = "cloud101-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.public.ids
  security_groups    = [aws_security_group.web_sg.id]
}

resource "aws_lb_target_group" "web_tg" {
  name     = "cloud101-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = "cloud101-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = data.aws_subnets.public.ids
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.web_tg.arn]
  tag {
    key                 = "Name"
    value               = "cloud101-web"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = var.db_engine
  engine_version       = var.db_version
  instance_class       = var.db_instance_class
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.${var.db_engine}"
  skip_final_snapshot  = true
  publicly_accessible  = false
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.default.name
}

resource "aws_security_group" "db_sg" {
  name   = "cloud101-db-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "MySQL from web servers"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "cloud101-db-subnet"
  subnet_ids = data.aws_subnets.private.ids
}

# Data sources
data "aws_vpc" "default" {
  default = true
}
data "aws_subnets" "public" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
  filter {
    name = "tag:aws-cdk:subnet-type"
    values = ["Public","public"]
  }
}
data "aws_subnets" "private" {
  filter {
    name = "tag:aws-cdk:subnet-type"
    values = ["Private","private"]
  }
}
