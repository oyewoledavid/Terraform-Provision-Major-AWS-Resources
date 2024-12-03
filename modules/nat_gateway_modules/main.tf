resource "aws_nat_gateway" "main-ngw-1a" {
  subnet_id         = var.subnet_ids[0]
  allocation_id     = var.eip_ids[0]
  connectivity_type = "public"
  tags = {
    Name = "main-ngw-1a"
  }
  
}