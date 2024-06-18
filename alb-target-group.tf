resource "aws_lb_listener_rule" "green" {
  listener_arn = var.alb_listener_https_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }

  dynamic "condition" {
    for_each = length(var.paths) > 0 ? [var.paths] : []
    content {
      path_pattern {
        values = toset(condition.value)
      }
    }
  }

  dynamic "condition" {
    for_each = length(var.hostnames) > 0 ? [var.hostnames] : []
    content {
      host_header {
        values = toset(condition.value)
      }
    }
  }

  lifecycle {
    ignore_changes = [
      action[0].target_group_arn
    ]
  }

  priority = var.alb_priority != 0 ? var.alb_priority : null

  tags = merge(
    var.tags,
    {
      "Terraform" = true
    },
  )
}

resource "aws_lb_listener_rule" "blue" {
  listener_arn = var.test_traffic_route_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  dynamic "condition" {
    for_each = length(var.paths) > 0 ? [var.paths] : []
    content {
      path_pattern {
        values = toset(condition.value)
      }
    }
  }

  dynamic "condition" {
    for_each = length(var.hostnames) > 0 ? [var.hostnames] : []
    content {
      host_header {
        values = toset(condition.value)
      }
    }
  }

  lifecycle {
    ignore_changes = [
      action[0].target_group_arn
    ]
  }

  priority = var.alb_priority != 0 ? var.alb_priority + 1 : null

    tags = merge(
    var.tags,
    {
      "Terraform" = true
    },
  )
}

resource "aws_lb_listener_rule" "redirects" {
  count        = length(compact(split(",", var.hostname_redirects)))
  listener_arn = var.alb_listener_https_arn

  action {
    type = "redirect"

    redirect {
      host        = var.hostnames[0]
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
       values = tolist([element(split(",", var.hostname_redirects), count.index)])
    }
  }

    tags = merge(
    var.tags,
    {
      "Terraform" = true
    },
  )
}

# Generate a random string to add it to the name of the Target Group
resource "random_string" "alb_prefix" {
  length  = 4
  upper   = false
  special = false
}
resource "aws_lb_target_group" "green" {
  name                 = var.compat_keep_target_group_naming ? "${var.cluster_name}-${var.name}-gr" : format("%s-gr-%s", substr("${var.cluster_name}-${var.name}", 0, 24), random_string.alb_prefix.result)
  port                 = var.port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 10
  target_type          = var.launch_type == "FARGATE" ? "ip" : "instance"

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

    tags = merge(
    var.tags,
    {
      "Terraform" = true
    },
  )
}

resource "aws_lb_target_group" "blue" {
  name                 = var.compat_keep_target_group_naming ? "${var.cluster_name}-${var.name}-bl" : format("%s-bl-%s", substr("${var.cluster_name}-${var.name}", 0, 24), random_string.alb_prefix.result)
  port                 = var.port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 10
  target_type          = var.launch_type == "FARGATE" ? "ip" : "instance"

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

    tags = merge(
    var.tags,
    {
      "Terraform" = true
    },
  )
}
