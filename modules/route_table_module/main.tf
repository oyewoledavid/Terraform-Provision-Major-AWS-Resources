// ROUTE TABLES FOR PUBLIC SUBNETS
resource "aws_route_table" "main_rt" {
  for_each = var.route_table_config
  vpc_id   = var.vpc_id

  tags = {
    Name = each.value.name
  }
}

resource "aws_route" "public_route" {
  for_each = { for key, value in var.route_table_config : key => value if value.is_public }
  route_table_id         = aws_route_table.main_rt[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

resource "aws_route" "private_route" {
  for_each = { for key, value in var.route_table_config : key => value if !value.is_public }
  route_table_id         = aws_route_table.main_rt[each.key].id
  destination_cidr_block = var.destination_cidr_block
  nat_gateway_id         = var.nat_gateway_id
}