resource "aws_iam_role" "ecs_execution_role" {

  name = "${var.app_name}-ecs-execution-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {

  role = aws_iam_role.ecs_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {

  name = "${var.app_name}-ecs-task-role"


  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "codebuild_role" {

  name = "${var.app_name}-codebuild-role"


  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "codebuild.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "codebuild_policy" {

  role = aws_iam_role.codebuild_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}


resource "aws_iam_role_policy_attachment" "codebuild_logs" {

  role = aws_iam_role.codebuild_role.name

  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role" "codepipeline_role" {

  name = "${var.app_name}-codepipeline-role"


  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "codepipeline.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "codepipeline_policy" {

  name = "${var.app_name}-codepipeline-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "s3:*",
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds"
        ]

        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "codepipeline_policy" {

  role = aws_iam_role.codepipeline_role.name

  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

