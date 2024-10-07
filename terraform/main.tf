terraform {
  required_providers {
    aws={
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Region
provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name= "My-VPC"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name="IGW"
  }
}

# Subnets
resource "aws_subnet" "public-subnet" {
  count=2
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = element(["us-east-1a","us-east-1b"],count.index)
  tags={
    Name="Public-Subnet-${count.index+1}"
  }
}

# RouteTable
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block="0.0.0.0/0"
    gateway_id=aws_internet_gateway.IGW.id
  }

  tags = {
    Name="Public-Route_table"
  }
}

# Subnet associate to Route_Table
resource "aws_route_table_association" "Public-route_table-associate" {
  count=length(aws_subnet.public-subnet)
  subnet_id = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-route-table.id
}

# Security Group for the instance
resource "aws_security_group" "web_sg" {
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access from anywhere"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "web-sg"
  }
}

# Launching EC2 instance 
# resource "aws_instance" "server" {
#   ami=var.ami
#   instance_type               = var.instance_type
#   subnet_id                   = aws_subnet.public-subnet[0].id
#   security_groups             = [aws_security_group.web_sg.id]
#   associate_public_ip_address = true

#   tags = {
#     Name = "web-instance"
#   }

#   # Optional: Specify key pair for SSH access
#   key_name = "JenkinsServer"
# }