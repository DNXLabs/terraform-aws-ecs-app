# resource "null_resource" "deployment" {
#   triggers {
#     image = var.image
#   }
#   provisioner "local-exec" {
#     command = <<EOF
# aws deploy create-deployment --application-name ${aws_codedeploy_app.ecs.name} \
#   --deployment-config-name CodeDeployDefault.ECSAllAtOnce \
#   --deployment-group-name ${var.name} --description DeploymentFromTerraform \
#   --revision file://${local_file.app_spec.filename} > ${path.module}/deploy-id.json
# EOF
#   }
# }
# data "template_file" "app_spec" {
#   template = file("${path.module}/app-spec.tpl.json")
#   vars = {
#     task_definition_arn = aws_ecs_task_definition.default.arn
#     container_name      = var.name
#     container_port      = var.container_port
#   }
# }

