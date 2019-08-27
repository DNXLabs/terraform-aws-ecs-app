resource "aws_iam_role" "codedeploy_service" {
  # name = "codedeploy-service-${var.name}"
  name = format("codedeploy-service-${var.name}%s", var.env)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codedeploy_service" {
  role       = "${aws_iam_role.codedeploy_service.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}
