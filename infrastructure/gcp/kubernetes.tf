# Get latest version available in the given zone
data "google_container_engine_versions" "clusters" {
  location = var.region
}

resource "google_service_account" "k8s" {
  account_id   = substr(format(var.name_format, local.region, "k8s"), 0, 28)
  display_name = "Kubernetes cluster service account"
  description  = "Service account for Kubernetes instance"
}

resource "google_container_cluster" "primary" {
  name        = substr(format(var.name_format, local.region, "primary"), 0, 40)
  description = "Kubernetes control plane"
  location    = var.region

  # Remove default node pool so we can create our own
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.container_network.name
  subnetwork = google_compute_subnetwork.container_subnetwork.name

  min_master_version = data.google_container_engine_versions.clusters.default_cluster_version

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }

    dns_cache_config {
      enabled = true
    }
  }
}

resource "google_container_node_pool" "nodes" {
  count = length(local.nodes)

  name               = local.nodes[count.index].name
  location           = var.region
  cluster            = google_container_cluster.primary.name
  initial_node_count = local.nodes[count.index].min_node_count

  autoscaling {
    min_node_count = local.nodes[count.index].min_node_count
    max_node_count = local.nodes[count.index].max_node_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = true
    machine_type = local.nodes[count.index].machine
    labels       = local.nodes[count.index].labels

    image_type   = "UBUNTU_CONTAINERD"
    disk_type    = "pd-ssd"
    disk_size_gb = local.nodes[count.index].disk_size_gb

    metadata = {
      disable-legacy-endpoints = "true"
    }

    service_account = google_service_account.k8s.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    tags = [
      "gke-node",
      "${var.project_id}-gke",
    ]
  }
}

module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.nodes
  ]

  project_id   = var.project_id
  location     = google_container_cluster.primary.location
  cluster_name = google_container_cluster.primary.name
}

resource "google_compute_firewall" "k8s" {
  count = var.enable_airgapped ? 1 : 0

  name    = "airgapped-network"
  network = google_compute_network.container_network.self_link

  direction = "EGRESS"

  deny {
    protocol = "tcp"
  }
}
