locals {
  location      = var.location
  image         = "ubuntu-20.04"
  load_balancer = "lb11"
  firewall = [
    {
      description = "SSH"
      port        = "22"
    },
    {
      description = "HTTP"
      port        = "80"
    },
    {
      description = "HTTPS"
      port        = "443"
    },
    {
      description = "Kubernetes"
      port        = "6443"
    },
    {
      description = "k3s"
      port        = "2379-2380"
    },
    {
      description = "k3s"
      protocol    = "udp"
      port        = "8472"
    },
    {
      description = "k3s"
      protocol    = "udp"
      port        = "51820"
    },
    {
      description = "k3s"
      protocol    = "udp"
      port        = "51821"
    },
    {
      description = "k3s"
      protocol    = "udp"
      port        = "10250"
    },
    {
      description = "DNS"
      protocol    = "udp"
      port        = "53"
    },
    {
      description = "DNS"
      port        = "53"
    },
  ]
  machine = "cx41"
  nodes   = 2
  network_location = {
    nbg1 = "eu-central",
    fsn1 = "eu-central",
    hel1 = "eu-central",
    ash  = "us-east",
  }
}
