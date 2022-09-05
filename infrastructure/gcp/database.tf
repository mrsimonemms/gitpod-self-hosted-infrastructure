resource "random_integer" "db" {
  count = var.enable_external_database ? 1 : 0

  min = 10000
  max = 99999
}

resource "random_password" "db" {
  count = var.enable_external_database ? 1 : 0

  length = 32
}

resource "google_sql_database_instance" "gitpod" {
  count = var.enable_external_database ? 1 : 0

  name                = "gitpod-${random_integer.db[count.index].result}" // we cannot reuse the same name for 1 week
  database_version    = "MYSQL_5_7"
  region              = var.region
  deletion_protection = false

  settings {
    tier            = "db-n1-standard-2"
    disk_autoresize = true

    ip_configuration {
      ipv4_enabled = true
    }
  }
}

resource "google_sql_user" "gitpod" {
  count = var.enable_external_database ? 1 : 0

  instance        = google_sql_database_instance.gitpod[count.index].name
  name            = "gitpod"
  password        = random_password.db[count.index].result
  deletion_policy = "ABANDON"
}

resource "google_sql_database" "database" {
  count = var.enable_external_database ? 1 : 0

  name      = "gitpod"
  instance  = google_sql_database_instance.gitpod[count.index].name
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_service_account" "database" {
  count = var.enable_external_database ? 1 : 0

  account_id = "database"
}

resource "google_project_iam_binding" "database" {
  for_each = var.enable_external_database ? toset([
    "roles/cloudsql.client"
  ]) : toset([])

  project = var.project_id
  role    = each.value

  members = [
    "serviceAccount:${google_service_account.database[0].email}",
  ]
}

resource "google_service_account_key" "database" {
  count = var.enable_external_database ? 1 : 0

  service_account_id = google_service_account.database[count.index].name
}
