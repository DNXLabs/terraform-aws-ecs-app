resource "aws_lb_listener_rule" "custom" {

  for_each = { for rule in try(var.alb_custom_rules, []) : rule.name => rule }


  tags         = merge({ "Name" = each.value.name }, var.tags, { "Terraform" = true })
  listener_arn = var.alb_listener_https_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }

  dynamic "condition" {
    for_each = try(length(each.value.paths), 0) > 0 ? [each.value.paths] : []
    content {
      path_pattern { values = toset(condition.value) }
    }
  }

  dynamic "condition" {
    for_each = try(length(each.value.hostnames), 0) > 0 ? [each.value.hostnames] : []
    content {
      host_header { values = toset(condition.value) }
    }
  }

  dynamic "condition" {
    for_each = try(length(each.value.source_ips), 0) > 0 ? [each.value.source_ips] : []
    content {
      source_ip { values = toset(condition.value) }
    }
  }

  dynamic "condition" {
    for_each = try(each.value.http_header, [])
    content {
      http_header {
        http_header_name = condition.value.name
        values           = condition.value.values
      }
    }
  }

  lifecycle {
    ignore_changes       = [action[0].target_group_arn]
    replace_triggered_by = [aws_lb_target_group.green]
  }

  priority = try(
    aws_lb_listener_rule.path_redirects[length(aws_lb_listener_rule.path_redirects) - 1].priority + 1,
    try(
      aws_lb_listener_rule.green_auth_oidc[0].priority + 1, each.value.priority != 0 ? each.value.priority : null
    )
  )


}
