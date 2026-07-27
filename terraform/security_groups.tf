# ALB Security Group
resource "aws_security_group" "alb" {

  name = "${var.app_name}-alb-sg"

  description = "Allow HTTP/HTTPS traffic to ALB"

  vpc_id = aws_vpc.main.id


  # Allow HTTP from Internet
  ingress {
    description = "HTTP from anywhere"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "${var.app_name}-alb-sg"
  }
}



# ECS Security Group
resource "aws_security_group" "ecs" {

  name = "${var.app_name}-ecs-sg"

  description = "Allow traffic from ALB to ECS containers"

  vpc_id = aws_vpc.main.id


  # Allow traffic only from ALB
  ingress {

    description = "Traffic from ALB"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]
  }


  # Allow outbound access
  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }


  tags = {
    Name = "${var.app_name}-ecs-sg"
  }
}
