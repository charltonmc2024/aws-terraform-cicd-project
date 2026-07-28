
# CodeBuild Test Project

resource "aws_codebuild_project" "test" {

  name = "${var.app_name}-test"

  description = "Test NGINX Docker application and Terraform"

  service_role = aws_iam_role.codebuild_role.arn


  artifacts {
    type = "CODEPIPELINE"
  }


  environment {

    compute_type = "BUILD_GENERAL1_SMALL"

    image = "aws/codebuild/standard:7.0"

    type = "LINUX_CONTAINER"

    privileged_mode = true

  }


  source {

    type = "CODEPIPELINE"

    buildspec = "buildspec-test.yml"

  }


  logs_config {

    cloudwatch_logs {

      group_name = "/aws/codebuild/terraform-nginx-test"

      stream_name = "test"

    }

  }
}



# CodeBuild Build Project

resource "aws_codebuild_project" "build" {

  name = "${var.app_name}-build"

  description = "Build NGINX deployment artifact"


  service_role = aws_iam_role.codebuild_role.arn


  artifacts {
    type = "CODEPIPELINE"
  }


  environment {

    compute_type = "BUILD_GENERAL1_SMALL"

    image = "aws/codebuild/standard:7.0"

    type = "LINUX_CONTAINER"

    privileged_mode = true

  }


  source {

    type = "CODEPIPELINE"

    buildspec = "buildspec-build.yml"

  }


  logs_config {

    cloudwatch_logs {

      group_name = "/aws/codebuild/terraform-nginx-build"

      stream_name = "build"

    }

  }
}

# CodeBuild Deploy Project
resource "aws_codebuild_project" "deploy" {

  name = "${var.app_name}-deploy"

  description = "Deploy AWS infrastructure using Terraform"


  service_role = aws_iam_role.codebuild_role.arn


  artifacts {
    type = "CODEPIPELINE"
  }


  environment {

    compute_type = "BUILD_GENERAL1_SMALL"

    image = "aws/codebuild/standard:7.0"

    type = "LINUX_CONTAINER"

    privileged_mode = true

  }


  source {

    type = "CODEPIPELINE"

    buildspec = "buildspec-deploy.yml"

  }


  logs_config {

    cloudwatch_logs {

      group_name = "/aws/codebuild/terraform-nginx-deploy"

      stream_name = "deploy"

    }

  }
}
