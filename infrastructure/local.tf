locals {
  cloud = var.cloud == "azure" ? module.azure[0] : null
  labels = tomap({
    workload_meta : "gitpod.io/workload_meta"
    workload_ide : "gitpod.io/workload_ide"
    workspace_services : "gitpod.io/workload_workspace_services"
    workspace_regular : "gitpod.io/workload_workspace_regular"
    workspace_headless : "gitpod.io/workload_workspace_headless"
  })
}
