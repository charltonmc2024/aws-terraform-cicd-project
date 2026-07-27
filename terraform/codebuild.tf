# S3 bucket for CodePipeline/CodeBuild artifacts
resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.app_name}-${var.environment}-artifacts"

  tags = {
    Name = "${var.app_name}-artifacts"
  }
}

# CodeBuild Project
resource "aws_codebuild_project" "nginx" {

  name         = "${var.app_name}-build"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {

    compute_type = "BUILD_GENERAL1_SMALL"

    image = "aws/codebuild/standard:7.0"

    type = "LINUX_CONTAINER"

    privileged_mode = true

    environment_variable {
      name  = "REPOSITORY_URI"
      value = aws_ecr_repository.nginx.repository_url
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "BuildSpec.yml"
  }

  logs_config {

    cloudwatch_logs {
      group_name = "/aws/codebuild/${var.app_name}"
      status     = "ENABLED"
    }
  }

  tags = {
    Name = "${var.app_name}-codebuild"
  }
}
