// Hetzner

module "hetzner" {
  source = "./hetzner"
  count  = var.cloud == "hetzner" ? 1 : 0

  // Common variables
  // These may not be used inside the hetzner, but should be declared
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
  http_proxy               = var.http_proxy
  https_proxy              = var.https_proxy
  no_proxy                 = var.no_proxy
  proxy_trusted_ca         = var.proxy_trusted_ca

  // Hetzner-specific variables
  location = var.hetzner_location
}

// Any hetzner-specific variables should be specified here
// Prefix any variables with "<hetzner>_" to avoid collisions
variable "hetzner_location" {}
