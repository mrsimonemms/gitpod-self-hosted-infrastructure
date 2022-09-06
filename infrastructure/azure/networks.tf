resource "azurerm_virtual_network" "network" {
  name                = format(var.name_format, local.location, "network")
  location            = azurerm_resource_group.gitpod.location
  resource_group_name = azurerm_resource_group.gitpod.name
  address_space       = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "network" {
  name                 = format(var.name_format, local.location, "network")
  resource_group_name  = azurerm_resource_group.gitpod.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.2.1.0/24"]
}

resource "azurerm_dns_zone" "dns" {
  count = var.dns_enabled ? 1 : 0

  name                = var.domain_name
  resource_group_name = azurerm_resource_group.gitpod.name
}

resource "azurerm_dns_a_record" "k3s" {
  count = var.dns_enabled && var.use_k3s ? length(local.dns_records) : 0

  name                = local.dns_records[count.index]
  zone_name           = azurerm_dns_zone.dns.0.name
  resource_group_name = azurerm_resource_group.gitpod.name
  ttl                 = 120
  target_resource_id  = azurerm_public_ip.k3s.0.id
}
