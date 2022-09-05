// Root directory
//
// Here, add in any gcp configuration and public variables

provider "google" {
  project = var.google_project_id
  region  = var.google_region
}

variable "google_project_id" {
  type        = string
  description = "Project ID to use"
}

variable "google_region" {
  type        = string
  default     = "europe-west2"
  description = "Region to use"
}
