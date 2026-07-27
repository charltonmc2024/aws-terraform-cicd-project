# ECS Cluster

resource "aws_ecs_cluster" "main" {

  name = "${var.app_name}-cluster"

  tags = {
    Name = "${var.app_name}-cluster"
  }
}


# CloudWatch Log Group

resource "aws_cloudwatch_log_group" "ecs" {

  name = "/ecs/${var.app_name}"

  retention_in_days = 7
}


# ECS Task Definition

resource "aws_ecs_task_definition" "nginx" {

  family = "${var.app_name}-task"

  requires_compatibilities = [
    "FARGATE"
  ]

  network_mode = "awsvpc"

  cpu    = "256"
  memory = "512"


  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  task_role_arn = aws_iam_role.ecs_task_role.arn


  container_definitions = jsonencode([
    {
      name = "nginx"

      # Use ECR image
      image = "${aws_ecr_repository.nginx.repository_url}:${var.container_image_tag}"

      essential = true


      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]


      logConfiguration = {

        logDriver = "awslogs"

        options = {

          awslogs-group = aws_cloudwatch_log_group.ecs.name

          awslogs-region = var.aws_region

          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}


# ECS Service

resource "aws_ecs_service" "nginx" {

  name = "${var.app_name}-service"


  cluster = aws_ecs_cluster.main.id


  task_definition = aws_ecs_task_definition.nginx.arn


  desired_count = 1


  launch_type = "FARGATE"


  network_configuration {

    subnets = [
      aws_subnet.private_1.id,
      aws_subnet.private_2.id
    ]


    security_groups = [
      aws_security_group.ecs.id
    ]


    assign_public_ip = false
  }


  load_balancer {

    target_group_arn = aws_lb_target_group.nginx.arn

    container_name = "nginx"

    container_port = 80
  }


  depends_on = [
    aws_lb_listener.http
  ]
}
