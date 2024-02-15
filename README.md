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

Error: Argument or block definition required: An argument or block definition is required here. To set an argument, use the equals sign "=" to introduce the argument value.

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-ecs-app/blob/master/LICENSE) for full details.
