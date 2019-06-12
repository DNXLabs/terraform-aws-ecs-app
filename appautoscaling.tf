resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  custom_suffix    = "${var.cluster_name}-${var.name}"
}

resource "aws_appautoscaling_target" "ecs" {
  count              = "${var.autoscaling_cpu ? 1 : 0}"
  max_capacity       = "${var.autoscaling_max}"
  min_capacity       = "${var.autoscaling_min}"
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.default.name}"
  role_arn           = "${aws_iam_service_linked_role.autoscaling.arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_cpu" {
  count              = "${var.autoscaling_cpu ? 1 : 0}"
  name               = "scale-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.ecs.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.ecs.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.ecs.service_namespace}"

  target_tracking_scaling_policy_configuration = {
    target_value       = "${var.autoscaling_target_cpu}"
    disable_scale_in   = false
    scale_in_cooldown  = "${var.autoscaling_scale_in_cooldown}"
    scale_out_cooldown = "${var.autoscaling_scale_out_cooldown}"

    predefined_metric_specification = {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
