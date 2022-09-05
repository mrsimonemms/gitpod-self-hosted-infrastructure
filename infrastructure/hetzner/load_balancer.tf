resource "hcloud_load_balancer" "load_balancer" {
  count = local.nodes > 1 ? 1 : 0

  name               = format(var.name_format, local.location, "kubernetes")
  load_balancer_type = local.load_balancer
  location           = var.location
  algorithm {
    type = "round_robin"
  }

  labels = {
    managed_by = "terraform"
  }
}

resource "hcloud_load_balancer_target" "nodes" {
  count = local.nodes > 1 ? local.nodes : 0

  load_balancer_id = hcloud_load_balancer.load_balancer.0.id
  server_id        = hcloud_server.node[count.index].id
  type             = "server"
}

resource "hcloud_load_balancer_service" "http" {
  count = local.nodes > 1 ? 1 : 0

  load_balancer_id = hcloud_load_balancer.load_balancer.0.id
  protocol         = "http"
  listen_port      = 80
}

resource "hcloud_load_balancer_service" "https" {
  count = local.nodes > 1 ? 1 : 0

  load_balancer_id = hcloud_load_balancer.load_balancer.0.id
  protocol         = "tcp"
  listen_port      = 443
  destination_port = 443
}
