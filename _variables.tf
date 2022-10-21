variable "name" {
  description = "Name of your ECS service"
}

variable "container_port" {
  default     = 8080
  description = "Port your container listens (used in the placeholder task definition)"
}

variable "port" {
  default     = 80
  description = "Port for target group to listen"
}

variable "protocol" {
  default     = "HTTP"
  description = "Protocol to use (HTTP or HTTPS)"
}

variable "memory" {
  default     = 512
  description = "Hard memory of the container"
}

variable "cpu" {
  default     = 0
  description = "Hard limit for CPU for the container"
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
  default     = "false"
  description = "Optional parameter to create or not a Route53 record"
}

variable "hostnames" {
  default     = []
  description = "List of hostnames to create listerner rule and optionally, DNS records for this app"
}

variable "source_ips" {
  default     = []
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
}


variable "healthcheck_path" {
  default = "/"
}

variable "healthcheck_interval" {
  default = "10"
}

variable "cluster_name" {
  default = "Name of existing ECS Cluster to deploy this app to"
}

variable "service_role_arn" {
  description = "Existing service role ARN created by ECS cluster module"
}

variable "codedeploy_role_arn" {
  default     = null
  description = "Existing IAM CodeDeploy role ARN created by ECS cluster module"
}

variable "task_role_arn" {
  description = "Existing task role ARN created by ECS cluster module"
}

variable "service_health_check_grace_period_seconds" {
  default     = 0
  description = "Time until your container starts serving requests"
}

variable "service_deployment_maximum_percent" {
  default     = 200
  description = "Maximum percentage of tasks to run during deployments"
}

variable "service_desired_count" {
  default     = 1
  description = "Desired count for this service (for use when auto scaling is disabled)"
}

variable "service_deployment_minimum_healthy_percent" {
  default     = 100
  description = "Minimum healthy percentage during deployments"
}

variable "image" {
  description = "Docker image to deploy (can be a placeholder)"
  default     = ""
}

variable "task_definition_arn" {
  description = "Task definition to use for this service (optional)"
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID to deploy this app to"
}

variable "alb_listener_https_arn" {
  description = "ALB HTTPS Listener created by ECS cluster module"
}

variable "test_traffic_route_listener_arn" {
  description = "ALB HTTPS Listener for Test Traffic created by ECS cluster module"
}

variable "alb_dns_name" {
  description = "ALB DNS Name"
  default     = ""
}

variable "alb_name" {
  description = "ALB name - Required if it is an internal one"
  default     = ""
}

variable "alb_priority" {
  default     = 0
  description = "priority rules ALB (leave 0 to let terraform calculate)"
}

variable "autoscaling_cpu" {
  default     = false
  description = "Enables autoscaling based on average CPU tracking"
}

variable "autoscaling_memory" {
  default     = false
  description = "Enables autoscaling based on average Memory tracking"
}

variable "autoscaling_max" {
  default     = 4
  description = "Max number of containers to scale with autoscaling"
}

variable "autoscaling_min" {
  default     = 1
  description = "Min number of containers to scale with autoscaling"
}

variable "autoscaling_target_cpu" {
  default     = 50
  description = "Target average CPU percentage to track for autoscaling"
}

variable "autoscaling_target_memory" {
  default     = 90
  description = "Target average Memory percentage to track for autoscaling"
}

variable "autoscaling_scale_in_cooldown" {
  default     = 300
  description = "Cooldown in seconds to wait between scale in events"
}

variable "autoscaling_scale_out_cooldown" {
  default     = 300
  description = "Cooldown in seconds to wait between scale out events"
}

variable "alarm_min_healthy_tasks" {
  default     = 2
  description = "Alarm when the number of healthy tasks is less than this number (use 0 to disable this alarm)"
}

variable "alarm_high_cpu_usage_above" {
  default     = 80
  description = "Alarm when CPU is above a certain value (use 0 to disable this alarm)"
}

variable "alarm_evaluation_periods" {
  default     = "2"
  description = "The number of minutes the alarm must be below the threshold before entering the alarm state."
}

variable "alarm_sns_topics" {
  default     = []
  description = "Alarm topics to create and alert on ECS service metrics. Leaving empty disables all alarms."
}

variable "healthy_threshold" {
  default     = 3
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
}

variable "unhealthy_threshold" {
  default     = 3
  description = "The number of consecutive health check failures required before considering the target unhealthy"
}

variable "healthcheck_timeout" {
  default     = 5
  description = "The amount of time, in seconds, during which no response"
}

variable "healthcheck_matcher" {
  default     = 200
  description = "The HTTP codes to use when checking for a successful response from a target"
}

variable "alb_only" {
  default     = false
  description = "Whether to deploy only an alb and no cloudFront or not with the cluster"
}

variable "codedeploy_wait_time_for_cutover" {
  default     = 0
  description = "Time in minutes to route the traffic to the new application deployment"
}

