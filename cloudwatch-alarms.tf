resource "aws_cloudwatch_metric_alarm" "high_memory" {
  count = "${length(var.alarm_sns_topics) > 0 ? 1 : 0}"

  alarm_name                = "${data.aws_iam_account_alias.current.account_alias}-ecs-${var.cluster_name}-${var.name}-high-memory"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "MemoryUtilization"
  namespace                 = "AWS/ECS"
  period                    = "300"
  statistic                 = "Maximum"
  threshold                 = "80"
  alarm_description         = "Cluster node memory above threshold"
  alarm_actions             = var.alarm_sns_topics
  ok_actions                = var.alarm_sns_topics

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = aws_ecs_service.default.name
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count = "${length(var.alarm_sns_topics) > 0 ? 1 : 0}"

  alarm_name                = "${data.aws_iam_account_alias.current.account_alias}-ecs-${var.cluster_name}-${var.name}-high-cpu"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = "300"
  statistic                 = "Maximum"
  threshold                 = "80"
  alarm_description         = "ECS service CPU utilization above threshold"
  alarm_actions             = var.alarm_sns_topics
  ok_actions                = var.alarm_sns_topics

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = aws_ecs_service.default.name
  }
}