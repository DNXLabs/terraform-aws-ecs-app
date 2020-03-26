data "aws_iam_account_alias" "current" {}

data "aws_region" "current" {}

data "aws_lb_listener" "selected" {
  arn = var.alb_listener_https_arn
}
