data "azurerm_kubernetes_service_versions" "k8s" {
  count = var.use_k3s ? 0 : 1

  location        = azurerm_resource_group.gitpod.location
  include_preview = false
}

resource "azurerm_role_assignment" "k8s" {
  count = var.dns_enabled && !var.use_k3s ? 1 : 0

  principal_id         = azurerm_kubernetes_cluster.k8s[count.index].kubelet_identity[count.index].object_id
  role_definition_name = "DNS Zone Contributor"
  scope                = azurerm_dns_zone.dns[count.index].id
}

resource "azurerm_kubernetes_cluster" "k8s" {
  count = var.use_k3s ? 0 : 1

  name                = format(var.name_format, local.location, "primary")
  location            = azurerm_resource_group.gitpod.location
  resource_group_name = azurerm_resource_group.gitpod.name
  dns_prefix          = "gitpod"

  kubernetes_version               = data.azurerm_kubernetes_service_versions.k8s[count.index].latest_version
  http_application_routing_enabled = false

  default_node_pool {
    name    = local.nodes.0.name
    vm_size = local.machine

    enable_auto_scaling  = true
    min_count            = 2
    max_count            = 10
    orchestrator_version = data.azurerm_kubernetes_service_versions.k8s[count.index].latest_version
    node_labels          = local.nodes.0.labels

    type           = "VirtualMachineScaleSets"
    vnet_subnet_id = azurerm_subnet.network.id
  }

  identity {
    type = "SystemAssigned"
  }

  # @link https://docs.microsoft.com/en-us/azure/aks/http-proxy#configuring-an-http-proxy-using-azure-cli
  dynamic "http_proxy_config" {
    for_each = local.proxy_server_enabled ? [""] : []
    content {
      http_proxy  = var.http_proxy  # This should be in format "http://address:port/"
      https_proxy = var.https_proxy # This should be in format "https://address:port/"
      no_proxy = setunion(
        # Ignore any local network addresses
        [
          "localhost",
          "127.0.0.1",
          "10.0.0.0/8",
          "192.168.0.0/16",
          ".cluster.local",
        ],
        var.no_proxy
      )
      trusted_ca = var.proxy_trusted_ca # This should be in base64 format
    }
  }

  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.monitoring.id
  }

  lifecycle {
    ignore_changes = [
      http_proxy_config.0.no_proxy
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "pools" {
  count = var.use_k3s ? 0 : length(local.nodes) - 1

  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s[count.index].id
  name                  = local.nodes[count.index + 1].name
  vm_size               = local.machine

  enable_auto_scaling  = true
  min_count            = 2
  max_count            = 10
  orchestrator_version = data.azurerm_kubernetes_service_versions.k8s[count.index].latest_version
  node_labels          = local.nodes[count.index + 1].labels
  vnet_subnet_id       = azurerm_subnet.network.id
}

resource "time_sleep" "wait_2_mins" {
  count = var.enable_airgapped && !var.use_k3s ? 1 : 0

  create_duration = "2m"

  depends_on = [
    azurerm_kubernetes_cluster.k8s,
    azurerm_kubernetes_cluster_node_pool.pools
  ]
}

data "azurerm_resources" "k8s" {
  count = var.enable_airgapped && !var.use_k3s ? 1 : 0

  resource_group_name = azurerm_kubernetes_cluster.k8s[count.index].node_resource_group
  type                = "Microsoft.Network/networkSecurityGroups"

  depends_on = [
    time_sleep.wait_2_mins
  ]
}

resource "azurerm_network_security_rule" "k8s" {
  count = length(local.network_security_rules_airgapped)

  resource_group_name         = var.use_k3s ? azurerm_resource_group.gitpod.name : azurerm_kubernetes_cluster.k8s.0.node_resource_group
  network_security_group_name = var.use_k3s ? azurerm_network_security_group.k3s.0.name : data.azurerm_resources.k8s.0.resources.0.name

  priority  = lookup(local.network_security_rules_airgapped[count.index], "priority", sum([100, count.index]))
  name      = local.network_security_rules_airgapped[count.index].name
  access    = local.network_security_rules_airgapped[count.index].access
  direction = local.network_security_rules_airgapped[count.index].direction
  protocol  = local.network_security_rules_airgapped[count.index].protocol

  description                = lookup(local.network_security_rules_airgapped[count.index], "description", null)
  source_port_range          = lookup(local.network_security_rules_airgapped[count.index], "source_port_range", null)
  destination_port_range     = lookup(local.network_security_rules_airgapped[count.index], "destination_port_range", null)
  source_address_prefix      = lookup(local.network_security_rules_airgapped[count.index], "source_address_prefix", null)
  destination_address_prefix = lookup(local.network_security_rules_airgapped[count.index], "destination_address_prefix", null)
}
