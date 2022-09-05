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
  http_proxy               = var.http_proxy
  https_proxy              = var.https_proxy
  no_proxy                 = var.no_proxy
  proxy_trusted_ca         = var.proxy_trusted_ca

  // Cloud-specific variables
  azure_location = var.azure_location

  google_project_id = var.google_project_id
  google_region     = var.google_region

  hetzner_location = var.hetzner_location
}
