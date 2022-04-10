module "azure" {
  source = "./azure"
  count  = var.cloud == "azure" ? 1 : 0

  // Common variables
  dns_enabled              = var.dns_enabled
  domain_name              = var.domain_name
  enable_airgapped         = var.enable_airgapped
  enable_external_database = var.enable_external_database
  enable_external_registry = var.enable_external_registry
  enable_external_storage  = var.enable_external_storage
  labels                   = local.labels
  name_format              = var.name_format
  name_format_global       = var.name_format_global
  workspace_name           = var.workspace_name

  // Azure-specific variables
  location = var.azure_location
}

variable "azure_location" {}
