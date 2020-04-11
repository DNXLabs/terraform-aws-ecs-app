resource "aws_cloudwatch_log_group" "default" {
  name              = "/ecs/${var.cluster_name}/${var.name}"
  retention_in_days = var.cloudwatch_logs_retention
  tags = {
    ExportToS3 = var.cloudwatch_logs_export
  }
}
