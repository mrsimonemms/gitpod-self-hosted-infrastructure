output "cert_manager_issuer" {
  value = lookup(local.cloud, "cert_manager_issuer")
}

output "cert_manager_secret" {
  value = lookup(local.cloud, "cert_manager_secret")
}

output "cert_manager_settings" {
  value = try(lookup(local.cloud, "cert_manager_settings"), {})
}

output "cluster_name" {
  value = lookup(local.cloud, "cluster_name")
}

output "database" {
  sensitive = true
  value     = lookup(local.cloud, "database")
}

output "domain_nameservers" {
  value = lookup(local.cloud, "domain_nameservers")
}

output "external_dns_secrets" {
  value = lookup(local.cloud, "external_dns_secrets")
}

output "external_dns_settings" {
  value = lookup(local.cloud, "external_dns_settings")
}

output "k8s_connection" {
  sensitive = true
  value     = lookup(local.cloud, "k8s_connection")
}

output "kubeconfig" {
  sensitive = true
  value     = lookup(local.cloud, "kubeconfig")
}

output "region" {
  value = lookup(local.cloud, "region")
}

output "registry" {
  sensitive = true
  value     = lookup(local.cloud, "registry")
}

output "storage" {
  sensitive = true
  value     = lookup(local.cloud, "storage")
}
