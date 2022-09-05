data "google_container_registry_repository" "gitpod" {
  count = var.enable_external_registry ? 1 : 0
}

resource "google_service_account" "storage" {
  count = var.enable_external_registry ? 1 : 0

  account_id = "storage"
}

resource "google_service_account_key" "storage" {
  count = var.enable_external_registry ? 1 : 0

  service_account_id = google_service_account.storage[count.index].name
}

resource "google_project_iam_binding" "storage" {
  for_each = var.enable_external_registry ? toset([
    "roles/storage.admin",
    "roles/storage.objectAdmin"
  ]) : toset([])

  project = var.project_id
  role    = each.value

  members = [
    "serviceAccount:${google_service_account.storage[0].email}",
  ]
}
