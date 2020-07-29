# terraform-aws-ecs-app

[![Lint Status](https://github.com/DNXLabs/terraform-aws-ecs-app/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-ecs-app/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-ecs-app)](https://github.com/DNXLabs/terraform-aws-ecs-app/blob/master/LICENSE)

AWS ECS Application Module

This module is designed to be used with `DNXLabs/terraform-aws-ecs`.

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.20 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alarm\_min\_healthy\_tasks | Alarm when the number of healthy tasks is less than this number (use 0 to disable this alarm) | `number` | `2` | no |
| alarm\_sns\_topics | Alarm topics to create and alert on ECS service metrics. Leaving empty disables all alarms. | `list` | `[]` | no |
| alb\_dns\_name | ALB DNS Name | `string` | `""` | no |
| alb\_listener\_https\_arn | ALB HTTPS Listener created by ECS cluster module | `any` | n/a | yes |
| alb\_only | Whether to deploy only an alb and no cloudFront or not with the cluster | `bool` | `false` | no |
| alb\_priority | priority rules ALB | `number` | `0` | no |
| autoscaling\_cpu | Enables autoscaling based on average CPU tracking | `bool` | `false` | no |
| autoscaling\_max | Max number of containers to scale with autoscaling | `number` | `4` | no |
| autoscaling\_min | Min number of containers to scale with autoscaling | `number` | `1` | no |
| autoscaling\_scale\_in\_cooldown | Cooldown in seconds to wait between scale in events | `number` | `300` | no |
| autoscaling\_scale\_out\_cooldown | Cooldown in seconds to wait between scale out events | `number` | `300` | no |
| autoscaling\_target\_cpu | Target average CPU percentage to track for autoscaling | `number` | `50` | no |
| cloudwatch\_logs\_export | Whether to mark the log group to export to an S3 bucket (needs terraform-aws-log-exporter to be deployed in the account/region) | `bool` | `false` | no |
| cloudwatch\_logs\_retention | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. | `number` | `120` | no |
| cluster\_name | n/a | `string` | `"Name of existing ECS Cluster to deploy this app to"` | no |
| codedeploy\_wait\_time\_for\_cutover | Time in minutes to route the traffic to the new application deployment | `number` | `0` | no |
| codedeploy\_wait\_time\_for\_termination | Time in minutes to terminate the new deployment | `number` | `0` | no |
| compat\_keep\_target\_group\_naming | Keeps old naming convention for target groups to avoid recreation of resource in production environments | `bool` | `false` | no |
| container\_port | Port your container listens (used in the placeholder task definition) | `string` | `"8080"` | no |
| cpu | Hard limit for CPU for the container | `string` | `"0"` | no |
| healthcheck\_interval | n/a | `string` | `"10"` | no |
| healthcheck\_matcher | The HTTP codes to use when checking for a successful response from a target | `number` | `200` | no |
| healthcheck\_path | n/a | `string` | `"/"` | no |
| healthcheck\_timeout | The amount of time, in seconds, during which no response | `number` | `5` | no |
| healthy\_threshold | The number of consecutive health checks successes required before considering an unhealthy target healthy | `number` | `3` | no |
| hosted\_zone | Hosted Zone to create DNS record for this app | `string` | `""` | no |
| hostname | Hostname to create DNS record for this app (DEPRECATED - use hostnames) | `string` | `""` | no |
| hostname\_create | Optional parameter to create or not a Route53 record | `string` | `"false"` | no |
| hostname\_redirects | List of hostnames to redirect to the main one, comma-separated | `string` | `""` | no |
| hostnames | List of hostnames to create DNS record for this app | `list` | `[]` | no |
| image | Docker image to deploy (can be a placeholder) | `string` | `""` | no |
| launch\_type | The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2. | `string` | `"EC2"` | no |
| log\_subscription\_filter\_destination\_arn | n/a | `string` | `""` | no |
| log\_subscription\_filter\_enabled | n/a | `string` | `false` | no |
| log\_subscription\_filter\_filter\_pattern | n/a | `string` | `""` | no |
| log\_subscription\_filter\_role\_arn | n/a | `string` | `""` | no |
| memory | Hard memory of the container | `string` | `"512"` | no |
| name | Name of your ECS service | `any` | n/a | yes |
| network\_mode | The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. (REQUIRED IF 'LAUCH\_TYPE' IS FARGATE) | `any` | `null` | no |
| path | Optional path to use on listener rule | `string` | `"/*"` | no |
| paths | List of path to use on listener rule | `list(string)` | `null` | no |
| platform\_version | The platform version on which to run your service. Only applicable for launch\_type set to FARGATE. Defaults to LATEST. | `string` | `"LATEST"` | no |
| port | Port for target group to listen | `string` | `"80"` | no |
| security\_groups | The security groups associated with the task or service | `any` | `null` | no |
| service\_deployment\_maximum\_percent | Maximum percentage of tasks to run during deployments | `number` | `200` | no |
| service\_deployment\_minimum\_healthy\_percent | Minimum healthy percentage during deployments | `number` | `100` | no |
| service\_desired\_count | Desired count for this service (for use when auto scaling is disabled) | `number` | `1` | no |
| service\_health\_check\_grace\_period\_seconds | Time until your container starts serving requests | `number` | `0` | no |
| service\_role\_arn | Existing service role ARN created by ECS cluster module | `any` | n/a | yes |
| subnets | The subnets associated with the task or service. (REQUIRED IF 'LAUCH\_TYPE' IS FARGATE) | `any` | `null` | no |
| task\_definition\_arn | Task definition to use for this service (optional) | `string` | `""` | no |
| task\_role\_arn | Existing task role ARN created by ECS cluster module | `any` | n/a | yes |
| test\_traffic\_route\_listener\_arn | ALB HTTPS Listener for Test Traffic created by ECS cluster module | `any` | n/a | yes |
| unhealthy\_threshold | The number of consecutive health check failures required before considering the target unhealthy | `number` | `3` | no |
| vpc\_id | VPC ID to deploy this app to | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws\_cloudwatch\_log\_group\_arn | n/a |

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-ecs-app/blob/master/LICENSE) for full details.