locals {
  db           = "GP_Gen5_2"
  dns_records  = ["@", "*", "*.ws"]
  k3s_username = "azurek3s"
  k3s_nodes    = 2
  location     = substr(var.location, 0, 3) # Short code for location
  machine      = "Standard_D4s_v3"
  network_security_rules_k3s = var.use_k3s ? [
    {
      name                       = "SSH"
      description                = "Allow SSH access"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTP"
      description                = "Allow HTTP access"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTPS"
      description                = "Allow HTTPS access"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Kubernetes"
      description                = "Allow Kubernetes access"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "6443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "k3s flannel"
      description                = "Required only for Flannel VXLAN"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "8472"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "k3s flannel wireguard"
      description                = "Required only for Flannel Wireguard backend"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "51820"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "k3s flannel wireguard ipv6"
      description                = "Required only for Flannel Wireguard backend with IPv6"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "51821"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "k3s metrics"
      description                = "Kubelet metrics"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "10250"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "k3s nodes"
      description                = "Required only for HA with embedded etcd"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "2379-2380"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
  ] : []
  network_security_rules_airgapped = var.enable_airgapped ? [
    {
      name                       = "AllowContainerRegistry"
      description                = "Allow outgoing traffic to the container registry"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "AzureContainerRegistry"
    },
    {
      name                       = "AllowDatabase"
      description                = "Allow outgoing traffic to the database"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "Sql"
    },
    {
      name                       = "AllowStorage"
      description                = "Allow outgoing traffic to the storage"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "Storage"
    },
    {
      name                       = "AllowAzureCloud"
      description                = "Allow outgoing traffic to the Azure cloud"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "AzureCloud"
    },
    {
      name                       = "DenyInternetOutBound"
      description                = "Deny outgoing traffic to the public internet"
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "Internet"
      priority                   = 4096
    }
  ] : []
  nodes = [
    {
      name = "services"
      labels = {
        lookup(var.labels, "workload_meta")      = true
        lookup(var.labels, "workload_ide")       = true
        lookup(var.labels, "workspace_services") = true
        lookup(var.labels, "workspace_regular")  = true
        lookup(var.labels, "workspace_headless") = true
      }
    }
  ]
  proxy_server_enabled = var.http_proxy != null || var.https_proxy != null
}
