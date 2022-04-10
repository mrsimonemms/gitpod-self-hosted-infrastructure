module "infrastructure" {
  source = "./infrastructure"

  // Common variables
  cloud                    = var.cloud
  dns_enabled              = local.dns_enabled
  domain_name              = var.domain_name
  enable_airgapped         = var.enable_airgapped
  enable_external_database = var.enable_external_database
  enable_external_registry = var.enable_external_registry
  enable_external_storage  = var.enable_external_storage
  name_format              = local.name_format
  name_format_global       = local.name_format_global
  workspace_name           = terraform.workspace

  // Cloud-specific variables
  azure_location = var.azure_location
}
