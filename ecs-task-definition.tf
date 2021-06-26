resource "aws_ecs_task_definition" "default" {
  count = var.image != "" ? 1 : 0

  family = "${var.cluster_name}-${var.name}"

  execution_role_arn = var.task_role_arn
  task_role_arn      = var.task_role_arn

  requires_compatibilities = [var.launch_type]

  network_mode = var.launch_type == "FARGATE" ? "awsvpc" : var.network_mode
  cpu          = var.launch_type == "FARGATE" ? var.cpu : null
  memory       = var.launch_type == "FARGATE" ? var.memory : null

  container_definitions = <<EOT
[
  {
    "name": "${var.name}",
    "image": "${var.image}",
    "cpu": ${var.cpu},
    "memory": ${var.memory},
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${var.container_port}
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.default.name}",
          "awslogs-region": "${data.aws_region.current.name}",
          "awslogs-stream-prefix": "app"
      }
    }
  }
]
EOT
}
