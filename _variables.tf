variable "name" {
  description = "Name of your ECS service"
}

variable "container_port" {
  default     = 8080
  description = "Port your container listens (used in the placeholder task definition)"
  type        = number
}

variable "port" {
  default     = 80
  description = "Port for target group to listen"
  type        = number
}

variable "protocol" {
  default     = "HTTP"
  description = "Protocol to use (HTTP or HTTPS)"
  type        = string
}

variable "memory" {
  default     = 512
  description = "Hard memory of the container"
  type        = number
}

variable "cpu" {
  default     = 0
  description = "Hard limit for CPU for the container"
  type        = number
}

variable "paths" {
  default     = []
  description = "List of paths to use on listener rule (example: ['/*'])"
  type        = list(string)
}

variable "hosted_zone_is_internal" {
  default     = "false"
  description = "Set true in case the hosted zone is in an internal VPC, otherwise false"
}

variable "hosted_zone" {
  default     = ""
  description = "Hosted Zone to create DNS record for this app"
}

variable "hosted_zone_id" {
  default     = ""
  description = "Hosted Zone ID to create DNS record for this app (use this to avoid data lookup when using `hosted_zone`)"
}

variable "hostname_create" {
  default     = false
  description = "Optional parameter to create or not a Route53 record"
  type        = bool
}

variable "hostnames" {
  default     = []
  type        = list(string)
  description = "List of hostnames to create listerner rule and optionally, DNS records for this app"
}

variable "source_ips" {
  default     = []
  type        = list(string)
  description = "List of source ip to use on listerner rule"
}

variable "http_header" {
  default     = []
  description = "Header to use on listerner rule with name e values"
  type        = list(any)
}

variable "hostname_redirects" {
  description = "List of hostnames to redirect to the main one, comma-separated"
  default     = ""
  type        = string
}


variable "healthcheck_path" {
  default = "/"
  type    = string
}

variable "healthcheck_interval" {
  default = 10
  type    = number
}

variable "cluster_name" {
  default = "Name of existing ECS Cluster to deploy this app to"
  type    = string
}

variable "cluster_arn" {
  default = "ARN of existing ECS Cluster to deploy this app to"
  type    = string
}

variable "service_role_arn" {
  description = "Existing service role ARN created by ECS cluster module"
  default     = null
  type        = string
}

variable "task_role_arn" {
  description = "Existing task role ARN created by ECS cluster module"
  default     = null
  type        = string
}

variable "service_health_check_grace_period_seconds" {
  default     = 0
  description = "Time until your container starts serving requests"
  type        = number
}

variable "service_deployment_maximum_percent" {
  default     = 200
  description = "Maximum percentage of tasks to run during deployments"
  type        = number
}

variable "service_desired_count" {
  default     = 1
  description = "Desired count for this service (for use when auto scaling is disabled)"
  type        = number
}

variable "service_deployment_minimum_healthy_percent" {
  default     = 100
  description = "Minimum healthy percentage during deployments"
  type        = number
}

variable "image" {
  description = "Docker image to deploy (can be a placeholder)"
  default     = ""
  type        = string
}

variable "task_definition_arn" {
  description = "Task definition to use for this service (optional)"
  default     = ""
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to deploy this app to"
  type        = string
}

variable "alb_listener_https_arn" {
  description = "ALB HTTPS Listener created by ECS cluster module"
  type        = string
}

variable "alb_arn" {
  description = "ALB ARN created by ECS cluster module"
  type        = string
}

variable "alb_dns_name" {
  description = "ALB DNS Name"
  default     = ""
  type        = string
}

variable "alb_name" {
  description = "ALB name - Required if it is an internal one"
  default     = ""
  type        = string
}

variable "alb_priority" {
  default     = 0
  description = "priority rules ALB (leave 0 to let terraform calculate)"
  type        = number
}

variable "autoscaling_cpu" {
  default     = false
  description = "Enables autoscaling based on average CPU tracking"
  type        = bool
}

variable "autoscaling_memory" {
  default     = false
  description = "Enables autoscaling based on average Memory tracking"
}

variable "autoscaling_max" {
  default     = 4
  description = "Max number of containers to scale with autoscaling"
  type        = number
}

variable "autoscaling_min" {
  default     = 1
  description = "Min number of containers to scale with autoscaling"
  type        = number
}

variable "autoscaling_target_cpu" {
  default     = 50
  description = "Target average CPU percentage to track for autoscaling"
  type        = number
}

variable "autoscaling_target_memory" {
  default     = 90
  description = "Target average Memory percentage to track for autoscaling"
  type        = number
}

