data "aws_region" "current" {}

data "aws_lb_listener" "ecs" {
  arn = var.alb_listener_https_arn
}

data "aws_iam_account_alias" "current" {
  count = var.alarm_prefix == "" ? 1 : 0
}

data "aws_ecs_cluster" "ecs_cluster" {
  cluster_name = var.cluster_name
}
