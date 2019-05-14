# resource "aws_appautoscaling_target" "ecs_target" {
#   max_capacity       = 4
#   min_capacity       = 1
#   resource_id        = "service/clusterName/serviceName"
#   role_arn           = "${var.ecs_iam_role}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }
# resource "aws_appautoscaling_policy" "ecs_policy" {
#   name               = "scale-down"
#   policy_type        = "StepScaling"
#   resource_id        = "${aws_appautoscaling_target.ecs_target.resource_id}"
#   scalable_dimension = "${aws_appautoscaling_target.ecs_target.scalable_dimension}"
#   service_namespace  = "${aws_appautoscaling_target.ecs_target.service_namespace}"
#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 60
#     metric_aggregation_type = "Maximum"
#     step_adjustment {
#       metric_interval_upper_bound = 0
#       scaling_adjustment          = -1
#     }
#   }
# }

