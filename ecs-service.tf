
resource "aws_ecs_service" "default" {
  name                               = var.name
  cluster                            = var.cluster_name
  task_definition                    = var.image != "" ? aws_ecs_task_definition.default[0].arn : var.task_definition_arn
  desired_count                      = var.service_desired_count
  iam_role                           = var.launch_type == "FARGATE" ? null : var.service_role_arn
  health_check_grace_period_seconds  = var.service_health_check_grace_period_seconds
  deployment_maximum_percent         = var.service_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.service_deployment_minimum_healthy_percent
  launch_type                        = var.launch_type

  dynamic "network_configuration" {
    for_each = var.launch_type == "FARGATE" ? [var.subnets] : []
    content {
      subnets         = var.subnets
      security_groups = var.security_groups == "" ? null : var.security_groups
    }
  }

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

  tags = merge(
    var.tags,
    {
      "EcsService"    = var.name
      "EcsCluster"    = var.cluster_name
    },
  ) 

  depends_on = [
    aws_lb_listener_rule.green,
    aws_lb_listener_rule.blue
  ]
}
