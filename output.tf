output "cert_manager_issuer" {
  sensitive = true
  value = module.infrastructure.cert_manager_issuer
}

output "cert_manager_secret" {
  sensitive = true
  value = module.infrastructure.cert_manager_secret
}

output "cert_manager_settings" {
  sensitive = true
  value = module.infrastructure.cert_manager_settings
}

output "cluster_name" {
  value = module.infrastructure.cluster_name
}

output "database" {
  sensitive = true
  value     = module.infrastructure.database
}

output "domain_nameservers" {
  value = module.infrastructure.domain_nameservers
}

output "enable_airgapped" {
  value = var.enable_airgapped
}

output "external_dns_secrets" {
  sensitive = true
  value = module.infrastructure.external_dns_secrets
}

output "external_dns_settings" {
  sensitive = true
  value = module.infrastructure.external_dns_settings
}

output "k8s_connection" {
  sensitive = true
  value     = module.infrastructure.k8s_connection
}

output "kubeconfig" {
  sensitive = true
  value     = module.infrastructure.kubeconfig
}

output "region" {
  value = module.infrastructure.region
}

output "registry" {
  sensitive = true
  value     = module.infrastructure.registry
}

output "storage" {
  sensitive = true
  value     = module.infrastructure.storage
}
