output "cert_manager_issuer" {
  value = try([
    {
      dns01 = {
        cloudDNS = {
          project : var.project_id
          serviceAccountSecretRef = {
            name = "dns"
            key = "key.json"
          }
        }
      }
    }
  ], [])
}

output "cert_manager_secret" {
  value = {
    "key.json" = base64decode(google_service_account_key.dns[0].private_key)
  }
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "database" {
  sensitive = true
  value = try({
    cloud_sql_proxy_enabled = true
    connection_name         = google_sql_database_instance.gitpod[0].connection_name
    username                = google_sql_user.gitpod[0].name
    password                = google_sql_user.gitpod[0].password
    service_account_key     = base64decode(google_service_account_key.database[0].private_key)
  }, {})
}

output "domain_nameservers" {
  value = try(google_dns_managed_zone.dns.0.name_servers, null)
}

output "external_dns_secrets" {
  value = try({
    "dns" = {
      "credentials.json" = base64decode(google_service_account_key.dns[0].private_key)
    }
  }, {})
}

output "external_dns_settings" {
  value = {
    provider                         = "google"
    "google.project"                 = var.project_id
    "google.serviceAccountSecret"    = "dns"
    "google.serviceAccountSecretKey" = "credentials.json"
  }
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
  value     = module.gke_auth.kubeconfig_raw
}

output "proxy_settings" {
  value = null
}

output "region" {
  value = var.region
}

output "registry" {
  sensitive = true
  value = try({
    server   = "gcr.io"
    password = base64decode(google_service_account_key.storage[0].private_key)
    url      = "${data.google_container_registry_repository.gitpod[0].repository_url}/gitpod"
    username = "_json_key"
  }, {})
}

output "storage" {
  sensitive = true
  value = {
    region              = var.region
    project_id          = var.project_id
    service_account_key = base64decode(google_service_account_key.storage[0].private_key)
  }
}
