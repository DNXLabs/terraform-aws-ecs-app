resource "aws_iam_role" "ecs_service" {
  count = var.service_role_arn != null ? 0 : 1
  name  = "ecs-service-${var.cluster_name}-${var.name}-${data.aws_region.current.name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = merge(
    var.tags,
    {
      "terraform" = "true"
    },
  )

}

data "aws_iam_policy_document" "ecs_service_policy" {
  count = var.service_role_arn != null ? 0 : 1
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress",
    ]
  }
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  count  = var.service_role_arn != null ? 0 : 1
  name   = "ecs_service_role_policy-${var.name}"
  policy = data.aws_iam_policy_document.ecs_service_policy[0].json
  role   = aws_iam_role.ecs_service[0].id
}
