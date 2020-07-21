resource "aws_cloudwatch_log_subscription_filter" "log_subscription_filter" {
  count = var.log_subscription_filter_enabled ? 1 : 0

  name            = var.log_subscription_filter_name
  role_arn        = var.log_subscription_filter_role_arn
  log_group_name  = var.log_subscription_filter_log_group_name
  filter_pattern  = var.log_subscription_filter_filter_pattern
  destination_arn = var.log_subscription_filter_destination_arn
}
