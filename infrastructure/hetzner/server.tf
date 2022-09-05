resource "hcloud_ssh_key" "terraform" {
  name       = format(var.name_format, local.location, "ssh")
  public_key = file("~/.ssh/id_rsa.pub")

  labels = {
    managed_by = "terraform"
  }
}

resource "hcloud_placement_group" "kubernetes" {
  name = format(var.name_format, local.location, "kubernetes")
  type = "spread"

  labels = {
    managed_by = "terraform"
  }
}

resource "hcloud_server" "node" {
  count = local.nodes

  name        = format(var.name_format, local.location, "node-${count.index}")
  image       = local.image
  server_type = local.machine
  location    = var.location

  firewall_ids = [
    hcloud_firewall.firewall.id
  ]

  network {
    network_id = hcloud_network.network.id
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  placement_group_id = hcloud_placement_group.kubernetes.id
  ssh_keys = [
    hcloud_ssh_key.terraform.id,
  ]

  labels = {
    managed_by = "terraform"
  }
}

# The servers aren't immediately available when started
resource "time_sleep" "servers" {
  depends_on = [hcloud_server.node]

  create_duration = "30s"
}
