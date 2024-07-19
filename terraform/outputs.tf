
output "fortigate_connection_string" {
  description = "This string represents the connection string for the Management of the FortiGate"
  value       = "https://${azurerm_public_ip.public_ip["${var.prefix}-fgt-pip1"].fqdn}"
}

output "admin_username" {
  description = "Username for admin account"
  value       = random_pet.admin_username.id
}

output "admin_password" {
  description = "Password for admin account"
  value       = random_password.admin_password.result
  sensitive   = true
}