variable "autoscaling_scale_in_cooldown" {
  default     = 300
  description = "Cooldown in seconds to wait between scale in events"
  type        = number
}

variable "autoscaling_scale_out_cooldown" {
  default     = 300
  description = "Cooldown in seconds to wait between scale out events"
  type        = number
}

variable "alarm_min_healthy_tasks" {
  default     = 2
  description = "Alarm when the number of healthy tasks is less than this number (use 0 to disable this alarm)"
  type        = number
}

variable "alarm_high_cpu_usage_above" {
  default     = 80
  description = "Alarm when CPU is above a certain value (use 0 to disable this alarm)"
  type        = number
}

variable "alarm_evaluation_periods" {
  default     = 2
  description = "The number of minutes the alarm must be below the threshold before entering the alarm state."
  type        = number

}

variable "alarm_sns_topics" {
  default     = []
  description = "Alarm topics to create and alert on ECS service metrics. Leaving empty disables all alarms."
  type        = list(string)
}

variable "healthy_threshold" {
  default     = 3
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
  type        = number
}

variable "unhealthy_threshold" {
  default     = 3
  description = "The number of consecutive health check failures required before considering the target unhealthy"
  type        = number
}

variable "healthcheck_timeout" {
  default     = 5
  description = "The amount of time, in seconds, during which no response"
  type        = number
}

variable "healthcheck_matcher" {
  default     = 200
  description = "The HTTP codes to use when checking for a successful response from a target"
  type        = number
}

variable "alb_only" {
  default     = false
  description = "Whether to deploy only an alb and no cloudFront or not with the cluster"
  type        = bool
}

variable "cloudwatch_logs_create" {
  default     = true
  description = "Whether to create cloudwatch log resources or not"
  type        = bool
}

variable "cloudwatch_logs_retention" {
  default     = 120
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653."
  type        = number
}

variable "cloudwatch_logs_export" {
  default     = false
  description = "Whether to mark the log group to export to an S3 bucket (needs terraform-aws-log-exporter to be deployed in the account/region)"
  type        = bool
}

variable "compat_keep_target_group_naming" {
  default     = false
  description = "Keeps old naming convention for target groups to avoid recreation of resource in production environments"
  type        = bool
}


variable "tags" {
  description = "Map of tags that will be added to created resources. By default resources will be tagged with terraform=true."
  type        = map(string)
  default     = {}
}

variable "launch_type" {
  default     = "EC2"
  description = "The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2."
  type        = string
}

variable "fargate_spot" {
  default     = false
  description = "Set true to use FARGATE_SPOT capacity provider by default (only when launch_type=FARGATE)"
  type        = bool
}

variable "platform_version" {
  default     = "LATEST"
  description = "The platform version on which to run your service. Only applicable for launch_type set to FARGATE. Defaults to LATEST."
  type        = string
}

variable "subnets" {
  default     = []
  description = "The subnets associated with the task or service. (REQUIRED IF 'LAUCH_TYPE' IS FARGATE)"
  type        = list(string)
}

variable "network_mode" {
  default     = "awsvpc"
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. (REQUIRED IF 'LAUCH_TYPE' IS FARGATE)"
  type        = string
}

variable "security_groups" {
  default     = []
  description = "The security groups associated with the task or service"
  type        = list(string)
}

variable "log_subscription_filter_enabled" {
  default = false
  type    = bool
}

variable "log_subscription_filter_role_arn" {
  default = ""
  type    = string
}

variable "log_subscription_filter_destination_arn" {
  default = ""
  type    = string
}

variable "log_subscription_filter_filter_pattern" {
  default = ""
  type    = string
}

variable "ordered_placement_strategy" {
  # This variable may not be used with Fargate!
  description = "Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. The maximum number of ordered_placement_strategy blocks is 5."
  type = list(object({
    field = string
    type  = string
  }))
  default = []
}

variable "placement_constraints" {
  # This variables may not be used with Fargate!
  description = "Rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10."
  type = list(object({
    type       = string
    expression = string
  }))
  default = []
}

variable "alarm_prefix" {
  description = "String prefix for cloudwatch alarms. (Optional)"
  default     = "alarm"
  type        = string
}

variable "efs_mapping" {
  description = "A map of efs volume ids and paths to mount into the default task definition"
  default     = {}
  type        = map(string)
}

variable "ssm_variables" {
  description = "Map of variables and SSM locations to add to the task definition"
  default     = {}
  type        = map(string)
}

