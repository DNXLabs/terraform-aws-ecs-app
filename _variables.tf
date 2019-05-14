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
