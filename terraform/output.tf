output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.nginx.repository_url
}

output "ecs_cluster_name" {
  description = "ECS Cluster name"
  value       = aws_ecs_cluster.main.name
}

output "load_balancer_dns" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.nginx.dns_name
}

output "codebuild_role_arn" {
  description = "IAM Role ARN for CodeBuild"
  value       = aws_iam_role.codebuild_role.arn
}

output "codebuild_test_project_name" {
  description = "CodeBuild Test Project Name"
  value       = aws_codebuild_project.test.name
}

output "codebuild_build_project_name" {
  description = "CodeBuild Build Project Name"
  value       = aws_codebuild_project.build.name
}

output "codebuild_deploy_project_name" {
  description = "CodeBuild Deploy Project Name"
  value       = aws_codebuild_project.deploy.name
}

output "github_connection_arn" {
  description = "ARN of the GitHub connection"
  value       = aws_codestarconnections_connection.github_connection.arn
}

output "eb_bucket_name" {

  description = "S3 bucket name used to store Elastic Beanstalk deployment packages"

  value = aws_s3_bucket.codepipeline_artifact.bucket

}
