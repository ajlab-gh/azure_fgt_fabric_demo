variable "virtual_network_cidr" {
  description = "CIDR Notation for Virtual Network"
  type        = string
  default     = "10.20.0.0/16"
}
variable "enable_output" {
  description = "Enable/Disable output"
  type        = bool
  default     = false
}
variable "prefix" {
  description = "The Prefix to append to your resources"
  type        = string
}
variable "license" {
  description = "Add the name of your license file for BYOL deployment"
  type        = string
  default     = "../license.lic"
}
variable "remote_gw" {
  description = "Add the Peer IP for your Site to Site VPN"
  type        = string
}
