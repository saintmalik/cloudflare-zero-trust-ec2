data "aws_ssm_parameter" "google_oauth_client_id" {
  name = "/internalwebapp/google_oauth_client_id"
}

data "aws_ssm_parameter" "google_oauth_client_secret" {
  name = "/internalwebapp/google_oauth_client_secret"
}

data "aws_ssm_parameter" "cloudflared" {
  name = "/internalwebapp/cloudflared"
}