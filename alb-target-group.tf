resource "aws_lb_listener_rule" "green" {
  listener_arn = var.alb_listener_https_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }

  condition {
    field  = "path-pattern"
    values = list(var.path)
  }

  condition {
    field  = "host-header"
    values = list(var.hostname)
  }

  lifecycle {
    ignore_changes = [
      action[0].target_group_arn
    ]
  }

  priority = var.alb_priority != 0 ? var.alb_priority : null
}

resource "aws_lb_listener_rule" "blue" {
  listener_arn = var.test_traffic_route_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  condition {
    field  = "path-pattern"
    values = list(var.path)
  }

  condition {
    field  = "host-header"
    values = list(var.hostname)
  }

  lifecycle {
    ignore_changes = [
      action[0].target_group_arn
    ]
  }

  priority = var.alb_priority != 0 ? var.alb_priority + 1 : null
}

resource "aws_lb_listener_rule" "redirects" {
  count        = length(compact(split(",", var.hostname_redirects)))
  listener_arn = var.alb_listener_https_arn

  action {
    type = "redirect"

    redirect {
      host        = var.hostname
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    field  = "host-header"
    values = list(element(split(",", var.hostname_redirects), count.index))
  }
}

# Generate a random string to add it to the name of the Target Group
resource "random_string" "alb_prefix" {
  length  = 4
  upper   = false
  special = false
}
resource "aws_lb_target_group" "green" {
  name                 = var.compat_keep_target_group_naming ? "${var.cluster_name}-${var.name}-gr" : substr("${var.cluster_name}-${var.name}-gr-${random_string.alb_prefix.result}", 0, 32)
  port                 = var.port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 10

  health_check {
    path                = var.healthcheck_path
    interval            = var.healthcheck_interval
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.healthcheck_timeout
    matcher             = var.healthcheck_matcher

  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "blue" {
  name                 = var.compat_keep_target_group_naming ? "${var.cluster_name}-${var.name}-bl" : substr("${var.cluster_name}-${var.name}-bl-${random_string.alb_prefix.result}", 0, 32)
  port                 = var.port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 10

  health_check {
    path                = var.healthcheck_path
    interval            = var.healthcheck_interval
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.healthcheck_timeout
    matcher             = var.healthcheck_matcher
  }

  lifecycle {
    create_before_destroy = true
  }
}
