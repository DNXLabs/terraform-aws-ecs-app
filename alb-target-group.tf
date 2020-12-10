resource "aws_lb_listener_rule" "green" {
  listener_arn = "${var.alb_listener_https_arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.green.arn}"
  }

  condition {
    field  = "host-header"
    values = split(",", var.hostname)
  }

  lifecycle {
    ignore_changes = [
      action[0].target_group_arn,
      condition,
    ]
  }
}

resource "aws_lb_listener_rule" "blue" {
  listener_arn = "${var.alb_listener_https_arn}"

  action {
    type             = "forward"
    target_group_arn = var.compat_keep_target_group_naming ? "${aws_lb_target_group.blue.arn}" : "${aws_lb_target_group.green.arn}"
    # target_group_arn = "${aws_lb_target_group.green.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.hostname_blue}"]
  }

  lifecycle {
    ignore_changes = ["action[0].target_group_arn"]
  }
}

resource "aws_lb_listener_rule" "redirects" {
  count        = "${length(compact(split(",", var.hostname_redirects)))}"
  listener_arn = "${var.alb_listener_https_arn}"

  action {
    type = "redirect"

    redirect {
      host        = "${var.hostname}"
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    field  = "host-header"
    values = ["${element(split(",", var.hostname_redirects), count.index)}"]
  }
}

# Generate a random string to add it to the name of the Target Group
resource "random_string" "alb_prefix" {
  length  = 4
  upper   = false
  special = false
}

resource "aws_lb_target_group" "green" {
  # name                 = "ecs-${var.name}-green"
  # name                 = format("ecs-${var.name}%s-green", var.env)
  # name                 = var.compat_keep_target_group_naming ? "ecs-${var.name}-green" : format("ecs-${var.name}%s-green", var.env)
  name                 = var.compat_keep_target_group_naming ? "ecs-${var.name}-green" : format("%s-gr-%s", substr("${var.cluster_name}-${var.name}", 0, 24), random_string.alb_prefix.result)
  port                 = "${var.port}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = 10

  health_check {
    path     = "${var.healthcheck_path}"
    interval = "${var.healthcheck_interval}"
  }
}

resource "aws_lb_target_group" "blue" {
  # name                 = "ecs-${var.name}-blue"
  # name                 = format("ecs-${var.name}%s-blue", var.env)
  # name                 = var.compat_keep_target_group_naming ? "ecs-${var.name}-blue" : format("ecs-${var.name}%s-blue", var.env)
  name                 = var.compat_keep_target_group_naming ? "ecs-${var.name}-blue" : format("%s-bl-%s", substr("${var.cluster_name}-${var.name}", 0, 24), random_string.alb_prefix.result)
  port                 = "${var.port}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = 10

  health_check {
    path     = "${var.healthcheck_path}"
    interval = "${var.healthcheck_interval}"
  }
}
