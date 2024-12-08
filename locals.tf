locals {
  environment = {
    domain          = "internal.example.com"
    base_api_url    = "https://block-staging-api.example.com/v1/"
    origin_url      = "http://internalwebapp:8080"
    container_image = "internalwebapp"
    cloudflare_config = {
      allowed_domains   = ["@example.com"]
      allowed_countries = ["NG"]
      allowed_with_warp      = ["REPLACE_WITH_YOUR_CREATED_GROUP_ID"]
      allowed_emails    = ["saintmalik@example.com"]
    }
  }
}

# Infrastructure configuration locals
locals {
  container_image_url         = "RELACE_YOUR_CONTAINER_REGISTRY"
  container_image_repo        = "REPLACE_YOUR_CONTAINER_REPO"
  cloudflared_container_image = "cloudflared"
  instance_arch              = data.aws_ami.amazon_linux_2023.architecture == "x86_64" ? "amd64" : "arm64"
  aws_region                 = "us-east-1"

  common_tags = {
    Environment = "zerotrust"
    Managed     = "opentofu"
    Project     = "internalwebapp"
  }

  # SSM and tunnel configurations
  ssm_parameter = aws_ssm_parameter.tunnel.name
  tunnel_id     = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
}

locals {
  instance_values = templatefile("${path.module}/templates/cloud-init.yaml", {
    container_image_url         = local.container_image_url
    container_image_repo        = local.container_image_repo
    cloudflared_container_image = local.cloudflared_container_image
    instance_arch              = local.instance_arch
    region                     = local.aws_region
    bucket_name                = "REPLACE_WITH_YOUR_S3_BUCKET"
    tunnel_uuid                = local.tunnel_id
    ssm_parameter              = local.ssm_parameter
    origin_url                 = local.environment.origin_url
    base_api_url              = local.environment.base_api_url
    container_image           = local.environment.container_image
  })

  # Process the docker-compose file
  docker_compose = templatefile("${path.module}/templates/docker-compose.yml", {
    container_image_url         = local.container_image_url
    container_image_repo        = local.container_image_repo
    cloudflared_container_image = local.cloudflared_container_image
    instance_arch              = local.instance_arch
    tunnel_uuid                = local.tunnel_id
    ssm_parameter              = local.ssm_parameter
    origin_url                 = local.environment.origin_url
    base_api_url              = local.environment.base_api_url
    container_image           = local.environment.container_image
  })

  start_services = templatefile("${path.module}/templates/start-services.sh", {
    region              = local.aws_region
    container_image_url = local.container_image_url
  })
}

resource "aws_s3_object" "docker_compose" {
  bucket  = "REPLACE_WITH_YOUR_S3_BUCKET"
  key     = "configs/docker-compose.yml"
  content = local.docker_compose
}