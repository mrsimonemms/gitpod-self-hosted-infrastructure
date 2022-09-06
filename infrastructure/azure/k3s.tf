resource "azurerm_public_ip" "k3s" {
  count = var.use_k3s ? local.k3s_nodes : 0

  name                = format(var.name_format, local.location, "k3s-${count.index}")
  location            = azurerm_resource_group.gitpod.location
  resource_group_name = azurerm_resource_group.gitpod.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "k3s" {
  count = var.use_k3s ? local.k3s_nodes : 0

  name                = format(var.name_format, local.location, "k3s-${count.index}")
  location            = azurerm_resource_group.gitpod.location
  resource_group_name = azurerm_resource_group.gitpod.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.network.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.k3s[count.index].id
  }
}

resource "azurerm_network_security_group" "k3s" {
  count = var.use_k3s ? 1 : 0

  name                = format(var.name_format, local.location, "k3s")
  location            = azurerm_resource_group.gitpod.location
  resource_group_name = azurerm_resource_group.gitpod.name
}

resource "azurerm_network_security_rule" "k3s" {
  count = length(local.network_security_rules_k3s)

  resource_group_name         = azurerm_resource_group.gitpod.name
  network_security_group_name = azurerm_network_security_group.k3s.0.name

  priority  = lookup(local.network_security_rules_k3s[count.index], "priority", sum([100, count.index]))
  name      = local.network_security_rules_k3s[count.index].name
  access    = local.network_security_rules_k3s[count.index].access
  direction = local.network_security_rules_k3s[count.index].direction
  protocol  = local.network_security_rules_k3s[count.index].protocol

  description                = lookup(local.network_security_rules_k3s[count.index], "description", null)
  source_port_range          = lookup(local.network_security_rules_k3s[count.index], "source_port_range", null)
  destination_port_range     = lookup(local.network_security_rules_k3s[count.index], "destination_port_range", null)
  source_address_prefix      = lookup(local.network_security_rules_k3s[count.index], "source_address_prefix", null)
  destination_address_prefix = lookup(local.network_security_rules_k3s[count.index], "destination_address_prefix", null)
}

resource "azurerm_network_interface_security_group_association" "k3s" {
  count = var.use_k3s ? local.k3s_nodes : 0

  network_interface_id      = azurerm_network_interface.k3s[count.index].id
  network_security_group_id = azurerm_network_security_group.k3s.0.id
}

resource "azurerm_linux_virtual_machine" "k3s" {
  count = var.use_k3s ? local.k3s_nodes : 0

  name                = format(var.name_format, local.location, "k3s-${count.index}")
  location            = azurerm_resource_group.gitpod.location
  resource_group_name = azurerm_resource_group.gitpod.name
  size                = local.machine
  admin_username      = local.k3s_username
  network_interface_ids = [
    azurerm_network_interface.k3s[count.index].id,
  ]
  disable_password_authentication = true

  admin_ssh_key {
    username   = local.k3s_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.k3s[count.index].id
    ]
  }
}

resource "azurerm_user_assigned_identity" "k3s" {
  count = var.dns_enabled && var.use_k3s ? local.k3s_nodes : 0

  name                = format(var.name_format, local.location, "k3s-${count.index}")
  location            = azurerm_resource_group.gitpod.location
  resource_group_name = azurerm_resource_group.gitpod.name
}

resource "azurerm_role_assignment" "dns_contributor" {
  count = var.dns_enabled && var.use_k3s ? local.k3s_nodes : 0

  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.k3s[count.index].principal_id
  scope                = azurerm_dns_zone.dns.0.id
}
