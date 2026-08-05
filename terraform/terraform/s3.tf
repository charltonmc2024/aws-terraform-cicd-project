resource "random_id" "artifact_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "artifacts" {
  bucket        = "aws-terraform-cicd-artifacts-${random_id.artifact_suffix.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "DISABLED"
  }
}
