resource "aws_cloudwatch_log_group" "ecs_events" {
  count             = var.cloudwatch_logs_create ? 1 : 0
  name              = "/ecs/events/${var.cluster_name}/${var.name}"
  retention_in_days = var.cloudwatch_logs_retention
  tags = {
    ExportToS3 = var.cloudwatch_logs_export
  }
}


resource "aws_cloudwatch_event_rule" "ecs_events" {
  count         = var.cloudwatch_logs_create ? 1 : 0
  name          = "capture-ecs-events-${var.cluster_name}-${var.name}"
  description   = "Capture ecs service events from ${var.cluster_name}-${var.name}"
  event_pattern = <<EOF
{
  "source": ["aws.ecs"],
  "detail-type": ["ECS Task State Change", "ECS Container Instance State Change"],
  "detail": {
    "clusterArn": ["${var.cluster_arn}"],
    "group": ["service:${var.name}"]
  }
}
EOF
  tags = merge(
    var.tags,
    {
      "Terraform" = true
    },
  )
}

resource "aws_cloudwatch_event_target" "ecs_events" {
  count = var.cloudwatch_logs_create ? 1 : 0
  rule  = aws_cloudwatch_event_rule.ecs_events[0].name
  arn   = aws_cloudwatch_log_group.ecs_events[0].arn
}
