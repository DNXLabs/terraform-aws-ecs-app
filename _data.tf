data "aws_region" "current" {}

data "aws_iam_account_alias" "current" {
  count = var.alarm_prefix == "" ? 1 : 0
}
