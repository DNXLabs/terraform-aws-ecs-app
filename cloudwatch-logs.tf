resource "aws_cloudwatch_log_group" "default" {
  name = "/ecs/${var.cluster_name}/${var.name}"
}