variable "codedeploy_wait_time_for_termination" {
  default     = 0
  description = "Time in minutes to terminate the new deployment"
}

variable "codedeploy_deployment_config_name" {
  default     = "CodeDeployDefault.ECSAllAtOnce"
  description = "Specifies the deployment configuration for CodeDeploy"
}

variable "cloudwatch_logs_retention" {
  default     = 120
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653."
}

variable "cloudwatch_logs_export" {
  default     = false
  description = "Whether to mark the log group to export to an S3 bucket (needs terraform-aws-log-exporter to be deployed in the account/region)"
}

variable "compat_keep_target_group_naming" {
  default     = false
  description = "Keeps old naming convention for target groups to avoid recreation of resource in production environments"
}

variable "launch_type" {
  default     = "EC2"
  description = "The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2."
}

variable "fargate_spot" {
  default     = false
  description = "Set true to use FARGATE_SPOT capacity provider by default (only when launch_type=FARGATE)"
}

variable "platform_version" {
  default     = "LATEST"
  description = "The platform version on which to run your service. Only applicable for launch_type set to FARGATE. Defaults to LATEST."
}

variable "subnets" {
  default     = null
  description = "The subnets associated with the task or service. (REQUIRED IF 'LAUCH_TYPE' IS FARGATE)"
}

variable "network_mode" {
  default     = null
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. (REQUIRED IF 'LAUCH_TYPE' IS FARGATE)"
}

variable "security_groups" {
  default     = null
  description = "The security groups associated with the task or service"
}

variable "log_subscription_filter_enabled" {
  type    = string
  default = false
}

variable "log_subscription_filter_role_arn" {
  type    = string
  default = ""
}

variable "log_subscription_filter_destination_arn" {
  type    = string
  default = ""
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

variable "create_iam_codedeployrole" {
  type        = bool
  default     = true
  description = "Create Codedeploy IAM Role for ECS or not."
}

variable "alarm_prefix" {
  type        = string
  description = "String prefix for cloudwatch alarms. (Optional)"
  default     = "alarm"
}

variable "efs_mapping" {
  type        = map(string)
  description = "A map of efs volume ids and paths to mount into the default task definition"
  default     = {}
}

variable "ssm_variables" {
  type        = map(string)
  description = "Map of variables and SSM locations to add to the task definition"
  default     = {}
}

variable "static_variables" {
  type        = map(string)
  description = "Map of variables and static values to add to the task definition"
  default     = {}
}

variable "auth_oidc_enabled" {
  type        = bool
  default     = false
  description = "Enables OIDC-authenticated listener rule"
}

variable "auth_oidc_paths" {
  type        = list(string)
  default     = []
  description = "List of paths to use as a condition to authenticate (example: ['/admin*'])"
}

variable "auth_oidc_hostnames" {
  type        = list(string)
  default     = []
  description = "List of hostnames to use as a condition to authenticate with OIDC"
}

variable "auth_oidc_authorization_endpoint" {
  type        = string
  default     = ""
  description = "Authorization endpoint for OIDC (Google: https://accounts.google.com/o/oauth2/v2/auth)"
}

variable "auth_oidc_client_id" {
  type        = string
  default     = ""
  description = "Client ID for OIDC authentication"
}

variable "auth_oidc_client_secret" {
  type        = string
  default     = ""
  description = "Client Secret for OIDC authentication"
}

variable "auth_oidc_issuer" {
  type        = string
  default     = ""
  description = "Issuer URL for OIDC authentication (Google: https://accounts.google.com)"
}

variable "auth_oidc_token_endpoint" {
  type        = string
  default     = ""
  description = "Token Endpoint URL for OIDC authentication (Google: https://oauth2.googleapis.com/token)"
}

variable "auth_oidc_user_info_endpoint" {
  type        = string
  default     = ""
  description = "User Info Endpoint URL for OIDC authentication (Google: https://openidconnect.googleapis.com/v1/userinfo)"
}

variable "auth_oidc_session_timeout" {
  type        = number
  default     = 43200
  description = "Session timeout for OIDC authentication (default 12 hours)"
}

variable "ulimits" {
  type = list(object({
    name      = string
    hardLimit = number
    softLimit = number
  }))
  description = "Container ulimit settings. This is a list of maps, where each map should contain \"name\", \"hardLimit\" and \"softLimit\""
  default     = null
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
}

variable "deployment_controller" {
  default     = "CODE_DEPLOY"
  description = "Type of deployment controller. Valid values: CODE_DEPLOY, ECS, EXTERNAL."
}

variable "ecs_service_capacity_provider_strategy" {
  description = "(Optional) The capacity provider strategy to use for the service. Can be one or more. These can be updated without destroying and recreating the service only if set to [] and not changing from 0 capacity_provider_strategy blocks to greater than 0, or vice versa."
  default     = [{}]
}
