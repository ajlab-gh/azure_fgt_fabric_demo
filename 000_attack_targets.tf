locals {
  attack_targets = {
    fgt = {
      DVWAURL      = "http://${azurerm_public_ip.public_ip["${var.prefix}-fgt-pip1"].fqdn}:8001",
      JUICESHOPURL = "http://${azurerm_public_ip.public_ip["${var.prefix}-fgt-pip1"].fqdn}:8002",
      PETSTOREURL  = "http://${azurerm_public_ip.public_ip["${var.prefix}-fgt-pip1"].fqdn}:8003/api/v3/pet",
      BANKURL      = "http://${azurerm_public_ip.public_ip["${var.prefix}-fgt-pip1"].fqdn}:8004"
    },
    fwb = {
      DVWAURL      = "https://${azurerm_public_ip.public_ip["${var.prefix}-fwb-pip1"].fqdn}",
      JUICESHOPURL = "https://${azurerm_public_ip.public_ip["${var.prefix}-fwb-pip2"].fqdn}",
      PETSTOREURL  = "https://${azurerm_public_ip.public_ip["${var.prefix}-fwb-pip3"].fqdn}/api/v3/pet",
      BANKURL      = "https://${azurerm_public_ip.public_ip["${var.prefix}-fwb-pip4"].fqdn}"
    },
    azfw = {
      DVWAURL      = "http://${azurerm_public_ip.public_ip["${var.prefix}-azfw-pip1"].fqdn}:8001",
      JUICESHOPURL = "http://${azurerm_public_ip.public_ip["${var.prefix}-azfw-pip1"].fqdn}:8002",
      PETSTOREURL  = "http://${azurerm_public_ip.public_ip["${var.prefix}-azfw-pip1"].fqdn}:8003/api/v3/pet",
      BANKURL      = "http://${azurerm_public_ip.public_ip["${var.prefix}-azfw-pip1"].fqdn}:8004"
    },
    appgw = {
      DVWAURL      = "http://${azurerm_public_ip.public_ip["${var.prefix}-appgw-pip1"].fqdn}:8001",
      JUICESHOPURL = "http://${azurerm_public_ip.public_ip["${var.prefix}-appgw-pip1"].fqdn}:8002",
      PETSTOREURL  = "http://${azurerm_public_ip.public_ip["${var.prefix}-appgw-pip1"].fqdn}:8003/api/v3/pet",
      BANKURL      = "http://${azurerm_public_ip.public_ip["${var.prefix}-appgw-pip1"].fqdn}:8004"
    }
  }
}
