provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

variable "azure_location" {
  type        = string
  default     = "northeurope"
  description = "Region to use"
}
