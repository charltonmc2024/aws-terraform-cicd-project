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


##################################
# Elastic Beanstalk Web Tier Access
##################################

resource "aws_iam_role_policy_attachment" "eb_web_tier" {

  role = aws_iam_role.eb_ec2_role.name

  policy_arn =
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"

}


##################################
# Elastic Beanstalk ECR Pull Access
##################################

resource "aws_iam_role_policy_attachment" "eb_ecr_read" {

  role = aws_iam_role.eb_ec2_role.name

  policy_arn =
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

}


##################################
# Elastic Beanstalk Enhanced Health
##################################

resource "aws_iam_role_policy_attachment" "eb_health" {

  role = aws_iam_role.eb_ec2_role.name

  policy_arn =
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkEnhancedHealth"

}


##################################
# Elastic Beanstalk Instance Profile
##################################

resource "aws_iam_instance_profile" "eb_ec2_profile" {

  name = "${var.app_name}-elasticbeanstalk-ec2-profile"

  role = aws_iam_role.eb_ec2_role.name

}



##################################
# CodeBuild Role
##################################

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



##################################
# CodeBuild ECR Access
##################################

resource "aws_iam_role_policy_attachment" "codebuild_ecr" {

  role = aws_iam_role.codebuild_role.name

  policy_arn =
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"

}



##################################
# CodeBuild Elastic Beanstalk Access
##################################

resource "aws_iam_role_policy_attachment" "codebuild_eb" {

  role = aws_iam_role.codebuild_role.name

  policy_arn =
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkFullAccess"

}



##################################
# CodeBuild CloudWatch Logs
##################################

resource "aws_iam_role_policy_attachment" "codebuild_logs" {

  role = aws_iam_role.codebuild_role.name

  policy_arn =
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"

}



##################################
# CodePipeline Role
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



##################################
# CodePipeline Full Access
##################################

resource "aws_iam_role_policy_attachment" "codepipeline_policy" {

  role = aws_iam_role.codepipeline_role.name

  policy_arn =
    "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"

}



##################################
# CodePipeline S3 Artifact Access
##################################

resource "aws_iam_role_policy_attachment" "codepipeline_s3_policy" {

  role = aws_iam_role.codepipeline_role.name

  policy_arn =
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"

}



##################################
# CodePipeline CodeBuild Access
##################################

resource "aws_iam_role_policy" "codepipeline_codebuild" {

  name = "${var.app_name}-codebuild-access"

  role = aws_iam_role.codepipeline_role.id


  policy = jsonencode({

    Version = "2012-10-17"


    Statement = [

      {

        Effect = "Allow"


        Action = [

          "codebuild:StartBuild",

          "codebuild:BatchGetBuilds"

        ]


        Resource = [

          aws_codebuild_project.test.arn,

          aws_codebuild_project.build.arn,

          aws_codebuild_project.deploy.arn

        ]

      }

    ]

  })

}



##################################
# GitHub CodeConnections Access
##################################

resource "aws_iam_role_policy" "codepipeline_codestar_connection" {

  name = "${var.app_name}-codestar-connection"

  role = aws_iam_role.codepipeline_role.id


  policy = jsonencode({

    Version = "2012-10-17"


    Statement = [

      {

        Effect = "Allow"


        Action = [

          "codestar-connections:UseConnection"

        ]


        Resource = var.codestar_connection_arn

      }

    ]

  })

}