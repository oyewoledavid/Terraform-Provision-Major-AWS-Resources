resource "aws_subnet" "subnets" {
  vpc_id = var.vpc_id
  count             = length(var.subnet_cidrs)
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "subnet-${count.index}"
  }
}

