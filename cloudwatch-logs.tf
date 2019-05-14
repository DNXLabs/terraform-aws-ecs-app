resource "aws_cloudwatch_log_group" "default" {
  name = "ecs-${var.name}"
}
