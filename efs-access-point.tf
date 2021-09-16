resource "aws_efs_access_point" "default" {
  for_each       = var.efs_mapping
  file_system_id = each.key
  root_directory {
    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = 755
    }
    path = "/${var.name}"
  }
}
