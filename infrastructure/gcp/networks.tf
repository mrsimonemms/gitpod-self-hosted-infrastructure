resource "google_compute_network" "container_network" {
  name                            = format(var.name_format, local.region, "network")
  description                     = "Network to establish private connections between the container and any resources"
  auto_create_subnetworks         = true
  delete_default_routes_on_create = false
}

resource "google_compute_subnetwork" "container_subnetwork" {
  name          = format(var.name_format, local.region, "subnetwork")
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.container_network.self_link
}

resource "google_dns_managed_zone" "dns" {
  count = var.dns_enabled ? 1 : 0

  name          = "zone-gitpod"
  dns_name      = "${var.domain_name}."
  description   = "Terraform managed DNS zone for ${var.domain_name}"
  force_destroy = true
  labels = {
    app = "gitpod"
  }
}

resource "google_service_account" "dns" {
  count = var.dns_enabled ? 1 : 0

  account_id   = substr("dns-${replace(var.domain_name, ".", "-")}", 0, 28)
  display_name = "DNS service account"
}

resource "google_project_iam_binding" "dns" {
  for_each = var.dns_enabled ? toset([
    "roles/dns.admin"
  ]) : toset([])

  project = var.project_id
  role    = each.value

  members = [
    "serviceAccount:${google_service_account.dns[0].email}",
  ]
}

resource "google_service_account_key" "dns" {
  count = var.dns_enabled ? 1 : 0

  service_account_id = google_service_account.dns[count.index].name
}
