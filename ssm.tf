resource "aws_ssm_parameter" "secure_string" {
  for_each    = toset(var.ssm_parameters_secure_strings)
  name        = "/ecs/${var.cluster_name}/${var.name}/${each.key}"
  description = each.value
  type        = "SecureString"
  value       = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "string" {
  for_each    = var.ssm_parameters_strings
  name        = "/ecs/${var.cluster_name}/${var.name}/${each.key}"
  description = each.key
  type        = "String"
  value       = each.value

  lifecycle {
    ignore_changes = [value]
  }
}