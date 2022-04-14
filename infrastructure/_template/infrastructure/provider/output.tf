output "cert_manager_issuer" {
  value = []
}

output "cert_manager_secret" {
  value = {}
}

output "cluster_name" {
  value = ""
}

output "database" {
  sensitive = true
  value     = try({}, {})
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
  value = {
    host                   = ""
    username               = ""
    password               = ""
    client_certificate     = base64decode("")
    client_key             = base64decode("")
    cluster_ca_certificate = base64decode("")
  }
}

output "kubeconfig" {
  sensitive = true
  value     = ""
}

output "region" {
  value = var.location
}

output "registry" {
  sensitive = true
  value = try({
    server   = ""
    password = ""
    username = ""
  }, {})
}

output "storage" {
  sensitive = true
  value     = {}
}
