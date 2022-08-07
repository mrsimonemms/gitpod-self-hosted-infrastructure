// Root directory
//
// Here, add in any hetzner configuration and public variables
variable "hetzner_location" {
  type        = string
  default     = "nbg1" # Nuremburg
  description = "Region to use"
}
