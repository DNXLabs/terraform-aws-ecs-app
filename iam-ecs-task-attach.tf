# Attach AWS managed policies to the role
resource "aws_iam_role_policy_attachment" "task_role_attach_policy_managed" {
  for_each   = { for role in try(var.task_role_policies_managed, []) : role.name => role }
  role       = aws_iam_role.ecs_task[0].name
  policy_arn = each.value.policy_arn
}

data "aws_iam_policy_document" "task_role_policy_custom" {
  for_each = { for policy in try(var.task_role_policies, []) : policy.name => policy }

  dynamic "statement" {
    for_each = try(each.value.statement, [])
    content {
      sid       = statement.value.sid
      actions   = statement.value.actions
      resources = statement.value.resources
      effect    = statement.value.effect

      dynamic "condition" {
        for_each = try(statement.value.condition, [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "task_role_policy_custom" {
  for_each    = { for policy in try(var.task_role_policies, []) : policy.name => policy }
  name        = "ecs-${each.value.name}-${var.cluster_name}-${var.name}-${data.aws_region.current.name}"
  description = try(each.value.description, "")
  policy      = data.aws_iam_policy_document.task_role_policy_custom[each.value.name].json

  tags = merge(var.tags, { "terraform" = "true" }, )
}

resource "aws_iam_role_policy_attachment" "task_role_attach_policy_custom" {
  for_each   = { for policy in try(var.task_role_policies, []) : policy.name => policy }
  role       = aws_iam_role.ecs_task[0].name
  policy_arn = aws_iam_policy.task_role_policy_custom[each.value.name].arn
}
