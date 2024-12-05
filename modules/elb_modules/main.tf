//CREATE ELASTIC LOAD BALANCER
resource "aws_elb" "main-elb" {
  name               = "main-elb"
  subnets            = var.subnet_ids
  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }
  instances = var.instances
  security_groups = var.security_group_ids
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