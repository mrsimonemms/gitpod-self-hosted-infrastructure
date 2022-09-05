variable "cloud" {
  type        = string
  description = "The cloud provider to deploy to"
  validation {
    condition = contains([
      "azure",
      "gcp",
      "hetzner",
    ], var.cloud)
    error_message = "Cloud provider unsupported."
  }
}

variable "cloudflare_solver" {
  default = null
  type = object({
    email : string
    token : string
  })
  description = "The CloudFlare solver settings."
}

variable "domain_name" {
  default     = null
  description = "The domain name Gitpod should be installed to - if left blank, DNS is not configured"
  type        = string
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

variable "http_proxy" {
  default     = null
  description = "If supported by the cloud provider, route Kubernetes requests through an HTTP proxy"
  type        = string
}

variable "https_proxy" {
  default     = null
  description = "If supported by the cloud provider, route Kubernetes requests through an HTTPS proxy"
  type        = string
}

variable "no_proxy" {
  default     = []
  description = "If supported by the cloud provider, ignore these URLs for proxying"
  type        = set(string)
}

variable "proxy_trusted_ca" {
  default     = null
  description = "If supported by the cloud provider, the proxy's trusted certificate authority"
  type        = string
}
