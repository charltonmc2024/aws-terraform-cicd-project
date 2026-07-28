##################################
# Elastic Beanstalk Application
##################################

resource "aws_elastic_beanstalk_application" "nginx" {

  name = "${var.app_name}-terraform-app"

  description = "NGINX application deployed by Terraform CI/CD"

}


##################################
# Elastic Beanstalk Environment
##################################

resource "aws_elastic_beanstalk_environment" "nginx" {

  name = "${var.app_name}-production-env"

  application = aws_elastic_beanstalk_application.nginx.name


  solution_stack_name = "64bit Amazon Linux 2023 v4.5.0 running Docker"


  setting {

    namespace = "aws:autoscaling:launchconfiguration"

    name = "${var.app_name}-IamInstanceProfile"

    value = aws_iam_instance_profile.eb_ec2_profile.name

  }


}
