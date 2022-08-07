locals {
  location      = var.location
  image         = "ubuntu-20.04"
  load_balancer = "lb11"
  machine       = "cx41"
  nodes         = 2
  network_location = {
    nbg1 = "eu-central",
    fsn1 = "eu-central",
    hel1 = "eu-central",
    ash  = "us-east",
  }
}
