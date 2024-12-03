resource "aws_eip" "main-eip-1a" {
  domain = "vpc"
    tags = {
        Name = "main-eip-1a"
    }
  
}