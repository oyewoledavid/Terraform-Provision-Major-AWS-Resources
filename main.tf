//CREATE VPC
module "aws_vpc" {
  source = "./modules/vpc_modules"
  vpc_cidr_block = var.vpc_cidr_block
}

//CREATE SUBNETS
module "aws_subnets" {
  vpc_id = module.aws_vpc.vpc_id
  source = "./modules/subnets_modules"
  subnet_cidrs = var.subnet_cidrs
  availability_zones = var.availability_zones
}

//CREATE INTERNET GATEWAY
module "aws_internet_gateway" {
  source = "./modules/internet_gateway_modules"
  vpc_id = module.aws_vpc.vpc_id
}

//CREATE ROUTE TABLES
module "route_tables" {
  source              = "./modules/route_table_module"
  vpc_id              = module.aws_vpc.vpc_id
  internet_gateway_id = module.aws_internet_gateway.aws_internet_gateway_id
  nat_gateway_id      = var.nat_gateway_id
  destination_cidr_block = var.destination_cidr_block
  route_table_config  = {
    public_rt_1 = {
      name      = "Public-RT-1"
      is_public = true
    }
    public_rt_2 = {
      name      = "Public-RT-2"
      is_public = true
    }
    private_rt = {
      name      = "Private-RT"
      is_public = false
    }
  }
}

// ASSOCIATE ROUTE TABLES WITH SUBNETS

# Route table associations for public subnets
resource "aws_route_table_association" "public" {
  for_each = {
    public_rt_1 = module.aws_subnets.subnet_ids[0]
    public_rt_2 = module.aws_subnets.subnet_ids[1]
  }

  subnet_id      = each.value
  route_table_id = module.route_tables.route_table_ids[each.key]
}

# Route table association for private subnet
resource "aws_route_table_association" "private" {
  subnet_id      = module.aws_subnets.subnet_ids[2]
  route_table_id = module.route_tables.route_table_ids["private_rt"]
}

// CREATE ELASTIC IP
module "aws_eip" {
  source = "./modules/eip_module"
}

// CREATE NAT GATEWAY
module "aws_nat_gateway" {
  source = "./modules/nat_gateway_modules"
  subnet_ids = [module.aws_subnets.subnet_ids[0]]
  eip_ids = module.aws_eip.eip_id
  
}
resource "aws_route" "public_route" {
  for_each = { for key, value in var.route_table_config : key => value if value.is_public }
  route_table_id         = module.route_tables.route_table_ids[each.key]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

resource "aws_route" "private_route" {
  for_each = { for key, value in var.route_table_config : key => value if !value.is_public }
  route_table_id         = module.route_tables.route_table_ids[each.key]
  destination_cidr_block = var.destination_cidr_block
  nat_gateway_id         = var.nat_gateway_id
}


// CREATE SECURITY GROUP
module "aws_security_group" {
  source = "./modules/security_group_modules"
  vpc_id = module.aws_vpc.vpc_id
}
# //CREATE PUBLIC EC2 INSTANCE
# resource "aws_instance" "public-ec2-1a" {
#   ami                    = var.ami
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.main-subnet-public-1a.id
#   key_name               = var.key_name
#   associate_public_ip_address = true
#   vpc_security_group_ids = [aws_security_group.main-sg.id]

#   tags = {
#     Name = "public-ec2-1a"
#   }

# }
# //CREATE PRIVATE EC2 INSTANCES
# resource "aws_instance" "private-ec2" {
#   count = 2

#   ami                    = var.ami
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.main-subnet-private-1a.id
#   key_name               = var.key_name
#   vpc_security_group_ids = [aws_security_group.main-sg.id]
#   tags = {
#     Name = "private-ec2-${count.index}"
#   }
# }
# output "private-ec2" {
#   value = aws_instance.private-ec2[*]
# }
# //CREATE SECURITY GROUP
# resource "aws_security_group" "main-sg" {
#   vpc_id = aws_vpc.main-vpc.id
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
# //CREATE ELASTIC LOAD BALANCER
# resource "aws_elb" "main-elb" {
#   name               = "main-elb"
#   subnets            = [aws_subnet.main-subnet-public-1a.id, aws_subnet.main-subnet-public-1b.id]
#   listener {
#     instance_port     = 80
#     instance_protocol = "HTTP"
#     lb_port           = 80
#     lb_protocol       = "HTTP"
#   }
#   instances = aws_instance.private-ec2[*].id
#   security_groups = [aws_security_group.main-sg.id]
#   cross_zone_load_balancing = true
#   idle_timeout = 400
#   connection_draining = true

#   health_check {
#     target              = "HTTP:80/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }
#   tags = {
#     Name = "main-elb"
#   }
# }
# output "elb-dns" {
#   value = aws_elb.main-elb.dns_name
# }