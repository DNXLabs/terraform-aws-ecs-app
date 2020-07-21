resource "aws_cloudwatch_log_subscription_filter" "log_subscription_filter" {
  count = var.log_subscription_filter_enabled ? 1 : 0

  name            = "${var.name}_subscription_filter"
  log_group_name  = aws_cloudwatch_log_group.default.name
  filter_pattern  = var.log_subscription_filter_filter_pattern
  role_arn        = var.log_subscription_filter_role_arn
  destination_arn = var.log_subscription_filter_destination_arn
}
