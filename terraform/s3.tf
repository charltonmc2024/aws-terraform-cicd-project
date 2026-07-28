resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.app_name}-artifacts-1980"
}
