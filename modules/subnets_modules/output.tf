output "subnet_ids" {
  description = "List of all subnet IDs created by the module"
  value       = aws_subnet.subnets[*].id
}
