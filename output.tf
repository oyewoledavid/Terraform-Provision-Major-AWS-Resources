output "route_table_ids" {
  value = module.route_tables.route_table_ids
}

output "eip_id" {
  value = [module.aws_eip.eip_id]
  
}

output "aws_internet_gateway_id" {
  value = module.aws_internet_gateway.aws_internet_gateway_id
  
}

output "nat_gateway_id" {
  value = module.aws_nat_gateway.nat_gateway_id
  
}

# output "security_groups_ids" {
#   value = module.aws_security_group.security_group_ids
  
# }

output "subnet_ids" {
  description = "List of all subnet IDs created by the module"
  value       = module.aws_subnets.subnet_ids
}

output "vpc_id" {
  value = module.aws_vpc.vpc_id
}

output "public_ec2_id" {
  value = module.aws_ec2.public_ec2-id
  
}
output "private_ec2_ids" {
  value = module.aws_private_ec2.private_ec2-ids
  
}

output "public_ec2_public_ip" {
  value = module.aws_ec2.public_ec2-public_ip
  
}

output "private_ec2_private_ips" {
  value = module.aws_private_ec2.private_ec2-private_ips
  
}

output "elb_dns" {
  value = module.aws_elb.elb-dns_name
  
}