provider "azurerm" {
  features {}
}

variable "azure_location" {
  type        = string
  default     = "northeurope"
  description = "Region to use"
}
