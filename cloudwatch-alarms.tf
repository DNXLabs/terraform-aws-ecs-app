resource "aws_cloudwatch_metric_alarm" "min_healthy_tasks" {
  count = length(var.alarm_sns_topics) > 0 && var.alarm_min_healthy_tasks != 0 ? 1 : 0

  alarm_name                = "${try(data.aws_iam_account_alias.current[0].account_alias, var.alarm_prefix)}-ecs-${var.cluster_name}-${var.name}-min-healthy-tasks"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = var.alarm_evaluation_periods
  threshold                 = var.alarm_min_healthy_tasks
  alarm_description         = "Service has less than ${var.alarm_min_healthy_tasks} healthy tasks"
  alarm_actions             = var.alarm_sns_topics
  ok_actions                = var.alarm_sns_topics
  insufficient_data_actions = []
  treat_missing_data        = "ignore"

  tags = merge(
    var.tags,
    {
      "Terraform" = true
    },
  )

  metric_query {
    id          = "e1"
    expression  = "MAX(REMOVE_EMPTY([m1, m2]))"
    label       = "HealthyHostCountCombined"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "HealthyHostCount"
      namespace   = "AWS/ApplicationELB"
      period      = "60"
      stat        = "Maximum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = join("/", slice(split("/", data.aws_lb_listener.ecs.load_balancer_arn), 1, 4))
        TargetGroup  = aws_lb_target_group.blue.arn_suffix
      }
    }


  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "HealthyHostCount"
      namespace   = "AWS/ApplicationELB"
      period      = "60"
      stat        = "Maximum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = join("/", slice(split("/", data.aws_lb_listener.ecs.load_balancer_arn), 1, 4))
        TargetGroup  = aws_lb_target_group.green.arn_suffix
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_usage" {
  count = length(var.alarm_sns_topics) > 0 && var.alarm_high_cpu_usage_above != 0 ? 1 : 0

  alarm_name                = "${try(data.aws_iam_account_alias.current[0].account_alias, var.alarm_prefix)}-ecs-${var.cluster_name}-${var.name}-high-cpu-usage"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.alarm_evaluation_periods
  threshold                 = var.alarm_high_cpu_usage_above
  alarm_description         = "Service CPU usage average is above ${var.alarm_high_cpu_usage_above} percent"
  alarm_actions             = var.alarm_sns_topics
  ok_actions                = var.alarm_sns_topics
  insufficient_data_actions = []
  treat_missing_data        = "ignore"

  metric_name = "CPUUtilization"
  namespace   = "AWS/ECS"
  period      = "60"
  statistic   = "Average"
  unit        = "Percent"

  tags = merge(
    var.tags,
    {
      "Terraform" = true
    },
  )
  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = aws_ecs_service.default.name
  }

}

resource "aws_cloudwatch_metric_alarm" "ecs_running_tasks" {
  count = length(var.alarm_sns_topics) > 0 && var.alarm_ecs_running_tasks_threshold > 0 ? 1 : 0

  alarm_name                = "${try(data.aws_iam_account_alias.current[0].account_alias, var.alarm_prefix)}-ecs-${var.name}-running-tasks"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "RunningTaskCount"
  namespace                 = "ECS/ContainerInsights"
  period                    = "30"
  statistic                 = "Average"
  threshold                 = var.alarm_ecs_running_tasks_threshold
  alarm_description         = "Ecs service running tasks is lower than the threshold"
  alarm_actions             = var.alarm_sns_topics
  ok_actions                = var.alarm_sns_topics
  insufficient_data_actions = []
  treat_missing_data        = "ignore"
  tags = merge(
    var.tags,
    {
      "Terraform" = true
    },
  )
  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = aws_ecs_service.default.name
  }
}