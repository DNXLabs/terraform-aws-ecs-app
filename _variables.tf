# == REQUIRED VARS

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

variable "hostname" {
  description = "Hostname(s) to create DNS record for this app, comma-separated"
}

variable "hostname_blue" {
  description = "Blue hostname for testing the app"
}

variable "hostname_origin" {
  description = "A hostname covered by the ALB certificate for HTTPS traffic between CloudFront and ALB"
}

variable "healthcheck_path" {
  default = "/"
}

variable "hosted_zone" {
  description = "Existing Hosted Zone domain to add hostnames as DNS records"
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
  description = "ALB DNS Name that CloudFront will point as origin"
}

variable "certificate_arn" {
  description = "Certificate for this app to use in CloudFront (US), must cover `hostname` and (ideally) `hostname_blue` passed."
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
