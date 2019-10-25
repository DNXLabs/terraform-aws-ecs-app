locals {
  path_condition_def = {
    field  = "path-pattern"
    values = var.path
  }
    
  path_condition = "${var.path != "" ? local.path_condition_def : map()}"
}

resource "aws_lb_listener_rule" "green" {
  listener_arn = "${var.alb_listener_https_arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.green.arn}"
  }

  dynamic "condition" {
    for_each = [local.path_condition]
    content {
      field  = lookup(condition.value, "field")
      values = list(lookup(condition.value, "values"))
    }
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
}

resource "aws_lb_listener_rule" "blue" {
  listener_arn = "${var.alb_listener_https_arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.blue.arn}"
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

resource "aws_lb_target_group" "green" {
  name                 = "${var.cluster_name}-${var.name}-gr"
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
  name                 = "${var.cluster_name}-${var.name}-bl"
  port                 = "${var.port}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = 10

  health_check {
    path     = "${var.healthcheck_path}"
    interval = "${var.healthcheck_interval}"
  }
}
