#PROVIDERS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.68.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"

}

#DATASOURCE
data "aws_ami" "amazon_ami" {
  most_recent = true
  owners      = ["amazon"] #Author

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

#NETWORKING
resource "aws_vpc" "app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = local.common_tags_f2i
}

#INTERNET GATEWAY OR PUBLIC IP
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = local.common_tags_f2i
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.0.0/24"

  tags = local.common_tags_f2i
}

#ROUTING
resource "aws_route_table" "route_table_app" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }

  tags = local.common_tags_f2i
}

resource "aws_route_table_association" "app_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table_app.id
}

#SECURITY GROUPS FOR NGNIX CONFIG
resource "aws_security_group" "nginx_sg" {
  name        = "nginx_sg"
  description = "allow HTTP inbound traffic"

  #http access from anywhere
  ingress {
    description = "http from vpc"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  #outbound,internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#instance EC2
resource "aws_instance" "myec2" {
  ami           = data.aws_ami.amazon_ami.id
  instance_type = "t2.micro"
  key_name      = "devops_bella" # key pair

  tags = local.common_tags_f2i

  root_block_device {
    delete_on_termination = true
  }

  vpc_security_group_ids = ["${aws_security_group.nginx_sg.id}"]

  user_data = <<EOF
  #! /bin/bash
  sudo amazon-linux-extras install  -y nginx1.12
  sudo systemctl start nginx
  EOF

}