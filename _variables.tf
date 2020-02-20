variable "name" {
  description = "Name of your ECS service"
}

variable "container_port" {
  default     = "8080"
  description = "Port your container listens (used in the placeholder task definition)"
}

variable "port" {
  default     = "80"
  description = "Port for target group to listen"
}

variable "memory" {
  default     = "512"
  description = "Hard memory of the container"
}

variable "cpu" {
  default     = "0"
  description = "Hard limit for CPU for the container"
}

variable "path" {
  default = "/*"
  description = "Optional path to use on listener rule"
}

variable "hosted_zone" {
  default     = ""
  description = "Hosted Zone to create DNS record for this app"
}
variable "hostname_create" {
  default     = "false"
  description = "Optional parameter to create or not a Route53 record"
}

variable "hostname" {
  description = "Hostname to create DNS record for this app"
}

variable "hostname_blue" {
  description = "Blue hostname for testing the app"
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

variable "task_role_arn" {
  description = "Existing task role ARN created by ECS cluster module"
}

variable "service_health_check_grace_period_seconds" {
  default     = 0
  description = "Time until your container starts serving requests"
}

variable "image" {
  description = "Docker image to deploy (can be a placeholder)"
}

variable "vpc_id" {
  description = "VPC ID to deploy this app to"
}

variable "alb_listener_https_arn" {
  description = "ALB HTTPS Listener created by ECS cluster module"
}
variable "alb_dns_name" {
 description = "ALB DNS Name"
 default= ""
}


variable "alb_priority" {
  default = 0
  description = "priority rules ALB"
}

variable "autoscaling_cpu" {
  default     = false
  description = "Enables autoscaling based on average CPU tracking"
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

variable "autoscaling_scale_in_cooldown" {
  default     = 300
  description = "Cooldown in seconds to wait between scale in events"
}

variable "autoscaling_scale_out_cooldown" {
  default     = 300
  description = "Cooldown in seconds to wait between scale out events"
}

variable "alarm_sns_topics" {
  default = []
  description = "Alarm topics to create and alert on ECS service metrics"
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
 
