
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.53.0"
    }
  }

}

provider "aws" {
  region = "us-east-1"
}
// CREATE VPC
resource "aws_vpc" "main-vpc" {
  cidr_block = "12.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}
//CREATE PUBLIC SUBNET 1
resource "aws_subnet" "main-subnet-public-1a" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "12.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-subnet-1a"
  }
}
//CREATE PUBLIC SUBNET 2
resource "aws_subnet" "main-subnet-public-1b" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "12.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-subnet-1b"
  
  }
}
//CREATE PRIVATE SUBNET
resource "aws_subnet" "main-subnet-private-1a" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "12.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-1a"
  }
}
//CREATE INTERNET GATEWAY
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id
tags = {
  Name = "main-igw"
}
}
//ATTACH INTERNET GATEWAY TO VPC
# resource "aws_internet_gateway_attachment" "main-igw-attachment" {
#   vpc_id              = aws_vpc.main-vpc.id
#   internet_gateway_id = aws_internet_gateway.main-igw.id
#   lifecycle {
#     ignore_changes = all
#   }
# }
//CREATE ROUTE TABLES FOR PUBLIC SUBNETS
resource "aws_route_table" "main-public-rt" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
  tags = {
    Name = "main-public-rt"
  
  }
}
resource "aws_route_table" "main-public2-rt" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
  tags = {
    Name = "main-public2-rt"
  }
}
//ASSOCIATE PUBLIC ROUTE TABLES WITH PUBLIC SUBNETS
resource "aws_route_table_association" "main-public-rt-association-1a" {
  subnet_id      = aws_subnet.main-subnet-public-1a.id
  route_table_id = aws_route_table.main-public-rt.id
}
resource "aws_route_table_association" "main-public2-rt-association-1b" {
  subnet_id      = aws_subnet.main-subnet-public-1b.id
  route_table_id = aws_route_table.main-public2-rt.id

}
//CREATE PRIVATE ROUTE TABLE
resource "aws_route_table" "main-private-rt" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main-private-rt"
  
  }
}
//ASSOCIATE PRIVATE ROUTE TABLE WITH PRIVATE SUBNET
resource "aws_route_table_association" "main-private-rt-association-1a" {
  subnet_id      = aws_subnet.main-subnet-private-1a.id
  route_table_id = aws_route_table.main-private-rt.id

}
//CREATE NAT GATEWAY
resource "aws_nat_gateway" "main-ngw-1a" {
  subnet_id         = aws_subnet.main-subnet-public-1a.id
  allocation_id     = aws_eip.main-eip-1a.id
  connectivity_type = "public"
  tags = {
    Name = "main-ngw-1a"
  }
}
//CREATE EIP
resource "aws_eip" "main-eip-1a" {
  domain   = "vpc"
  tags = {
    Name = "main-eip-1a"
  }
}
//CREATE ROUTE FOR PRIVATE SUBNET TO NAT GATEWAY
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.main-private-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main-ngw-1a.id
}
//CREATE PUBLIC EC2 INSTANCE
resource "aws_instance" "public-ec2-1a" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main-subnet-public-1a.id
  key_name               = var.key
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.main-sg.id]

  tags = {
    Name = "public-ec2-1a"
  }

}
//CREATE PRIVATE EC2 INSTANCES
resource "aws_instance" "private-ec2" {
  count = 2

  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main-subnet-private-1a.id
  key_name               = var.key
  vpc_security_group_ids = [aws_security_group.main-sg.id]
  tags = {
    Name = "private-ec2-${count.index}"
  }
}
output "private-ec2" {
  value = aws_instance.private-ec2[*]
}
//CREATE SECURITY GROUP
resource "aws_security_group" "main-sg" {
  vpc_id = aws_vpc.main-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
//CREATE ELASTIC LOAD BALANCER
resource "aws_elb" "main-elb" {
  name               = "main-elb"
  subnets            = [aws_subnet.main-subnet-public-1a.id, aws_subnet.main-subnet-public-1b.id]
  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }
  instances = aws_instance.private-ec2[*].id
  security_groups = [aws_security_group.main-sg.id]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "main-elb"
  }
}
output "elb-dns" {
  value = aws_elb.main-elb.dns_name
}