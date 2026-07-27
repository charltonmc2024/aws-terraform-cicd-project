resource "aws_lb" "nginx" {

  name = "${var.app_name}-alb"

  load_balancer_type = "application"

  internal = false

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name = "${var.app_name}-alb"
  }
}

resource "aws_lb_target_group" "nginx" {

  name = "${var.app_name}-tg"

  port = 80

  protocol = "HTTP"

  vpc_id = aws_vpc.main.id


  target_type = "ip"


  health_check {

    enabled = true

    path = "/"

    port = "traffic-port"

    protocol = "HTTP"

    healthy_threshold = 3

    unhealthy_threshold = 3

    interval = 30

  }


  tags = {
    Name = "${var.app_name}-target-group"
  }
}

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.nginx.arn

  port = 80

  protocol = "HTTP"


  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.nginx.arn
  }
}
