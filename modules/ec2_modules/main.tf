// CREATE PUBLIC EC2 INSTANCE

resource "aws_instance" "main-ec2-public" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main-subnet-public-1a.id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.main-sg.id]
  tags = {
    Name = "main-ec2-public"
  }
}

// CREATE 2 PRIVATE EC2 INSTANCE

resource "aws_instance" "main-ec2-private-1a" {
    count = 2
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main-subnet-private-1a.id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.main-sg.id]
  tags = {
    Name = "main-ec2-private-${count.index}"
  }
}