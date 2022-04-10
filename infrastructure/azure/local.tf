locals {
  db       = "GP_Gen5_2"
  location = substr(var.location, 0, 3) # Short code for location
  machine  = "Standard_D4_v3"
  nodes = [
    {
      name = "services"
      labels = {
        lookup(var.labels, "workload_meta")      = true
        lookup(var.labels, "workload_ide")       = true
        lookup(var.labels, "workspace_services") = true
        lookup(var.labels, "workspace_regular")  = true
        lookup(var.labels, "workspace_headless") = true
      }
    }
  ]
}
