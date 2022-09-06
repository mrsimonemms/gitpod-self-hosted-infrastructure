output "cert_manager_issuer" {
  value = try([{
    dns01 = {
      azureDNS = {
        subscriptionID    = data.azurerm_client_config.current.subscription_id
        resourceGroupName = azurerm_resource_group.gitpod.name
        hostedZoneName    = azurerm_dns_zone.dns.0.name
        managedIdentity = {
          clientID = var.use_k3s ? azurerm_user_assigned_identity.k3s.0.client_id : azurerm_kubernetes_cluster.k8s.0.kubelet_identity.0.client_id
        }
      }
    }
  }], [])
}

output "cert_manager_secret" {
  value = {}
}

output "cluster_name" {
  value = try(azurerm_kubernetes_cluster.k8s.0.name, null)
}

output "database" {
  sensitive = true
  value = try({
    host     = "${azurerm_mysql_server.db.0.name}.mysql.database.azure.com"
    password = azurerm_mysql_server.db.0.administrator_login_password
    port     = 3306
    username = "${azurerm_mysql_server.db.0.administrator_login}@${azurerm_mysql_server.db.0.name}"
  }, {})
}

output "domain_nameservers" {
  value = try(azurerm_dns_zone.dns.0.name_servers, null)
}

output "external_dns_secrets" {
  value = {}
}

output "external_dns_settings" {
  value = try({
    provider                            = "azure"
    "azure.resourceGroup"               = azurerm_resource_group.gitpod.name
    "azure.subscriptionId"              = data.azurerm_client_config.current.subscription_id
    "azure.tenantId"                    = data.azurerm_client_config.current.tenant_id
    "azure.useManagedIdentityExtension" = true
    "azure.userAssignedIdentityID"      = var.use_k3s ? azurerm_user_assigned_identity.k3s.0.client_id : azurerm_kubernetes_cluster.k8s.0.kubelet_identity.0.client_id
  }, {})
}

output "k8s_connection" {
  sensitive = true
  value = try({
    host                   = azurerm_kubernetes_cluster.k8s.0.kube_config.0.host
    username               = azurerm_kubernetes_cluster.k8s.0.kube_config.0.username
    password               = azurerm_kubernetes_cluster.k8s.0.kube_config.0.password
    client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.0.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.k8s.0.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.0.kube_config.0.cluster_ca_certificate)
  }, {})
}

output "kubeconfig" {
  sensitive = true
  value     = try(azurerm_kubernetes_cluster.k8s.0.kube_config_raw, null)
}

output "node_list" {
  value = var.use_k3s ? [for k in range(local.k3s_nodes) : {
    ssh_address = azurerm_public_ip.k3s[k].ip_address
    k3s_address = azurerm_public_ip.k3s[k].ip_address
    user        = local.k3s_username
  }] : []
}

output "proxy_settings" {
  value = try({
    http_proxy  = var.use_k3s ? var.http_proxy : azurerm_kubernetes_cluster.k8s.0.http_proxy_config.0.http_proxy,
    https_proxy = var.use_k3s ? var.https_proxy : azurerm_kubernetes_cluster.k8s.0.http_proxy_config.0.https_proxy,
    // no_proxy list taken from https://rancher.com/docs/rancher/v2.5/en/installation/other-installation-methods/single-node-docker/proxy/
    no_proxy = var.use_k3s ? "localhost,127.0.0.1,0.0.0.0,10.0.0.0/8,cattle-system.svc,.svc,.cluster.local,${var.domain_name}" : join(",", azurerm_kubernetes_cluster.k8s.0.http_proxy_config.0.no_proxy),
  }, null)
}

output "region" {
  value = var.location
}

output "registry" {
  sensitive = true
  value = try({
    server   = azurerm_container_registry.registry.0.login_server
    password = azurerm_container_registry.registry.0.admin_password
    username = azurerm_container_registry.registry.0.admin_username
  }, {})
}

output "storage" {
  sensitive = true
  value = try({
    region   = var.location
    username = azurerm_storage_account.storage.0.name
    password = azurerm_storage_account.storage.0.primary_access_key
  }, {})
}
