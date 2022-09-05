locals {
  db = "db-n1-standard-2"
  nodes = [
    {
      disk_size_gb   = 512
      machine        = "n2d-standard-8"
      name           = "workspaces"
      min_node_count = 1
      max_node_count = 10
      labels = {
        lookup(var.labels, "workspace_services") = true
        lookup(var.labels, "workspace_regular")  = true
        lookup(var.labels, "workspace_headless") = true
      }
    },
    {
      disk_size_gb   = 100
      machine        = "n2d-standard-4"
      name           = "services"
      min_node_count = 1
      max_node_count = 10
      labels = {
        lookup(var.labels, "workload_meta") = true
        lookup(var.labels, "workload_ide")  = true
      }
    }
  ]
  region = replace(var.region, "/(^|-)([a-z])([a-z]+)/", "$2") # Short code for region
}
