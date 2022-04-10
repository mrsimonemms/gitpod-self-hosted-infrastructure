variable "cloud" {
  type        = string
  description = "The cloud provider to deploy to"
  validation {
    condition = contains([
      "azure",
    ], var.cloud)
    error_message = "Cloud provider unsupported."
  }
}

variable "enable_airgapped" {
  default     = false
  description = "If supported by the cloud provider, configure a cluster isolated from the public internet"
  type        = bool
}

variable "enable_external_database" {
  default     = true
  description = "If supported by the cloud provider, use an external database"
  type        = bool
}

variable "enable_external_registry" {
  default     = true
  description = "If supported by the cloud provider, use an external registry"
  type        = bool
}

variable "enable_external_storage" {
  default     = true
  description = "If supported by the cloud provider, use an external storage"
  type        = bool
}
