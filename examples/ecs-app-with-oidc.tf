module "ecs_app_my_app" {
  source = "git::https://github.com/DNXLabs/terraform-aws-ecs-app.git?ref=5.5.0" # check for latest version

  name           = "my-app"
  image          = "dnxsolutions/nginx-hello:latest"
  container_port = 80
  cpu            = 512
  memory         = 2048

  vpc_id                           = "vpc-0000000"
  cluster_name                     = "dev-apps"
  service_role_arn                 = module.ecs_apps.ecs_service_iam_role_arn                  # from https://github.com/DNXLabs/terraform-aws-ecs
  task_role_arn                    = module.ecs_apps.ecs_task_iam_role_arn                     # from https://github.com/DNXLabs/terraform-aws-ecs
  alb_listener_https_arn           = element(module.ecs_apps.alb_listener_https_arn, 0)        # from https://github.com/DNXLabs/terraform-aws-ecs
  test_traffic_route_listener_arn  = element(module.ecs_apps.alb_listener_test_traffic_arn, 0) # from https://github.com/DNXLabs/terraform-aws-ecs
  codedeploy_wait_time_for_cutover = 1440

  hostnames          = ["my-app.dev.dnx.one"]
  hostname_redirects = ["www.my-app.dev.dnx.one"]
  hostname_create    = true
  alb_only           = true                                     # cluster also need this option to disable ALB WAF
  alb_dns_name       = element(module.ecs_apps.alb_dns_name, 0) # from # https://github.com/DNXLabs/terraform-aws-ecs
  hosted_zone        = "dev.dnx.one"
  paths              = ["/*"]

  healthcheck_path                          = "/"
  service_health_check_grace_period_seconds = 300

  autoscaling_cpu = true
  autoscaling_min = 2
  autoscaling_max = 6

  alarm_sns_topics       = []
  cloudwatch_logs_export = false

  launch_type     = "FARGATE"
  fargate_spot    = true
  network_mode    = "awsvpc"
  security_groups = [module.ecs_apps.ecs_nodes_secgrp_id] #  # from # https://github.com/DNXLabs/terraform-aws-ecs
  subnets         = ["subnet-00000", "subnet-00001"]

  auth_oidc_enabled                = true
  auth_oidc_paths                  = ["/admin*", "/wp-admin*"]
  auth_oidc_hostnames              = []
  auth_oidc_authorization_endpoint = "https://accounts.google.com/o/oauth2/v2/auth"
  auth_oidc_client_id              = "client_id"
  auth_oidc_client_secret          = "client_secret"
  auth_oidc_issuer                 = "https://accounts.google.com"
  auth_oidc_token_endpoint         = "https://oauth2.googleapis.com/token"
  auth_oidc_user_info_endpoint     = "https://openidconnect.googleapis.com/v1/userinfo"
  auth_oidc_session_timeout        = 43200 # 12 hours
}

module "ecs_apps" {
  source = "git::https://github.com/DNXLabs/terraform-aws-ecs.git?ref=5.6.0" # check for latest version

  name         = "dev-apps"
  fargate_only = true

  vpc_id             = data.aws_vpc.selected.id
  private_subnet_ids = data.aws_subnet_ids.private.ids
  public_subnet_ids  = data.aws_subnet_ids.public.ids
  secure_subnet_ids  = data.aws_subnet_ids.secure.ids
  certificate_arn    = "<enter ACM certificate arn>"

  alarm_sns_topics                    = []
  alarm_alb_latency_anomaly_threshold = 0
  alarm_prefix                        = "nonprod"

  alb                                     = true
  alb_only                                = true # for applications without cloudfront
  alb_ssl_policy                          = "ELBSecurityPolicy-TLS-1-2-2017-01"
  alb_sg_allow_egress_https_world         = true
  security_group_ecs_nodes_outbound_cidrs = ["0.0.0.0/0"]
  lb_access_logs_bucket                   = "" # <bucket_name>.s3.amazonaws.com
  lb_access_logs_prefix                   = ""
  backup                                  = true
  kms_key_arn                             = ""
  create_efs                              = true

  wafv2_enable                    = true
  wafv2_managed_rule_groups       = []
  wafv2_managed_block_rule_groups = []
  wafv2_rate_limit_rule           = 1000
}