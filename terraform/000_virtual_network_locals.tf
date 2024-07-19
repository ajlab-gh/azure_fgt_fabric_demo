locals {
  resource_group_name     = "${var.prefix}-rg"
  location                = "canadacentral"
  environment_tag         = "Fortinet Fabric Demo Env"
  virtual_network_name_01 = "${var.prefix}-vnet"

  resource_groups = {
    (local.resource_group_name) = {
      name     = local.resource_group_name
      location = local.location
      tags = {
        environment = local.environment_tag
      }
    }
  }

  virtual_networks = {
    (local.virtual_network_name_01) = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name          = local.virtual_network_name_01
      address_space = [var.virtual_network_cidr]
    }
  }

  subnets = {
    "${var.prefix}-external" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name

      name                 = "${var.prefix}-external"
      virtual_network_name = azurerm_virtual_network.virtual_network[local.virtual_network_name_01].name
      address_prefixes     = [cidrsubnet(azurerm_virtual_network.virtual_network[local.virtual_network_name_01].address_space[0], 8, 0)]
    },
    "${var.prefix}-internal" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name

      name                 = "${var.prefix}-internal"
      virtual_network_name = azurerm_virtual_network.virtual_network[local.virtual_network_name_01].name
      address_prefixes     = [cidrsubnet(azurerm_virtual_network.virtual_network[local.virtual_network_name_01].address_space[0], 8, 1)]
    },
    "${var.prefix}-server" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name

      name                 = "${var.prefix}-server"
      virtual_network_name = azurerm_virtual_network.virtual_network[local.virtual_network_name_01].name
      address_prefixes     = [cidrsubnet(azurerm_virtual_network.virtual_network[local.virtual_network_name_01].address_space[0], 8, 5)]
    }
  }

  network_interfaces = {
    "${var.prefix}-fgt-nic-ext" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name                          = "${var.prefix}-fgt-nic-ext"
      enable_ip_forwarding          = false
      enable_accelerated_networking = false

      ip_configurations = [
        {
          name                          = "ipconfig1"
          primary                       = true
          subnet_id                     = azurerm_subnet.subnet["${var.prefix}-external"].id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(azurerm_subnet.subnet["${var.prefix}-external"].address_prefixes[0], 10)
          public_ip_address_id          = azurerm_public_ip.public_ip["${var.prefix}-fgt-pip1"].id
        }
      ]
    },
    "${var.prefix}-fgt-nic-int" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name                          = "${var.prefix}-fgt-nic-int"
      enable_ip_forwarding          = true
      enable_accelerated_networking = false

      ip_configurations = [
        {
          name                          = "ipconfig1"
          primary                       = true
          subnet_id                     = azurerm_subnet.subnet["${var.prefix}-internal"].id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(azurerm_subnet.subnet["${var.prefix}-internal"].address_prefixes[0], 4)
          public_ip_address_id          = null

        }
      ]
    },
    "${var.prefix}-server-nic" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name                          = "${var.prefix}-server-nic"
      enable_ip_forwarding          = false
      enable_accelerated_networking = false

      ip_configurations = [
        {
          name                          = "ipconfig1"
          primary                       = true
          subnet_id                     = azurerm_subnet.subnet["${var.prefix}-server"].id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(azurerm_subnet.subnet["${var.prefix}-server"].address_prefixes[0], 4)
          public_ip_address_id          = null
        }
      ]
    }
  }
  network_security_groups = {
    "nsg-external" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name = "nsg-external"
    },
    "nsg-internal" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name = "nsg-internal"
    }
  }

  network_security_rules = {
    "nsgsr-external-ingress" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name

      name                        = "nsgsr-external-ingress"
      priority                    = 1000
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_ranges     = ["80", "443", "8443", "8001-8004", "65200-65535"]
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      network_security_group_name = azurerm_network_security_group.network_security_group["nsg-external"].name
    },
    "nsgsr-external-egress" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name

      name                        = "nsgsr-external-egress"
      priority                    = 1000
      direction                   = "Outbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_ranges     = ["80", "443"]
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      network_security_group_name = azurerm_network_security_group.network_security_group["nsg-external"].name
    },
    "nsgsr-internal-ingress" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name

      name                        = "nsgsr-internal-ingress"
      priority                    = 1000
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_ranges     = ["80", "443"]
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      network_security_group_name = azurerm_network_security_group.network_security_group["nsg-internal"].name
    },
    "nsgsr-internal-egress" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name

      name                        = "nsgsr-internal-egress"
      priority                    = 1000
      direction                   = "Outbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_ranges     = ["80", "443", "1000", "2000", "3000", "4000", "5000"]
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      network_security_group_name = azurerm_network_security_group.network_security_group["nsg-internal"].name
    }
  }

  subnet_network_security_group_associations = {
    "${var.prefix}-external" = {
      subnet_id                 = azurerm_subnet.subnet["${var.prefix}-external"].id
      network_security_group_id = azurerm_network_security_group.network_security_group["nsg-external"].id
    }
    "${var.prefix}-internal" = {
      subnet_id                 = azurerm_subnet.subnet["${var.prefix}-internal"].id
      network_security_group_id = azurerm_network_security_group.network_security_group["nsg-internal"].id
    }
    "${var.prefix}-server" = {
      subnet_id                 = azurerm_subnet.subnet["${var.prefix}-server"].id
      network_security_group_id = azurerm_network_security_group.network_security_group["nsg-external"].id
    }
  }

  route_tables = {
    "rt-protected" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name = "rt-protected"
    }
  }

  routes = {
    "udr-default" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name

      name                   = "rt-default"
      address_prefix         = "0.0.0.0/0"
      next_hop_in_ip_address = azurerm_network_interface.network_interface["${var.prefix}-fgt-nic-int"].private_ip_address
      next_hop_type          = "VirtualAppliance"
      route_table_name       = azurerm_route_table.route_table["rt-protected"].name
    }
  }

  subnet_route_table_associations = {
    "rt-protected" = {
      subnet_id      = azurerm_subnet.subnet["${var.prefix}-server"].id
      route_table_id = azurerm_route_table.route_table["rt-protected"].id
    }
  }
}
