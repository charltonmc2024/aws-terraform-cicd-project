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

##################################
# Elastic Beanstalk EC2 Role
##################################

resource "aws_iam_role" "eb_ec2_role" {

  name = "${var.app_name}-elasticbeanstalk-ec2-role"


  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "ec2.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

}


resource "aws_iam_role_policy_attachment" "eb_web_tier" {

  role = aws_iam_role.eb_ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"

}


resource "aws_iam_instance_profile" "eb_ec2_profile" {

  name = "${var.app_name}-elasticbeanstalk-ec2-profile"

  role = aws_iam_role.eb_ec2_role.name

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


resource "aws_iam_role_policy_attachment" "codepipeline_policy" {

  role = aws_iam_role.codepipeline_role.name

  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"

}
