# ==============================================================================
# Application
# ==============================================================================
resource "cloudflare_zero_trust_access_application" "app" {
  account_id = var.cloudflare_account_id
  name       = "internalwebapp"
  domain     = local.environment.domain

  allowed_idps = [cloudflare_zero_trust_access_identity_provider.google_workspace.id]

  type                  = "self_hosted"
  session_duration      = "24h"
  app_launcher_visible  = true
  app_launcher_logo_url = var.cloudflare_app_logo
}

# ==============================================================================
# Access Policy
# ==============================================================================
resource "cloudflare_zero_trust_access_policy" "policy" {
  account_id     = var.cloudflare_account_id
  application_id = cloudflare_zero_trust_access_application.app.id

  name                           = "internalwebapp-filter"
  precedence                     = "1"
  decision                       = "allow"
  purpose_justification_required = true

  include {
    login_method = [cloudflare_zero_trust_access_identity_provider.google_workspace.id]
  }

  require {
    gsuite {
      identity_provider_id = cloudflare_zero_trust_access_identity_provider.google_workspace.id
    }
    group = local.environment.cloudflare_config.allowed_groups
  }
}

# ==============================================================================
# SECRETS
# ==============================================================================
resource "aws_ssm_parameter" "tunnel" {
  name        = "/internalwebapp/CREDENTIALS"
  description = "Cloudflared Tunnel: credentials JSON"
  type        = "SecureString"

  value = jsonencode({
    AccountTag   = var.cloudflare_account_id
    TunnelSecret = cloudflare_zero_trust_tunnel_cloudflared.tunnel.secret
    TunnelID     = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
  })

  tags = local.common_tags
}

# ==============================================================================
# TUNNEL
# ==============================================================================
resource "random_password" "tunnel_secret" {
  length  = 32
  special = false
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  account_id = var.cloudflare_account_id
  name       = "tunnel"
  secret     = random_password.tunnel_secret.result
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "config" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id

  config {
    warp_routing {
      enabled = true
    }
    ingress_rule {
      service = local.environment.origin_url
    }
  }
}

# ==============================================================================
# DNS Record
# ==============================================================================
resource "cloudflare_record" "dns" {
  zone_id = var.cloudflare_zone_id
  name    = local.environment.domain
  value   = cloudflare_zero_trust_tunnel_cloudflared.tunnel.cname
  type    = "CNAME"
  proxied = true
  ttl     = 1
  comment = "tunnel"
}

# ==============================================================================
# IdP
# ==============================================================================
resource "cloudflare_zero_trust_access_identity_provider" "google_workspace" {
  account_id = var.cloudflare_account_id
  name       = "Google Workspace IdP"
  type       = "google"

  config {
    client_id     = data.aws_ssm_parameter.google_oauth_client_id.value
    client_secret = data.aws_ssm_parameter.google_oauth_client_secret.value
    apps_domain   = var.google_workspace_domain
  }
}