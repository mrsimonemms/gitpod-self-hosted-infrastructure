resource "hcloud_network" "network" {
  name     = format(var.name_format, local.location, "network")
  ip_range = "10.2.0.0/16"

  labels = {
    managed_by = "terraform"
  }
}

resource "hcloud_network_subnet" "network-subnet" {
  type         = "server"
  network_id   = hcloud_network.network.id
  network_zone = local.network_location[var.location]
  ip_range     = "10.2.0.0/24"
}
