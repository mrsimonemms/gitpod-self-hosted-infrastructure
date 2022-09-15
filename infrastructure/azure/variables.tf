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
variable "http_proxy" {
  validation {
    condition = var.http_proxy == null ? true : substr(var.http_proxy, -1, 1) == "/"
    error_message = "The http_proxy variable must end with \"/\" if set."
  }
}
variable "https_proxy" {
  validation {
    condition = var.https_proxy == null ? true : substr(var.https_proxy, -1, 1) == "/"
    error_message = "The https_proxy variable must end with \"/\" if set."
  }
}
variable "no_proxy" {}
variable "proxy_trusted_ca" {}

// Azure-specific variables
variable "location" {}
variable "use_k3s" {}
