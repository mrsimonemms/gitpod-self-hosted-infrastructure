terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0, < 4.0.0"
    }
  }
}

data "azurerm_client_config" "current" {}

resource "random_integer" "resource_group" {
  min = 1000
  max = 9999
}

resource "azurerm_resource_group" "gitpod" {
  name     = format(var.name_format_global, "${random_integer.resource_group.result}-${local.location}")
  location = var.location
}
