# CodeBuild IAM Role
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


# CloudWatch Logs + CodeBuild Permissions
resource "aws_iam_role_policy" "codebuild_policy" {

  name = "${var.app_name}-codebuild-policy"

  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]

        Resource = "*"
      }

    ]

  })
}


# Attach AdministratorAccess (for learning project)
resource "aws_iam_role_policy_attachment" "codebuild_admin" {

  role = aws_iam_role.codebuild_role.name

  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

}


