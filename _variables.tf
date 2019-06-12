# == REQUIRED VARS

variable "name" {
  description = "Name of your ECS service"
}

variable "container_port" {
  default = "8080"
}

variable "port" {
  default = "80"
}

variable "memory" {
  default = "512"
}

variable "cpu" {
  default = "0"
}

variable "hostname" {}
variable "hostname_blue" {}
variable "hostname_origin" {}

variable "healthcheck_path" {
  default = "/"
}

variable "hosted_zone" {}

variable "cluster_name" {}

variable "service_role_arn" {}
variable "task_role_arn" {}

variable "image" {}

variable "vpc_id" {}

variable "alb_listener_https_arn" {}
variable "alb_dns_name" {}

variable "certificate_arn" {}

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
