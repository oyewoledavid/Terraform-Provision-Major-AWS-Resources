output "public_ec2-id" {
  value = aws_instance.main-ec2-public.id
  
}
output "private_ec2-ids" {
  value = aws_instance.main-ec2-private[*].id
}
output "public_ec2-public_ip" {
  value = aws_instance.main-ec2-public.public_ip
  
}
output "private_ec2-private_ips" {
  value = aws_instance.main-ec2-private[*].private_ip
  
}