resource "aws_cloudwatch_metric_alarm" "min_healthy_tasks" {
  count = length(var.alarm_sns_topics) > 0 && var.alarm_min_healthy_tasks != 0 ? 1 : 0

  alarm_name                = "${data.aws_iam_account_alias.current.account_alias}-ecs-${var.cluster_name}-${var.name}-min-healthy-tasks"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "2"
  threshold                 = var.alarm_min_healthy_tasks
  alarm_description         = "Service has less than ${var.alarm_min_healthy_tasks} healthy tasks"
  alarm_actions             = var.alarm_sns_topics
  ok_actions                = var.alarm_sns_topics
  insufficient_data_actions = []
  treat_missing_data        = "ignore"

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

resource "aws_appautoscaling_policy" "scale_alb" {
  count              =  var.cloudwatch_metric_alb_connections ? 1 : 0
  name               = "alb_scaling"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs[0].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"
    

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = 1
    }
  }
  
}


resource "aws_cloudwatch_metric_alarm" "alb-connections" {
  count = var.cloudwatch_metric_alb_connections ? 1 : 0

  
  alarm_name                = "${data.aws_iam_account_alias.current.account_alias}-ecs-${var.cluster_name}-${var.name}-alb-average-connections"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  datapoints_to_alarm       = "2"
  threshold                 = var.alb_connections
  alarm_description         = "RequestCountPerTarget"
  insufficient_data_actions = []
  alarm_actions             = [aws_appautoscaling_policy.scale_alb[0].arn]
  metric_query {
    id          = "e1"
    expression  = "SUM([m1,m2])"
    label       = "Error Rate"
    return_data = "true"
  }
  metric_query {
    id = "m1"
    metric {
      metric_name = "RequestCountPerTarget"
      namespace   = "AWS/ApplicationELB"
      period      = "120"
      stat        = "Sum"
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
      metric_name = "RequestCountPerTarget"
      namespace   = "AWS/ApplicationELB"
      period      = "120"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        LoadBalancer = join("/", slice(split("/", data.aws_lb_listener.ecs.load_balancer_arn), 1, 4))
        TargetGroup  = aws_lb_target_group.green.arn_suffix
      }
    }
  }
}