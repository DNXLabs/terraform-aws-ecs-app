resource "aws_ecs_task_definition" "default" {
count = "${var.container_definitions_flag ? 0 : 1}"
  family = "${var.name}"

  execution_role_arn = "${var.task_role_arn}"
  task_role_arn      = "${var.task_role_arn}"

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
    "log_configuration": {
      "log_driver": "awslogs",
      "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.default.arn}",
          "awslogs-region": "ap-southeast-2",
          "awslogs-stream-prefix": "app"
      }
    }
  }
]
EOT
 
  
}

resource "aws_ecs_task_definition" "custom" {
count = "${var.container_definitions_flag ? 1 : 0}"
  
  #family = "${var.customized_task_definition_arn != "" ? format("%s-default", var.name) : var.name}"
  family = "${var.name}"
  
  volume {
    name      = "${var.volume_name}"
    host_path = "${var.host_path}"
  }

  execution_role_arn = "${var.task_role_arn}"
  task_role_arn      = "${var.task_role_arn}"

  container_definitions = "${var.customized_definitions}"
  
  
}