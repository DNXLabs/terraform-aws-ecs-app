# terraform-aws-ecs-app

[![Lint Status](https://github.com/DNXLabs/terraform-aws-ecs-app/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-ecs-app/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-ecs-app)](https://github.com/DNXLabs/terraform-aws-ecs-app/blob/master/LICENSE)

This terraform module is an AWS ECS Application Module for Scheduler without an Application Load Balancer(ALB), designed to be used with `DNXLabs/terraform-aws-ecs` (https://github.com/DNXLabs/terraform-aws-ecs).

The following resources will be created:
 - Cloudwatch Metrics alarm - Provides a CloudWatch Metric Alarm resource.
   - Service has less than minimum healthy tasks} healthy tasks
 - IAM roles - The cloudwatch event needs an IAM Role to run the ECS task definition. A role is created and a policy will be granted via IAM policy.
 - IAM policy - Policy to be attached to the IAM Role. This policy will have a trust with the cloudwatch event service. And it will use the managed policy `AmazonEC2ContainerServiceEventsRole` created by AWS.
 - Simple Notification Service (SNS) topics - Alarm topics to create and alert on ECS service metrics. Leaving empty disables all alarms.
 - Auto Scaling
    - You can specify the max number of containers to scale with autoscaling. The default is 4
    - You can specify the nin number of containers to scale with autoscaling. The default is 1
 - Cloudwatch Log Groups
      - You can specify the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653.
      - Export to a S3 Bucket - Whether to mark the log group to export to an S3 bucket (needs the module terraform-aws-log-exporter (https://github.com/DNXLabs/terraform-aws-log-exporter) to be deployed in the account/region)
 - ECS task definition - A task definition is required to run Docker containers in Amazon ECS. Some of the parameters you can specify in a task definition include:
      - Image - Docker image to deploy
      - CPU - Hard limit of the CPU for the container
           -  Default Value = 0
      - Memory - Hard memory of the container
           -  Default Value = 512
      - Name - Name of the ECS Service
      - Set log configuration

 - ECS Task-scheduler activated by cloudwatch events

In addition you have the option to create or not :
 - Application Load Balancer (ALB)
     - alb - An external ALB
     - alb_internal - A second internal ALB for private APIs
     - alb_only - Deploy only an Application Load Balancer and no cloudFront or not with the cluster
 - Autoscaling
     - Enables or not autoscaling based on average CPU tracking
     - Target average CPU percentage to track for autoscaling
 - Codedeploy
     -  Time in minutes to route the traffic to the new application deployment
     -  Time in minutes to terminate the new deployment

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alarm\_evaluation\_periods | The number of minutes the alarm must be below the threshold before entering the alarm state. | `string` | `"2"` | no |
| alarm\_min\_healthy\_tasks | Alarm when the number of healthy tasks is less than this number (use 0 to disable this alarm) | `number` | `2` | no |
| alarm\_prefix | String prefix for cloudwatch alarms. (Optional) | `string` | `"alarm"` | no |
| alarm\_sns\_topics | Alarm topics to create and alert on ECS service metrics. Leaving empty disables all alarms. | `list` | `[]` | no |
| alb\_dns\_name | ALB DNS Name | `string` | `""` | no |
| alb\_listener\_https\_arn | ALB HTTPS Listener created by ECS cluster module | `any` | n/a | yes |
| alb\_name | ALB name - Required if it is an internal one | `string` | `""` | no |
| alb\_only | Whether to deploy only an alb and no cloudFront or not with the cluster | `bool` | `false` | no |
| alb\_priority | priority rules ALB | `number` | `0` | no |
| autoscaling\_cpu | Enables autoscaling based on average CPU tracking | `bool` | `false` | no |
| autoscaling\_max | Max number of containers to scale with autoscaling | `number` | `4` | no |
| autoscaling\_memory | Enables autoscaling based on average Memory tracking | `bool` | `false` | no |
| autoscaling\_min | Min number of containers to scale with autoscaling | `number` | `1` | no |
| autoscaling\_scale\_in\_cooldown | Cooldown in seconds to wait between scale in events | `number` | `300` | no |
| autoscaling\_scale\_out\_cooldown | Cooldown in seconds to wait between scale out events | `number` | `300` | no |
| autoscaling\_target\_cpu | Target average CPU percentage to track for autoscaling | `number` | `50` | no |
| autoscaling\_target\_memory | Target average Memory percentage to track for autoscaling | `number` | `90` | no |
| cloudwatch\_logs\_export | Whether to mark the log group to export to an S3 bucket (needs terraform-aws-log-exporter to be deployed in the account/region) | `bool` | `false` | no |
| cloudwatch\_logs\_retention | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. | `number` | `120` | no |
| cluster\_name | n/a | `string` | `"Name of existing ECS Cluster to deploy this app to"` | no |
| codedeploy\_deployment\_config\_name | Specifies the deployment configuration for CodeDeploy | `string` | `"CodeDeployDefault.ECSAllAtOnce"` | no |
| codedeploy\_role\_arn | Existing IAM CodeDeploy role ARN created by ECS cluster module | `any` | `null` | no |
| codedeploy\_wait\_time\_for\_cutover | Time in minutes to route the traffic to the new application deployment | `number` | `0` | no |
| codedeploy\_wait\_time\_for\_termination | Time in minutes to terminate the new deployment | `number` | `0` | no |
| compat\_keep\_target\_group\_naming | Keeps old naming convention for target groups to avoid recreation of resource in production environments | `bool` | `false` | no |
| container\_port | Port your container listens (used in the placeholder task definition) | `string` | `"8080"` | no |
| cpu | Hard limit for CPU for the container | `string` | `"0"` | no |
| create\_iam\_codedeployrole | Create Codedeploy IAM Role for ECS or not. | `bool` | `true` | no |
| fargate\_spot | Set true to use FARGATE\_SPOT capacity provider by default (only when launch\_type=FARGATE) | `bool` | `false` | no |
| healthcheck\_interval | n/a | `string` | `"10"` | no |
| healthcheck\_matcher | The HTTP codes to use when checking for a successful response from a target | `number` | `200` | no |
| healthcheck\_path | n/a | `string` | `"/"` | no |
| healthcheck\_timeout | The amount of time, in seconds, during which no response | `number` | `5` | no |
| healthy\_threshold | The number of consecutive health checks successes required before considering an unhealthy target healthy | `number` | `3` | no |
| hosted\_zone | Hosted Zone to create DNS record for this app | `string` | `""` | no |
| hosted\_zone\_id | Hosted Zone ID to create DNS record for this app (use this to avoid data lookup when using `hosted_zone`) | `string` | `""` | no |
| hosted\_zone\_is\_internal | Set true in case the hosted zone is in an internal VPC, otherwise false | `string` | `"false"` | no |
| hostname\_create | Optional parameter to create or not a Route53 record | `string` | `"false"` | no |
| hostname\_redirects | List of hostnames to redirect to the main one, comma-separated | `string` | `""` | no |
| hostnames | List of hostnames to create listerner rule and optionally, DNS records for this app | `list` | `[]` | no |
| image | Docker image to deploy (can be a placeholder) | `string` | `""` | no |
| launch\_type | The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2. | `string` | `"EC2"` | no |
| log\_subscription\_filter\_destination\_arn | n/a | `string` | `""` | no |
| log\_subscription\_filter\_enabled | n/a | `string` | `false` | no |
| log\_subscription\_filter\_filter\_pattern | n/a | `string` | `""` | no |
| log\_subscription\_filter\_role\_arn | n/a | `string` | `""` | no |
| memory | Hard memory of the container | `string` | `"512"` | no |
| name | Name of your ECS service | `any` | n/a | yes |
| network\_mode | The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. (REQUIRED IF 'LAUCH\_TYPE' IS FARGATE) | `any` | `null` | no |
| ordered\_placement\_strategy | Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. The maximum number of ordered\_placement\_strategy blocks is 5. | <pre>list(object({<br>    field      = string<br>    expression = string<br>  }))</pre> | `[]` | no |
| paths | List of path to use on listener rule | `list(string)` | `[]` | no |
| placement\_constraints | Rules that are taken into consideration during task placement. Maximum number of placement\_constraints is 10. | <pre>list(object({<br>    type       = string<br>    expression = string<br>  }))</pre> | `[]` | no |
| platform\_version | The platform version on which to run your service. Only applicable for launch\_type set to FARGATE. Defaults to LATEST. | `string` | `"LATEST"` | no |
| port | Port for target group to listen | `string` | `"80"` | no |
| protocol | Protocol to use (HTTP or HTTPS) | `string` | `"HTTP"` | no |
| security\_groups | The security groups associated with the task or service | `any` | `null` | no |
| service\_deployment\_maximum\_percent | Maximum percentage of tasks to run during deployments | `number` | `200` | no |
| service\_deployment\_minimum\_healthy\_percent | Minimum healthy percentage during deployments | `number` | `100` | no |
| service\_desired\_count | Desired count for this service (for use when auto scaling is disabled) | `number` | `1` | no |
| service\_health\_check\_grace\_period\_seconds | Time until your container starts serving requests | `number` | `0` | no |
| service\_role\_arn | Existing service role ARN created by ECS cluster module | `any` | n/a | yes |
| source\_ips | List of source ip to use on listerner rule | `list` | `[]` | no |
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
