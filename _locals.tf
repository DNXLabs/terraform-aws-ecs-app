locals {
  target_group_types = try(var.enable_internal_loadbalancer, false) ? ["external","internal"] : ["external"]
}
