resource "aws_lb_listener_rule" "green" {
  listener_arn = "${var.alb_listener_https_arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.green.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${split(",", var.hostname)}"]
  }

  lifecycle {
    ignore_changes = ["action.0.target_group_arn"]
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
    ignore_changes = ["action.0.target_group_arn"]
  }
}

resource "aws_lb_target_group" "green" {
  name                 = "ecs-${var.name}-green"
  port                 = "${var.port}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = 10

  health_check {
    path = "${var.healthcheck_path}"
  }
}

resource "aws_lb_target_group" "blue" {
  name                 = "ecs-${var.name}-blue"
  port                 = "${var.port}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = 10

  health_check {
    path = "${var.healthcheck_path}"
  }
}
