locals {
  dns_enabled = var.domain_name != null
  name_format = join("-", [
    "gitpod",
    "%s", # region
    "%s", # name
    local.workspace_name
  ])
  name_format_global = join("-", [
    "gitpod",
    "%s", # name
    local.workspace_name
  ])
  workspace_name = replace(terraform.workspace, "/[\\W\\-]/", "") # alphanumeric workspace name
}
