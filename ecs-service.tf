resource "aws_ecs_service" "default" {
  name                               = var.name
  cluster                            = var.cluster_name
  task_definition                    = var.image != "" ? aws_ecs_task_definition.default[0].arn : var.task_definition_arn
  desired_count                      = var.service_desired_count
  iam_role                           = var.launch_type == "FARGATE" ? null : var.service_role_arn
  health_check_grace_period_seconds  = var.service_health_check_grace_period_seconds
  deployment_maximum_percent         = var.service_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.service_deployment_minimum_healthy_percent
  enable_execute_command             = true

  dynamic "network_configuration" {
    for_each = var.launch_type == "FARGATE" ? [var.subnets] : []
    content {
      subnets         = var.subnets
      security_groups = var.security_groups == "" ? null : var.security_groups
    }
  }

  dynamic "placement_constraints" {
    for_each = var.launch_type == "FARGATE" ? [] : var.placement_constraints
    content {
      expression = lookup(placement_constraints.value, "expression", null)
      type       = placement_constraints.value.type
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.launch_type == "FARGATE" ? [] : var.ordered_placement_strategy
    content {
      field = lookup(ordered_placement_strategy.value, "field", null)
      type  = ordered_placement_strategy.value.type
    }
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.green.arn
    container_name   = var.name
    container_port   = var.container_port
  }

  deployment_controller {
    type = var.deployment_controller # default "CODE_DEPLOY"
  }

  dynamic "capacity_provider_strategy" {
    iterator = capacity_provider_strategy

    for_each = var.ecs_service_capacity_provider_strategy
    content {
      capacity_provider = lookup(capacity_provider_strategy.value, "capacity_provider", var.launch_type == "FARGATE" ? (var.fargate_spot ? "FARGATE_SPOT" : "FARGATE") : "${var.cluster_name}-capacity-provider")
      weight            = lookup(capacity_provider_strategy.value, "weight", 1)
      base              = lookup(capacity_provider_strategy.value, "base", 0)
    }
  }

  lifecycle {
    ignore_changes = [load_balancer, task_definition, desired_count, capacity_provider_strategy]
  }

  depends_on = [
    aws_lb_listener_rule.green,
    aws_lb_listener_rule.blue
  ]
}
