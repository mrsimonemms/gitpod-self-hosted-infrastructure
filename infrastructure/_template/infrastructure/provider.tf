// Provider
//
// Replace any use of the word "provider" with the name
// of the cloud provider - eg, "provider" becomes "azure"

module "provider" {
  source = "./provider"
  count  = var.cloud == "provider" ? 1 : 0

  // Common variables
  // These may not be used inside the provider, but should be declared
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

  // Provider-specific variables
}

// Any provider-specific variables should be specified here
// Prefix any variables with "<provider>_" to avoid collisions
