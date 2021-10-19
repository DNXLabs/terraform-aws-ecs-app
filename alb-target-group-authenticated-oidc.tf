resource "aws_lb_listener_rule" "green_auth_oidc" {
  count        = var.auth_oidc_enabled ? 1 : 0
  listener_arn = var.alb_listener_https_arn

  action {
    type = "authenticate-oidc"

    authenticate_oidc {
      authorization_endpoint = var.auth_oidc_authorization_endpoint
      client_id              = var.auth_oidc_client_id
      client_secret          = var.auth_oidc_client_secret
      issuer                 = var.auth_oidc_issuer
      token_endpoint         = var.auth_oidc_token_endpoint
      user_info_endpoint     = var.auth_oidc_user_info_endpoint
      session_timeout        = var.auth_oidc_session_timeout
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }

  dynamic "condition" {
    for_each = length(var.auth_oidc_paths) > 0 ? [var.auth_oidc_paths] : []
    content {
      path_pattern {
        values = toset(condition.value)
      }
    }
  }

  dynamic "condition" {
    for_each = length(var.auth_oidc_hostnames) > 0 ? [var.auth_oidc_hostnames] : [var.hostnames]
    content {
      host_header {
        values = toset(condition.value)
      }
    }
  }

  dynamic "condition" {
    for_each = var.http_header
    content {
      http_header {
        http_header_name = condition.value.name
        values           = condition.value.values
      }
    }
  }

  lifecycle {
    ignore_changes = [
      action[1].target_group_arn
    ]
  }

  priority = var.alb_priority != 0 ? var.alb_priority : null # this rule must come before the default rule
}