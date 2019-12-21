# terraform-aws-ecs-app

AWS ECS Application Module

This module is designed to be used with `DNXLabs/terraform-aws-ecs`.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb_only | Whether to deploy only an alb and no cloudFront or not with the cluster | string | `"false"` | no |
| alb\_dns\_name | ALB DNS Name that CloudFront will point as origin | string | n/a | yes |
| alb\_listener\_https\_arn | ALB HTTPS Listener created by ECS cluster module | string | n/a | yes |
| autoscaling\_cpu | Enables autoscaling based on average CPU tracking | string | `"false"` | no |
| autoscaling\_max | Max number of containers to scale with autoscaling | string | `"4"` | no |
| autoscaling\_min | Min number of containers to scale with autoscaling | string | `"1"` | no |
| autoscaling\_scale\_in\_cooldown | Cooldown in seconds to wait between scale in events | string | `"300"` | no |
| autoscaling\_scale\_out\_cooldown | Cooldown in seconds to wait between scale out events | string | `"300"` | no |
| autoscaling\_target\_cpu | Target average CPU percentage to track for autoscaling | string | `"50"` | no |
| certificate\_arn | Certificate for this app to use in CloudFront (US), must cover `hostname` and (ideally) `hostname_blue` passed. | string | n/a | yes |
| cluster\_name |  | string | `"Name of existing ECS Cluster to deploy this app to"` | no |
| container\_port | Port your container listens (used in the placeholder task definition) | string | `"8080"` | no |
| cpu | Hard limit for CPU for the container | string | `"0"` | no |
| healthcheck\_path |  | string | `"/"` | no |
| hosted\_zone | Existing Hosted Zone domain to add hostnames as DNS records | string | n/a | yes |
| hostname | Hostname to create DNS record for this app | string | n/a | yes |
| hostname\_blue | Blue hostname for testing the app | string | n/a | yes |
| hostname\_create | Create hostname in the hosted zone passed? | string | `"true"` | no |
| hostname\_origin | A hostname covered by the ALB certificate for HTTPS traffic between CloudFront and ALB | string | n/a | yes |
| hostname\_redirects | List of hostnames to redirect to the main one, comma-separated | string | `""` | no |
| image | Docker image to deploy (can be a placeholder) | string | n/a | yes |
| memory | Hard memory of the container | string | `"512"` | no |
| name | Name of your ECS service | string | n/a | yes |
| port | Port for target group to listen | string | `"80"` | no |
| service\_role\_arn | Existing service role ARN created by ECS cluster module | string | n/a | yes |
| task\_role\_arn | Existing task role ARN created by ECS cluster module | string | n/a | yes |
| vpc\_id | VPC ID to deploy this app to | string | n/a | yes |
| codedeploy_wait_time_for_cutover | Time in minutes to route the traffic to the new application deployment | string | `"5"` | no |
| codedeploy_wait_time_for_termination | Time in minutes to terminate the new deployment | string | `"0"` | no |
 
## Authors

Module managed by [Allan Denot](https://github.com/adenot).

## License

Apache 2 Licensed. See LICENSE for full details.