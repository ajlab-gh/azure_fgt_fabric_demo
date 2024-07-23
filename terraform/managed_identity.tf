data "azurerm_subscription" "primary" {}

resource "azurerm_role_assignment" "fgt_managed_identity" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader"
  principal_id         = azurerm_linux_virtual_machine.linux_virtual_machine["${var.prefix}-fgt"].identity[0].principal_id
}
