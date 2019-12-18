
resource "aws_ecs_service" "default" {
  name          = var.name
  cluster       = var.cluster_name
  desired_count = 1

  deployment_controller {
    type = "EXTERNAL"
  }

  lifecycle {
    ignore_changes = ["desired_count"]
  }
}
