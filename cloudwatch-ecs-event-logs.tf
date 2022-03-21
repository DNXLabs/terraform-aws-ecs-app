resource "aws_cloudwatch_log_group" "ecs_events" {
  name              = "/ecs/events/${var.cluster_name}/${var.name}"
  retention_in_days = var.cloudwatch_logs_retention
  tags = {
    ExportToS3 = var.cloudwatch_logs_export
  }
}


resource "aws_cloudwatch_event_rule" "ecs_events" {
  name          = "capture-ecs-events-${var.cluster_name}-${var.name}"
  description   = "Capture ecs service events from ${var.cluster_name}-${var.name}"
  event_pattern = <<EOF
{
  "source": ["aws.ecs"],
  "detail-type": ["ECS Task State Change", "ECS Container Instance State Change"],
  "detail": {
    "clusterArn": ["${data.aws_ecs_cluster.ecs_cluster.arn}"],
    "group": ["service:${var.name}"]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "ecs_events" {
  rule = aws_cloudwatch_event_rule.ecs_events.name
  arn  = aws_cloudwatch_log_group.ecs_events.arn
}

data "aws_iam_policy_document" "ecs_events" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = ["${aws_cloudwatch_log_group.ecs_events.arn}:*"]

    principals {
      identifiers = ["events.amazonaws.com", "delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "ecs_events" {
  policy_document = data.aws_iam_policy_document.ecs_events.json
  policy_name     = "capture-ecs-events-${var.cluster_name}-${var.name}"
}