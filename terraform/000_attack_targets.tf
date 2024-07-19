locals {
  attack_targets = {
    fgt = {
      DVWAURL      = "http://${azurerm_public_ip.public_ip["${var.prefix}-fgt-pip1"].fqdn}:8001",
      JUICESHOPURL = "http://${azurerm_public_ip.public_ip["${var.prefix}-fgt-pip1"].fqdn}:8002",
      PETSTOREURL  = "http://${azurerm_public_ip.public_ip["${var.prefix}-fgt-pip1"].fqdn}:8003/api/v3/pet",
      BANKURL      = "http://${azurerm_public_ip.public_ip["${var.prefix}-fgt-pip1"].fqdn}:8004"
    }
  }
}
