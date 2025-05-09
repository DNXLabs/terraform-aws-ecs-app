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
| terraform | >= 1.3 |
| aws | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0.0 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alarm\_ecs\_running\_tasks\_threshold | Alarm when the number of ecs service running tasks is lower than a certain value. CloudWatch Container Insights must be enabled for the cluster. | `number` | `0` | no |
| alarm\_evaluation\_periods | The number of minutes the alarm must be below the threshold before entering the alarm state. | `number` | `2` | no |
| alarm\_high\_cpu\_usage\_above | Alarm when CPU is above a certain value (use 0 to disable this alarm) | `number` | `80` | no |
| alarm\_min\_healthy\_tasks | Alarm when the number of healthy tasks is less than this number (use 0 to disable this alarm) | `number` | `2` | no |
| alarm\_prefix | String prefix for cloudwatch alarms. (Optional) | `string` | `"alarm"` | no |
| alarm\_sns\_topics | Alarm topics to create and alert on ECS service metrics. Leaving empty disables all alarms. | `list(string)` | `[]` | no |
| alb\_arn | ALB ARN created by ECS cluster module | `string` | n/a | yes |
| alb\_custom\_rules | Custom loadbalance listener rule to be added with this application target group | <pre>list(object({<br>    name        = optional(string)<br>    paths       = optional(list(string), [])<br>    hostnames   = optional(list(string), [])<br>    source_ips  = optional(list(string), [])<br>    http_header = optional(list(string), [])<br>    priority    = optional(number)<br>  }))</pre> | `[]` | no |
| alb\_dns\_name | ALB DNS Name | `string` | `""` | no |
| alb\_listener\_https\_arn | ALB HTTPS Listener created by ECS cluster module | `string` | n/a | yes |
| alb\_name | ALB name - Required if it is an internal one | `string` | `""` | no |
| alb\_only | Whether to deploy only an alb and no cloudFront or not with the cluster | `bool` | `false` | no |
| alb\_priority | priority rules ALB (leave 0 to let terraform calculate) | `number` | `0` | no |
| auth\_oidc\_authorization\_endpoint | Authorization endpoint for OIDC (Google: https://accounts.google.com/o/oauth2/v2/auth) | `string` | `""` | no |
| auth\_oidc\_client\_id | Client ID for OIDC authentication | `string` | `""` | no |
| auth\_oidc\_client\_secret | Client Secret for OIDC authentication | `string` | `""` | no |
| auth\_oidc\_enabled | Enables OIDC-authenticated listener rule | `bool` | `false` | no |
| auth\_oidc\_hostnames | List of hostnames to use as a condition to authenticate with OIDC | `list(string)` | `[]` | no |
| auth\_oidc\_issuer | Issuer URL for OIDC authentication (Google: https://accounts.google.com) | `string` | `""` | no |
| auth\_oidc\_paths | List of paths to use as a condition to authenticate (example: ['/admin\*']) | `list(string)` | `[]` | no |
| auth\_oidc\_session\_timeout | Session timeout for OIDC authentication (default 12 hours) | `number` | `43200` | no |
| auth\_oidc\_token\_endpoint | Token Endpoint URL for OIDC authentication (Google: https://oauth2.googleapis.com/token) | `string` | `""` | no |
| auth\_oidc\_user\_info\_endpoint | User Info Endpoint URL for OIDC authentication (Google: https://openidconnect.googleapis.com/v1/userinfo) | `string` | `""` | no |
| autoscaling\_cpu | Enables autoscaling based on average CPU tracking | `bool` | `false` | no |
| autoscaling\_custom | Set one or more app autoscaling by customized metric | <pre>list(object({<br>    name               = string<br>    scale_in_cooldown  = number<br>    scale_out_cooldown = number<br>    target_value       = number<br>    metric_name        = string<br>    namespace          = string<br>    statistic          = string<br>  }))</pre> | `[]` | no |
| autoscaling\_max | Max number of containers to scale with autoscaling | `number` | `4` | no |
| autoscaling\_memory | Enables autoscaling based on average Memory tracking | `bool` | `false` | no |
| autoscaling\_min | Min number of containers to scale with autoscaling | `number` | `1` | no |
| autoscaling\_scale\_in\_cooldown | Cooldown in seconds to wait between scale in events | `number` | `300` | no |
| autoscaling\_scale\_out\_cooldown | Cooldown in seconds to wait between scale out events | `number` | `300` | no |
| autoscaling\_target\_cpu | Target average CPU percentage to track for autoscaling | `number` | `50` | no |
| autoscaling\_target\_memory | Target average Memory percentage to track for autoscaling | `number` | `90` | no |
| cloudwatch\_logs\_create | Whether to create cloudwatch log resources or not | `bool` | `true` | no |
| cloudwatch\_logs\_export | Whether to mark the log group to export to an S3 bucket (needs terraform-aws-log-exporter to be deployed in the account/region) | `bool` | `false` | no |
| cloudwatch\_logs\_retention | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. | `number` | `120` | no |
| cluster\_arn | n/a | `string` | `"ARN of existing ECS Cluster to deploy this app to"` | no |
| cluster\_name | n/a | `string` | `"Name of existing ECS Cluster to deploy this app to"` | no |
| command | Command to run on container | `list(string)` | `null` | no |
| compat\_keep\_target\_group\_naming | Keeps old naming convention for target groups to avoid recreation of resource in production environments | `bool` | `false` | no |
| container\_port | Port your container listens (used in the placeholder task definition) | `number` | `8080` | no |
| cpu | Hard limit for CPU for the container | `number` | `0` | no |
| dynamic\_stickiness | Target Group stickiness. Used in dynamic block. | `any` | `[]` | no |
| ecs\_service\_capacity\_provider\_strategy | (Optional) The capacity provider strategy to use for the service. Can be one or more. These can be updated without destroying and recreating the service only if set to [] and not changing from 0 capacity\_provider\_strategy blocks to greater than 0, or vice versa. | `list` | <pre>[<br>  {}<br>]</pre> | no |
| efs\_mapping | A map of efs volume ids and paths to mount into the default task definition | `map(string)` | `{}` | no |
| enable\_schedule | Enables schedule to shut down and start up instances outside business hours. | `bool` | `false` | no |
| fargate\_spot | Set true to use FARGATE\_SPOT capacity provider by default (only when launch\_type=FARGATE) | `bool` | `false` | no |
| healthcheck\_interval | n/a | `number` | `10` | no |
| healthcheck\_matcher | The HTTP codes to use when checking for a successful response from a target | `number` | `200` | no |
| healthcheck\_path | n/a | `string` | `"/"` | no |
| healthcheck\_timeout | The amount of time, in seconds, during which no response | `number` | `5` | no |
| healthy\_threshold | The number of consecutive health checks successes required before considering an unhealthy target healthy | `number` | `3` | no |
| hosted\_zone | Hosted Zone to create DNS record for this app | `string` | `""` | no |
| hosted\_zone\_id | Hosted Zone ID to create DNS record for this app (use this to avoid data lookup when using `hosted_zone`) | `string` | `""` | no |
| hosted\_zone\_is\_internal | Set true in case the hosted zone is in an internal VPC, otherwise false | `string` | `"false"` | no |
| hostname\_create | Optional parameter to create or not a Route53 record | `bool` | `false` | no |
| hostname\_redirects | List of hostnames to redirect to the main one, comma-separated | `string` | `""` | no |
| hostnames | List of hostnames to create listerner rule and optionally, DNS records for this app | `list(string)` | `[]` | no |
| http\_header | Header to use on listerner rule with name e values | `list(any)` | `[]` | no |
| image | Docker image to deploy (can be a placeholder) | `string` | `""` | no |
| launch\_type | The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2. | `string` | `"EC2"` | no |
| log\_subscription\_filter\_destination\_arn | n/a | `string` | `""` | no |
| log\_subscription\_filter\_enabled | n/a | `bool` | `false` | no |
| log\_subscription\_filter\_filter\_pattern | n/a | `string` | `""` | no |
| log\_subscription\_filter\_role\_arn | n/a | `string` | `""` | no |
| memory | Hard memory of the container | `number` | `512` | no |
| name | Name of your ECS service | `any` | n/a | yes |
| network\_mode | The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. (REQUIRED IF 'LAUCH\_TYPE' IS FARGATE) | `string` | `"awsvpc"` | no |
| ordered\_placement\_strategy | Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. The maximum number of ordered\_placement\_strategy blocks is 5. | <pre>list(object({<br>    field = string<br>    type  = string<br>  }))</pre> | `[]` | no |
| paths | List of paths to use on listener rule (example: ['/\*']) | `list(string)` | `[]` | no |
| placement\_constraints | Rules that are taken into consideration during task placement. Maximum number of placement\_constraints is 10. | <pre>list(object({<br>    type       = string<br>    expression = string<br>  }))</pre> | `[]` | no |
| platform\_version | The platform version on which to run your service. Only applicable for launch\_type set to FARGATE. Defaults to LATEST. | `string` | `"LATEST"` | no |
| port | Port for target group to listen | `number` | `80` | no |
| protocol | Protocol to use (HTTP or HTTPS) | `string` | `"HTTP"` | no |
| readonlyrootfilesystem | Enable ready only access to root File ssystem. | `bool` | `false` | no |
| redirects | Map of path redirects to add to the listener | `map(string)` | `{}` | no |
| schedule\_cron\_start | Cron expression to define when to trigger a start of the auto-scaling group. E.g. 'cron(00 21 ? \* SUN-THU \*)' to start at 8am UTC time. | `string` | `""` | no |
| schedule\_cron\_stop | Cron expression to define when to trigger a stop of the auto-scaling group. E.g. 'cron(00 09 ? \* MON-FRI \*)' to start at 8am UTC time | `string` | `""` | no |
| security\_groups | The security groups associated with the task or service | `list(string)` | `[]` | no |
| service\_deployment\_maximum\_percent | Maximum percentage of tasks to run during deployments | `number` | `200` | no |
| service\_deployment\_minimum\_healthy\_percent | Minimum healthy percentage during deployments | `number` | `100` | no |
| service\_desired\_count | Desired count for this service (for use when auto scaling is disabled) | `number` | `1` | no |
| service\_health\_check\_grace\_period\_seconds | Time until your container starts serving requests | `number` | `0` | no |
| service\_role\_arn | Existing service role ARN created by ECS cluster module | `string` | `null` | no |
| source\_ips | List of source ip to use on listerner rule | `list(string)` | `[]` | no |
| ssm\_variables | Map of variables and SSM locations to add to the task definition | `map(string)` | `{}` | no |
| static\_variables | Map of variables and static values to add to the task definition | `map(string)` | `{}` | no |
| subnets | The subnets associated with the task or service. (REQUIRED IF 'LAUCH\_TYPE' IS FARGATE) | `list(string)` | `[]` | no |
| tags | Map of tags that will be added to created resources. By default resources will be tagged with terraform=true. | `map(string)` | `{}` | no |
| task\_definition\_arn | Task definition to use for this service (optional) | `string` | `""` | no |
| task\_role\_arn | Existing task role ARN created by ECS cluster module | `string` | `null` | no |
| task\_role\_policies | Custom policies to be added on the task role. | `list(any)` | `[]` | no |
| task\_role\_policies\_managed | AWS Managed policies to be added on the task role. | `list` | `[]` | no |
| ulimits | Container ulimit settings. This is a list of maps, where each map should contain "name", "hardLimit" and "softLimit" | <pre>list(object({<br>    name      = string<br>    hardLimit = number<br>    softLimit = number<br>  }))</pre> | `null` | no |
| unhealthy\_threshold | The number of consecutive health check failures required before considering the target unhealthy | `number` | `3` | no |
| vpc\_id | VPC ID to deploy this app to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws\_cloudwatch\_log\_group\_arn | n/a |

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-ecs-app/blob/master/LICENSE) for full details.
