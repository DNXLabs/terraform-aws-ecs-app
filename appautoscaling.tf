resource "aws_appautoscaling_target" "ecs" {
  count              = var.autoscaling_cpu || var.autoscaling_memory || var.autoscaling_custom ? 1 : 0
  max_capacity       = var.autoscaling_max
  min_capacity       = var.autoscaling_min
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.default.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_cpu" {
  count              = var.autoscaling_cpu ? 1 : 0
  name               = "scale-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs[0].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = var.autoscaling_target_cpu
    disable_scale_in   = false
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "scale_memory" {
  count              = var.autoscaling_memory ? 1 : 0
  name               = "scale-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs[0].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = var.autoscaling_target_memory
    disable_scale_in   = false
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "scale_custom" {
  for_each = var.autoscaling_custom

  name               = each.value.name # "scale-???"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs[0].service_namespace

  target_tracking_scaling_policy_configuration {
    scale_in_cooldown  = each.value.scale_in_cooldown
    scale_out_cooldown = each.value.scale_out_cooldown
    target_value       = each.value.target_value

    customized_metric_specification {
      metric_name = each.value.metric_name # CPUUtilization
      namespace   = each.value.namespace   # AWS/ECS
      statistic   = each.value.statistic   # Maximum
      dimensions {
        name  = "ClusterName"
        value = var.cluster_name
      }
      dimensions {
        name  = "ServiceName"
        value = var.name
      }
    }
  }
}
# target_tracking_scaling_policy_configuration {
#   scale_in_cooldown  = var.autoscaling_custom_scale_in_cooldown
#   scale_out_cooldown = var.autoscaling_custom_scale_out_cooldown
#   target_value       = var.autoscaling_custom_target_value

#   customized_metric_specification {
#     metric_name = var.autoscaling_custom_metric_name # CPUUtilization
#     namespace   = var.autoscaling_custom_namespace   # AWS/ECS
#     statistic   = var.autoscaling_custom_statistic
#     dimensions {
#       name  = "ClusterName"
#       value = var.cluster_name
#     }
#     dimensions {
#       name  = "ServiceName"
#       value = var.name
#     }
#   }
# }
