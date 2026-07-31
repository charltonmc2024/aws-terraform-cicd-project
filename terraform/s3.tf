resource "aws_s3_bucket" "artifacts" {
  bucket        = "${var.app_name}-artifacts-1980"
  force_destroy = true
}
