// Common variables
variable "dns_enabled" {}
variable "domain_name" {}
variable "enable_airgapped" {}
variable "enable_external_database" {}
variable "enable_external_registry" {}
variable "enable_external_storage" {}
variable "labels" {}
variable "name_format" {}
variable "name_format_global" {}
variable "workspace_name" {}
variable "http_proxy" {}
variable "https_proxy" {}
variable "no_proxy" {}
variable "proxy_trusted_ca" {}

// Hetzner-specific variables
variable "location" {
  validation {
    condition = contains([
      "nbg1",
      "fsn1",
      "hel1",
      "ash",
    ], var.location)
    error_message = "Location unsupported."
  }
}
