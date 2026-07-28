resource "aws_codestarconnections_connection" "github_connection" {
  name          = "${var.app_name}-github-connection"
  provider_type = "GitHub"
}
