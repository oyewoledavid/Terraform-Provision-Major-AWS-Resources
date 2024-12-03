//CREATE ELASTIC LOAD BALANCER
resource "aws_elb" "main-elb" {
  name               = "main-elb"
  subnets            = [aws_subnet.main-subnet-public-1a.id, aws_subnet.main-subnet-public-1b.id]
  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }
  instances = aws_instance.private-ec2[*].id
  security_groups = [aws_security_group.main-sg.id]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "main-elb"
  }
}