// CREATE PUBLIC EC2 INSTANCE

resource "aws_instance" "main-ec2-public" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_ids
  key_name      = var.key_name
  vpc_security_group_ids = var.security_group_ids
  tags = {
    Name = "main-ec2-public"
  }
}

// CREATE 2 PRIVATE EC2 INSTANCE

resource "aws_instance" "main-ec2-private" {
    count = 2
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_ids
  key_name      = var.key_name
  vpc_security_group_ids = var.security_group_ids
  tags = {
    Name = "main-ec2-private-${count.index}"
  }
}