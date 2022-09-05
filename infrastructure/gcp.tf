// Gcp

module "gcp" {
  source = "./gcp"
  count  = var.cloud == "gcp" ? 1 : 0

  // Common variables
  // These may not be used inside the gcp, but should be declared
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

  // Gcp-specific variables
  project_id = var.google_project_id
  region     = var.google_region
}

// Any gcp-specific variables should be specified here
// Prefix any variables with "<google>_" to avoid collisions
variable "google_region" {}
variable "google_project_id" {}
