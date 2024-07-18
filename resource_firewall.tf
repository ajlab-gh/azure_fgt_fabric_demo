resource "azurerm_firewall" "firewall" {
  for_each            = local.firewalls
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku_name            = each.value.sku_name
  sku_tier            = each.value.sku_tier
  firewall_policy_id  = each.value.firewall_policy_id

  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations
    content {
      name                 = ip_configuration.value.name
      public_ip_address_id = ip_configuration.value.public_ip_address_id
      subnet_id            = lookup(ip_configuration.value, "subnet_id", null)
    }
  }
}

output "firewalls" {
  value = var.enable_output ? azurerm_firewall.firewall[*] : null
}
