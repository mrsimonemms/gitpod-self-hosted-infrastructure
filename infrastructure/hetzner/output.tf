output "cert_manager_issuer" {
  value = []
}

output "cert_manager_secret" {
  value = {}
}

output "cluster_name" {
  value = "hetzner-k3s"
}

output "database" {
  sensitive = true
  value     = {}
}

output "domain_nameservers" {
  value = null
}

output "external_dns_secrets" {
  value = {}
}

output "external_dns_settings" {
  value = {}
}

output "k8s_connection" {
  sensitive = true
  value     = {}
}

output "kubeconfig" {
  sensitive = true
  value     = null
}

output "load_balancer_address" {
  value = local.nodes == 1 ? hcloud_server.node.0.ipv4_address : hcloud_load_balancer.load_balancer.0.ipv4
}

output "node_list" {
  value = [for k, v in hcloud_server.node[*] : {
    ssh_address : v.ipv4_address,
    k3s_address : v.ipv4_address,
    user : "root"
  }]
}

output "proxy_settings" {
  value = null
}

output "region" {
  value = var.location
}

output "registry" {
  sensitive = true
  value     = {}
}

output "storage" {
  sensitive = true
  value     = {}
}
