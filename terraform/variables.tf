variable "prefix" {
  description = "The Prefix to append to your resources"
  type        = string
}
variable "remote_gw" {
  description = "Add the Peer IP for your Site to Site VPN"
  type        = string
}
variable "virtual_network_cidr" {
  description = "CIDR Notation for Virtual Network"
  type        = string
  default     = "10.20.0.0/16"
}
variable "license_type" {
  description = "Provide the license type for FortiGate-VM Instances, either BYOL or PAYG."
  type        = string
  default     = "payg"

  validation {
    condition     = contains(["byol", "payg"], var.license_type)
    error_message = "The license_type variable must be either 'byol' or 'payg'."
  }
}
variable "license_format" {
  description = "Provide the license type for FortiGate-VM Instances, either token or file."
  type        = string
  default     = "file"

  validation {
    condition     = contains(["token", "file"], var.license_format)
    error_message = "You must define whether you are providing a FortiFlex Token, or License File for License Content in BYOL."
  }
}
variable "license_file_location" {
  description = "Add the name of your license file for BYOL deployment"
  type        = string
  default     = "../license.lic"
}
variable "enable_output" {
  description = "Enable/Disable output"
  type        = bool
  default     = false
}
