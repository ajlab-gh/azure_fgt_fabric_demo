resource "azurerm_web_application_firewall_policy" "web_application_firewall_policy" {
  for_each            = local.web_application_firewall_policies
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  policy_settings {
    enabled                     = each.value.policy_settings.enabled
    mode                        = each.value.policy_settings.mode
    request_body_check          = each.value.policy_settings.request_body_check
    file_upload_limit_in_mb     = each.value.policy_settings.file_upload_limit_in_mb
    max_request_body_size_in_kb = each.value.policy_settings.max_request_body_size_in_kb
  }

  custom_rules {
    name      = each.value.custom_rules.name
    priority  = each.value.custom_rules.priority
    rule_type = each.value.custom_rules.rule_type
    action    = each.value.custom_rules.action

    match_conditions {
      match_variables {
        variable_name = each.value.custom_rules.match_conditions.match_variables.variable_name
        selector      = each.value.custom_rules.match_conditions.match_variables.selector
      }
      operator           = each.value.custom_rules.match_conditions.operator
      negation_condition = each.value.custom_rules.match_conditions.negation_condition
      match_values       = each.value.custom_rules.match_conditions.match_values
    }
  }

  managed_rules {
    managed_rule_set {
      type    = each.value.managed_rules.managed_rule_set.type
      version = each.value.managed_rules.managed_rule_set.version
      rule_group_override {
        rule_group_name = each.value.managed_rules.managed_rule_set.rule_group_override.rule_group_name
        rule {
          id      = each.value.managed_rules.managed_rule_set.rule_group_override.rule.id
          enabled = each.value.managed_rules.managed_rule_set.rule_group_override.rule.enabled
          action  = each.value.managed_rules.managed_rule_set.rule_group_override.rule.action
        }
      }
    }
  }
}
