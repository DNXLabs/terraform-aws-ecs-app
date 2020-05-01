data "aws_iam_account_alias" "current" {}

data "aws_region" "current" {}

data "aws_lb" "ecs" {
  name = "ecs-${var.cluster_name}"
}
