
resource "aws_ecs_service" "default" {
  name                               = var.name
  cluster                            = var.cluster_name
  task_definition                    = var.image != "" ? aws_ecs_task_definition.default[0].arn : var.task_definition_arn
  desired_count                      = var.service_desired_count
  iam_role                           = var.service_role_arn
  health_check_grace_period_seconds  = var.service_health_check_grace_period_seconds
  deployment_maximum_percent         = var.service_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.service_deployment_minimum_healthy_percent

  load_balancer {
    target_group_arn = aws_lb_target_group.green.arn
    container_name   = var.name
    container_port   = var.container_port
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  lifecycle {
    ignore_changes = [load_balancer, task_definition, desired_count]
  }

  depends_on = [
    aws_lb_listener_rule.green,
    aws_lb_listener_rule.blue
  ]
}
