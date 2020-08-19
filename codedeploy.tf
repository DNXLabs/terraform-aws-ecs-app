resource "aws_codedeploy_app" "ecs" {
  compute_platform = "ECS"
  name             = "${var.cluster_name}-${var.name}"
}

resource "aws_codedeploy_deployment_group" "ecs" {
  app_name               = aws_codedeploy_app.ecs.name
  deployment_config_name = var.codedeploy_deployment_config_name
  deployment_group_name  = "${var.cluster_name}-${var.name}"
  service_role_arn       = aws_iam_role.codedeploy_service.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = var.codedeploy_wait_time_for_cutover == 0 ? "CONTINUE_DEPLOYMENT" : "STOP_DEPLOYMENT"
      wait_time_in_minutes = var.codedeploy_wait_time_for_cutover
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = var.codedeploy_wait_time_for_termination
    }

  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.cluster_name
    service_name = aws_ecs_service.default.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = list(var.alb_listener_https_arn)
      }

      test_traffic_route {
        listener_arns = list(var.test_traffic_route_listener_arn)
      }

      target_group {
        name = aws_lb_target_group.blue.name
      }

      target_group {
        name = aws_lb_target_group.green.name
      }
    }
  }
}
