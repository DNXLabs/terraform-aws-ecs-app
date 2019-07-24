[
  {
    "name": "${name}",
    "image": "${image}",
    "cpu": ${cpu},
    "memory": ${memory},
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${port}
      }
    ],
    "log_configuration": {
      "log_driver": "awslogs",
      "options": {
          "awslogs-group": "${log_arn}",
          "awslogs-region": "ap-southeast-2",
          "awslogs-stream-prefix": "${var.name}"
      }
    }
  }
]
