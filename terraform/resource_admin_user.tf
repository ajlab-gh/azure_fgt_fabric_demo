resource "random_pet" "admin_username" {
  length = 1
}

resource "random_password" "admin_password" {
  length      = 16
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  special     = false
}
