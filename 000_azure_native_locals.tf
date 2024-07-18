locals {
  firewalls = {
    "${var.prefix}-azfw" = {
      name                = "${var.prefix}-azfw"
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location
      sku_name            = "AZFW_VNet"
      sku_tier            = "Premium"
      firewall_policy_id  = azurerm_firewall_policy.firewall_policy["${var.prefix}-azfw-policy"].id

      ip_configurations = [
        {
          name                 = "configuration1"
          subnet_id            = azurerm_subnet.subnet["AzureFirewallSubnet"].id
          public_ip_address_id = azurerm_public_ip.public_ip["${var.prefix}-azfw-pip1"].id
        }
      ]
    }
  }

  firewall_policies = {
    "${var.prefix}-azfw-policy" = {
      name                     = "${var.prefix}-azfw-policy"
      resource_group_name      = azurerm_resource_group.resource_group[local.resource_group_name].name
      location                 = azurerm_resource_group.resource_group[local.resource_group_name].location
      threat_intelligence_mode = "Deny"
      sku                      = "Premium"
      intrusion_detection = {
        mode = "Deny"
      }
    }
  }
  include_application_rule_collections = true
  include_nat_rule_collections         = true
  include_network_rule_collections     = true

  firewall_policy_rule_collection_groups = {
    "${var.prefix}-collection-group" = {
      name               = "${var.prefix}-collection-group"
      firewall_policy_id = azurerm_firewall_policy.firewall_policy["${var.prefix}-azfw-policy"].id
      priority           = 100

      application_rule_collections = local.include_application_rule_collections ? [{
        name     = "appRuleCollection1"
        priority = 100
        action   = "Allow"
        rules = [
          {
            name              = "appRule1"
            source_addresses  = [azurerm_subnet.subnet["${var.prefix}-server"].address_prefixes[0]]
            destination_fqdns = ["www.google.com"]
            protocols = [
              {
                type = "Http",
                port = 80
              },
              {
                type = "Https",
                port = 443
              }
            ]
          }
        ]
      }] : []

      network_rule_collections = local.include_network_rule_collections ? [{
        name     = "netRuleCollection1"
        priority = 200
        action   = "Allow"
        rules = [
          {
            name                  = "netRule1"
            protocols             = ["TCP"]
            source_addresses      = ["0.0.0.0/0"]
            destination_addresses = [azurerm_subnet.subnet["${var.prefix}-server"].address_prefixes[0]]
            destination_ports     = ["22", "80", "8001", "8002", "8003", "8004"]
          }
        ]
      }] : []

      nat_rule_collections = local.include_nat_rule_collections ? [{
        name     = "natRuleCollection1"
        priority = 300
        action   = "Dnat"
        rules = [
          {
            name                = "natRule1"
            protocols           = ["TCP"]
            source_addresses    = ["0.0.0.0/0"]
            destination_address = azurerm_public_ip.public_ip["${var.prefix}-azfw-pip1"].ip_address
            destination_ports   = ["8001"]
            translated_address  = azurerm_network_interface.network_interface["${var.prefix}-server-nic"].ip_configuration[0].private_ip_address
            translated_port     = "1000"
          },
          {
            name                = "natRule2"
            protocols           = ["TCP"]
            source_addresses    = ["0.0.0.0/0"]
            destination_address = azurerm_public_ip.public_ip["${var.prefix}-azfw-pip1"].ip_address
            destination_ports   = ["8002"]
            translated_address  = azurerm_network_interface.network_interface["${var.prefix}-server-nic"].ip_configuration[0].private_ip_address
            translated_port     = "3000"
          },
          {
            name                = "natRule3"
            protocols           = ["TCP"]
            source_addresses    = ["0.0.0.0/0"]
            destination_address = azurerm_public_ip.public_ip["${var.prefix}-azfw-pip1"].ip_address
            destination_ports   = ["8003"]
            translated_address  = azurerm_network_interface.network_interface["${var.prefix}-server-nic"].ip_configuration[0].private_ip_address
            translated_port     = "4000"
          },
          {
            name                = "natRule4"
            protocols           = ["TCP"]
            source_addresses    = ["0.0.0.0/0"]
            destination_address = azurerm_public_ip.public_ip["${var.prefix}-azfw-pip1"].ip_address
            destination_ports   = ["8004"]
            translated_address  = azurerm_network_interface.network_interface["${var.prefix}-server-nic"].ip_configuration[0].private_ip_address
            translated_port     = "2000"
          }
        ]
      }] : []
    }
  }

  application_gateways = {
    "${var.prefix}-appgw" = {
      name                = "${var.prefix}-appgw"
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      firewall_policy_id  = azurerm_web_application_firewall_policy.web_application_firewall_policy["${var.prefix}-wafv2-policy"].id

      sku = {
        name     = "WAF_v2"
        tier     = "WAF_v2"
        capacity = 2
      }

      gateway_ip_configuration = {
        name      = "appGatewayIpConfig"
        subnet_id = azurerm_subnet.subnet["${var.prefix}-appgw"].id
      }

      frontend_port = [
        {
          name = "port8001"
          port = 8001
        },
        {
          name = "port8002"
          port = 8002
        },
        {
          name = "port8003"
          port = 8003
        },
        {
          name = "port8004"
          port = 8004
        }
      ]

      frontend_ip_configuration = {
        name                 = "appGatewayFrontendIP"
        public_ip_address_id = azurerm_public_ip.public_ip["${var.prefix}-appgw-pip1"].id
      }

      backend_address_pool = {
        name         = "appGatewayBackendPool"
        ip_addresses = [azurerm_network_interface.network_interface["${var.prefix}-server-nic"].private_ip_address]
      }

      backend_http_settings = [
        {
          name                  = "appGatewayBackendHttpSettings1"
          cookie_based_affinity = "Disabled"
          port                  = 1000
          protocol              = "Http"
          request_timeout       = 20
        },
        {
          name                  = "appGatewayBackendHttpSettings2"
          cookie_based_affinity = "Disabled"
          port                  = 3000
          protocol              = "Http"
          request_timeout       = 20
        },
        {
          name                  = "appGatewayBackendHttpSettings3"
          cookie_based_affinity = "Disabled"
          port                  = 4000
          protocol              = "Http"
          request_timeout       = 20
        },
        {
          name                  = "appGatewayBackendHttpSettings4"
          cookie_based_affinity = "Disabled"
          port                  = 2000
          protocol              = "Http"
          request_timeout       = 20
        }
      ]

      http_listener = [
        {
          name                           = "listener1"
          frontend_ip_configuration_name = "appGatewayFrontendIP"
          frontend_port_name             = "port8001"
          protocol                       = "Http"
        },
        {
          name                           = "listener2"
          frontend_ip_configuration_name = "appGatewayFrontendIP"
          frontend_port_name             = "port8002"
          protocol                       = "Http"
        },
        {
          name                           = "listener3"
          frontend_ip_configuration_name = "appGatewayFrontendIP"
          frontend_port_name             = "port8003"
          protocol                       = "Http"
        },
        {
          name                           = "listener4"
          frontend_ip_configuration_name = "appGatewayFrontendIP"
          frontend_port_name             = "port8004"
          protocol                       = "Http"
        }
      ]

      request_routing_rule = [
        {
          name                       = "rule1"
          priority                   = 1
          rule_type                  = "Basic"
          http_listener_name         = "listener1"
          backend_address_pool_name  = "appGatewayBackendPool"
          backend_http_settings_name = "appGatewayBackendHttpSettings1"
        },
        {
          name                       = "rule2"
          priority                   = 2
          rule_type                  = "Basic"
          http_listener_name         = "listener2"
          backend_address_pool_name  = "appGatewayBackendPool"
          backend_http_settings_name = "appGatewayBackendHttpSettings2"
        },
        {
          name                       = "rule3"
          priority                   = 3
          rule_type                  = "Basic"
          http_listener_name         = "listener3"
          backend_address_pool_name  = "appGatewayBackendPool"
          backend_http_settings_name = "appGatewayBackendHttpSettings3"
        },
        {
          name                       = "rule4"
          priority                   = 4
          rule_type                  = "Basic"
          http_listener_name         = "listener4"
          backend_address_pool_name  = "appGatewayBackendPool"
          backend_http_settings_name = "appGatewayBackendHttpSettings4"
        }
      ]
    }
  }

  web_application_firewall_policies = {
    "${var.prefix}-wafv2-policy" = {
      name                = "${var.prefix}-wafv2-policy"
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name

      policy_settings = {
        enabled                     = true
        mode                        = "Prevention"
        request_body_check          = true
        file_upload_limit_in_mb     = 100
        max_request_body_size_in_kb = 128
      }

      custom_rules = {
        name      = "Rule1"
        priority  = 1
        rule_type = "MatchRule"
        action    = "Block"

        match_conditions = {
          match_variables = {
            variable_name = "RequestHeaders"
            selector      = "UserAgent"
          }
          operator           = "Contains"
          negation_condition = false
          match_values       = ["Windows"]
        }
      }

      managed_rules = {
        managed_rule_set = {
          type    = "OWASP"
          version = "3.2"
          rule_group_override = {
            rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
            rule = {
              id      = "920440"
              enabled = true
              action  = "Block"
            }
          }
        }
      }
    }
  }
}
