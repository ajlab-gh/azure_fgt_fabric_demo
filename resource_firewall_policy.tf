resource "azurerm_firewall_policy" "firewall_policy" {
  for_each                 = local.firewall_policies
  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  threat_intelligence_mode = each.value.threat_intelligence_mode
  sku                      = each.value.sku
  intrusion_detection {
    mode = each.value.intrusion_detection.mode
  }
}

output "firewall_policies" {
  value = var.enable_output ? azurerm_firewall_policy.firewall_policy[*] : null
}
