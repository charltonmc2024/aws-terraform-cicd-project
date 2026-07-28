resource "aws_codepipeline" "nginx" {

  name     = "${var.app_name}-CodePipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {

    location = aws_s3_bucket.artifacts.bucket

    type = "S3"
  }
  ##################################
  # Source Stage
  ##################################
  stage {

    name = "Source"

    action {

      name = "Source"

      category = "Source"

      owner = "AWS"

      provider = "CodeStarSourceConnection"

      version = "1"

      output_artifacts = [
        "source_output"
      ]

      configuration = {

        ConnectionArn = var.codestar_connection_arn

        FullRepositoryId = var.github_repository

        BranchName = var.github_branch
      }
    }
  }

  ##################################
  # Test Stage
  ##################################

  stage {

    name = "Test"


    action {

      name = "Terraform_Test"

      category = "Build"

      owner = "AWS"

      provider = "CodeBuild"

      version = "1"


      input_artifacts = [
        "source_output"
      ]


      configuration = {

        ProjectName = aws_codebuild_project.test.name

      }

    }

  }

  ##################################
  # Build Stage
  ##################################

  stage {

    name = "Build"


    action {

      name = "Terraform_Build"

      category = "Build"

      owner = "AWS"

      provider = "CodeBuild"

      version = "1"


      input_artifacts = [
        "source_output"
      ]

      output_artifacts = [
        "build_output"
      ]
      configuration = {

        ProjectName = aws_codebuild_project.build.name

      }

    }

  }


  ##################################
  # Deploy Stage
  ##################################

  stage {

    name = "Deploy"


    action {

      name = "Terraform_Deploy"

      category = "Build"

      owner = "AWS"

      provider = "CodeBuild"

      version = "1"


      input_artifacts = [
        "build_output"
      ]


      configuration = {

        ProjectName = aws_codebuild_project.deploy.name

      }

    }

  }

}

##################################
# CodePipeline S3 Artifact Bucket
##################################

resource "aws_s3_bucket" "codepipeline_artifact" {

  bucket = "aws-terraform-cicd-artifacts-${random_id.bucket_suffix.hex}"

}


resource "random_id" "bucket_suffix" {

  byte_length = 4

}


##################################
# CodePipeline IAM Role
##################################

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


resource "aws_iam_role_policy_attachment" "codepipeline_admin" {

  role = aws_iam_role.codepipeline_role.name

  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

}


##################################
# CodePipeline
##################################

resource "aws_codepipeline" "terraform_pipeline" {

  name = "${var.app_name}-pipeline"


  role_arn = aws_iam_role.codepipeline_role.arn


  artifact_store {

    location = aws_s3_bucket.codepipeline_artifact.bucket

    type = "S3"

  }


  ##################################
  # Source Stage
  ##################################

  stage {

    name = "Source"


    action {

      name = "GitHub_Source"

      category = "Source"

      owner = "ThirdParty"

      provider = "GitHub"

      version = "1"


      output_artifacts = [
        "source_output"
      ]


      configuration = {

        Owner = "charltonmc2024"

        Repo = "aws-terraform-cicd-project"

        Branch = "main"

      }

    }

  }


  ##################################
  # Test Stage
  ##################################

  stage {

    name = "Test"


    action {

      name = "Terraform_Test"

      category = "Build"

      owner = "AWS"

      provider = "CodeBuild"

      version = "1"


      input_artifacts = [
        "source_output"
      ]


      configuration = {

        ProjectName = aws_codebuild_project.test.name

      }

    }

  }


  ##################################
  # Build Stage
  ##################################

  stage {

    name = "Build"


    action {

      name = "Terraform_Build"

      category = "Build"

      owner = "AWS"

      provider = "CodeBuild"

      version = "1"


      input_artifacts = [
        "source_output"
      ]


      configuration = {

        ProjectName = aws_codebuild_project.build.name

      }

    }

  }


  ##################################
  # Deploy Stage
  ##################################

  stage {

    name = "Deploy"


    action {

      name = "Terraform_Deploy"

      category = "Build"

      owner = "AWS"

      provider = "CodeBuild"

      version = "1"


      input_artifacts = [
        "source_output"
      ]


      configuration = {

        ProjectName = aws_codebuild_project.deploy.name

      }

    }

  }

}
