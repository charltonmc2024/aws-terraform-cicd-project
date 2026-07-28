##################################
# Elastic Beanstalk Application
##################################

resource "aws_elastic_beanstalk_application" "nginx" {

  name        = "${var.app_name}-terraform-app"
  description = "NGINX application deployed by Terraform CI/CD"

}


##################################
# Elastic Beanstalk Environment
##################################

resource "aws_elastic_beanstalk_environment" "nginx" {

  name = "${var.app_name}-production-env"

  application = aws_elastic_beanstalk_application.nginx.name


  # Docker platform
  platform_arn = "arn:aws:elasticbeanstalk:us-east-1::platform/Docker running on 64bit Amazon Linux 2023/4.13.4"


  ##################################
  # EC2 Instance Profile
  ##################################

  setting {

    namespace = "aws:autoscaling:launchconfiguration"

    name = "IamInstanceProfile"

    value = aws_iam_instance_profile.eb_ec2_profile.name

  }


  ##################################
  # VPC Configuration
  ##################################

  setting {

    namespace = "aws:ec2:vpc"

    name = "VPCId"

    value = aws_vpc.main.id

  }


  ##################################
  # EC2 Subnets
  ##################################

  setting {

    namespace = "aws:ec2:vpc"

    name = "Subnets"

    value = join(",", [
      aws_subnet.public_1.id,
      aws_subnet.public_2.id
    ])

  }


  ##################################
  # Load Balancer Subnets
  ##################################

  setting {

    namespace = "aws:ec2:vpc"

    name = "ELBSubnets"

    value = join(",", [
      aws_subnet.public_1.id,
      aws_subnet.public_2.id
    ])

  }


  ##################################
  # Environment Type
  ##################################

  setting {

    namespace = "aws:elasticbeanstalk:environment"

    name = "EnvironmentType"

    value = "LoadBalanced"

  }


  ##################################
  # Health Check
  ##################################

  setting {

    namespace = "aws:elasticbeanstalk:application"

    name = "Application Healthcheck URL"

    value = "/"

  }

}
