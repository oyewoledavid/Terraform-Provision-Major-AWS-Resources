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
  subnet_ids = module.aws_subnets.subnet_ids[0]
  eip_ids = module.aws_eip.eip_id
  
}
resource "aws_route" "public_route" {
  for_each = { for key, value in var.route_table_config : key => value if value.is_public }
  route_table_id         = module.route_tables.route_table_ids[each.key]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.aws_internet_gateway.aws_internet_gateway_id

}

resource "aws_route" "private_route" {
  for_each = { for key, value in var.route_table_config : key => value if !value.is_public }
  route_table_id         = module.route_tables.route_table_ids[each.key]
  destination_cidr_block = var.destination_cidr_block
  nat_gateway_id         = module.aws_nat_gateway.nat_gateway_id

  lifecycle {
    ignore_changes = [destination_cidr_block]
  }
}


// CREATE SECURITY GROUP
module "aws_security_group" {
  source = "./modules/security_group_modules"
  vpc_id = module.aws_vpc.vpc_id
}

// CREATE PUBLIC EC2 INSTANCES
module "aws_ec2" {
  source = "./modules/ec2_modules"
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_ids = module.aws_subnets.subnet_ids[0]
  security_group_ids = [module.aws_security_group.security_groups_ids]
}
// CREATE PRIVATE EC2 INSTANCES
module "aws_private_ec2" {
  source = "./modules/ec2_modules"
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_ids = module.aws_subnets.subnet_ids[2]
  security_group_ids = [module.aws_security_group.security_groups_ids]
}

# //CREATE ELASTIC LOAD BALANCER
module "aws_elb" {
  source = "./modules/elb_modules"
  subnet_ids = [module.aws_subnets.subnet_ids[0], module.aws_subnets.subnet_ids[1]]
  security_group_ids = [module.aws_security_group.security_groups_ids]
  instances = module.aws_ec2.private_ec2-ids
}

