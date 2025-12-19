locals {
  target_group_types = try(var.enable_internal_loadbalancer, false) ? ["external","internal"] : ["external"]
}

locals {
  selected_paths = {
    for t in local.target_group_types : t => (
      t == "internal" ? (length(var.internal_paths) > 0 ? var.internal_paths : var.paths) : (length(var.paths) > 0 ? var.paths : [])
    )
  }

  selected_hostnames = {
    for t in local.target_group_types : t => (
      t == "internal" ? (length(var.internal_hostnames) > 0 ? var.internal_hostnames : var.hostnames) : (length(var.hostnames) > 0 ? var.hostnames : [])
    )
  }
}