variable "static_variables" {
  description = "Map of variables and static values to add to the task definition"
  default     = {}
  type        = map(string)
}

variable "auth_oidc_enabled" {
  default     = false
  description = "Enables OIDC-authenticated listener rule"
  type        = bool
}

variable "auth_oidc_paths" {
  default     = []
  description = "List of paths to use as a condition to authenticate (example: ['/admin*'])"
  type        = list(string)
}

variable "auth_oidc_hostnames" {
  default     = []
  description = "List of hostnames to use as a condition to authenticate with OIDC"
  type        = list(string)
}

variable "auth_oidc_authorization_endpoint" {
  default     = ""
  description = "Authorization endpoint for OIDC (Google: https://accounts.google.com/o/oauth2/v2/auth)"
  type        = string
}

variable "auth_oidc_client_id" {
  default     = ""
  description = "Client ID for OIDC authentication"
  type        = string
}

variable "auth_oidc_client_secret" {
  default     = ""
  description = "Client Secret for OIDC authentication"
  type        = string
}

variable "auth_oidc_issuer" {
  default     = ""
  description = "Issuer URL for OIDC authentication (Google: https://accounts.google.com)"
  type        = string
}

variable "auth_oidc_token_endpoint" {
  default     = ""
  description = "Token Endpoint URL for OIDC authentication (Google: https://oauth2.googleapis.com/token)"
  type        = string
}

variable "auth_oidc_user_info_endpoint" {
  default     = ""
  description = "User Info Endpoint URL for OIDC authentication (Google: https://openidconnect.googleapis.com/v1/userinfo)"
  type        = string
}

variable "auth_oidc_session_timeout" {
  default     = 43200
  description = "Session timeout for OIDC authentication (default 12 hours)"
  type        = number
}

variable "ulimits" {
  description = "Container ulimit settings. This is a list of maps, where each map should contain \"name\", \"hardLimit\" and \"softLimit\""
  default     = null
  type = list(object({
    name      = string
    hardLimit = number
    softLimit = number
  }))
}

variable "autoscaling_custom" {
  type = list(object({
    name               = string
    scale_in_cooldown  = number
    scale_out_cooldown = number
    target_value       = number
    metric_name        = string
    namespace          = string
    statistic          = string
  }))
  default     = []
  description = "Set one or more app autoscaling by customized metric"
}

variable "dynamic_stickiness" {
  type        = any
  default     = []
  description = "Target Group stickiness. Used in dynamic block."
}

variable "redirects" {
  description = "Map of path redirects to add to the listener"
  default     = {}
  type        = map(string)
}

variable "ecs_service_capacity_provider_strategy" {
  description = "(Optional) The capacity provider strategy to use for the service. Can be one or more. These can be updated without destroying and recreating the service only if set to [] and not changing from 0 capacity_provider_strategy blocks to greater than 0, or vice versa."
  default     = [{}]
}

variable "alarm_ecs_running_tasks_threshold" {
  type        = number
  default     = 0
  description = "Alarm when the number of ecs service running tasks is lower than a certain value. CloudWatch Container Insights must be enabled for the cluster."
}

variable "enable_schedule" {
  default     = false
  description = "Enables schedule to shut down and start up instances outside business hours."
  type        = bool
}

variable "schedule_cron_start" {
  default     = ""
  description = "Cron expression to define when to trigger a start of the auto-scaling group. E.g. 'cron(00 21 ? * SUN-THU *)' to start at 8am UTC time."
  type        = string
}

variable "schedule_cron_stop" {
  default     = ""
  description = "Cron expression to define when to trigger a stop of the auto-scaling group. E.g. 'cron(00 09 ? * MON-FRI *)' to start at 8am UTC time"
  type        = string
}

variable "command" {
  default     = null
  description = "Command to run on container"
  type        = list(string)
}

variable "task_role_policies_managed" {
  default     = []
  description = "AWS Managed policies to be added on the task role."
}

variable "task_role_policies" {
  default     = []
  description = "Custom policies to be added on the task role."
  type        = list(any)
}

variable "readonlyrootfilesystem" {
  default     = false
  description = "Enable ready only access to root File ssystem."
  type        = bool
}

variable "alb_custom_rules" {
  type = list(object({
    name        = optional(string)
    paths       = optional(list(string), [])
    hostnames   = optional(list(string), [])
    source_ips  = optional(list(string), [])
    http_header = optional(list(string), [])
    priority    = optional(number)
  }))
  default     = []
  description = "Custom loadbalance listener rule to be added with this application target group"
}
