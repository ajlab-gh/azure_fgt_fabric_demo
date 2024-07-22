locals {

  vm_image = {
    "server" = {
      publisher = "almalinux"
      offer     = "almalinux"
      vm_size   = "Standard_F2s_v2"
      version   = "latest"
      sku       = "8-gen2"
    },
    "fgt" = {
      publisher = "fortinet"
      offer     = "fortinet_fortigate-vm_v5"
      vm_size   = "Standard_F2s_v2"
      version   = "latest"
      sku       = var.license_type == "byol" ? "fortinet_fg-vm" : "fortinet_fg-vm_payg_2023"
    }
  }

  linux_virtual_machines = {
    "${var.prefix}-fgt" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name = "${var.prefix}-fgt"
      size = local.vm_image["fgt"].vm_size

      disable_password_authentication = "false"
      allow_extension_operations      = false

      admin_username = random_pet.admin_username.id
      admin_password = random_password.admin_password.result

      custom_data = base64encode(templatefile("../cloud-init/fgt.tpl", {
        var_host_name               = "${var.prefix}-fgt"
        var_vnet_address_prefix     = azurerm_virtual_network.virtual_network["${var.prefix}-vnet"].address_space[0]
        var_external_subnet_gateway = cidrhost(azurerm_subnet.subnet["${var.prefix}-external"].address_prefixes[0], 1)
        var_internal_subnet_gateway = cidrhost(azurerm_subnet.subnet["${var.prefix}-internal"].address_prefixes[0], 1)
        var_ipconfig1               = azurerm_network_interface.network_interface["${var.prefix}-fgt-nic-ext"].private_ip_address
        var_port1_netmask           = cidrnetmask(azurerm_subnet.subnet["${var.prefix}-external"].address_prefixes[0])
        var_port2_ip                = azurerm_network_interface.network_interface["${var.prefix}-fgt-nic-int"].private_ip_address
        var_port2_netmask           = cidrnetmask(azurerm_subnet.subnet["${var.prefix}-internal"].address_prefixes[0])
        var_server_mappedip         = azurerm_network_interface.network_interface["${var.prefix}-server-nic"].private_ip_address
        var_license_file            = var.license_file_location
        var_psksecret               = random_password.admin_password.result
        var_remote_gw               = var.remote_gw
        var_type                    = var.license_type
        var_format                  = var.license_format
      }))


      network_interface_ids = [
        azurerm_network_interface.network_interface["${var.prefix}-fgt-nic-ext"].id,
        azurerm_network_interface.network_interface["${var.prefix}-fgt-nic-int"].id
      ]

      identity_type = "SystemAssigned"

      os_disk = {
        name                 = "${var.prefix}-fgt-osdisk"
        caching              = "ReadWrite"
        create_option        = "FromImage"
        storage_account_type = "Standard_LRS"
      }

      plan_publisher = local.vm_image["fgt"].publisher
      plan_product   = local.vm_image["fgt"].offer
      plan_name      = local.vm_image["fgt"].sku

      source_image_reference_publisher = local.vm_image["fgt"].publisher
      source_image_reference_offer     = local.vm_image["fgt"].offer
      source_image_reference_version   = local.vm_image["fgt"].version
      source_image_reference_sku       = local.vm_image["fgt"].sku

      identity_type = "SystemAssigned"

      tags_ComputeType = "fgt"
    },
    "${var.prefix}-server" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name = "${var.prefix}-server"
      size = local.vm_image["server"].vm_size

      disable_password_authentication = "false"
      allow_extension_operations      = false

      admin_username = random_pet.admin_username.id
      admin_password = random_password.admin_password.result

      custom_data = base64encode(
        templatefile("../cloud-init/server.tpl", {})
      )

      network_interface_ids = [azurerm_network_interface.network_interface["${var.prefix}-server-nic"].id]

      identity_type = "SystemAssigned"

      os_disk = {
        name                 = "${var.prefix}-server-osdisk"
        caching              = "ReadWrite"
        create_option        = "FromImage"
        storage_account_type = "Standard_LRS"
      }

      plan_publisher = local.vm_image["server"].publisher
      plan_product   = local.vm_image["server"].offer
      plan_name      = local.vm_image["server"].sku

      source_image_reference_publisher = local.vm_image["server"].publisher
      source_image_reference_offer     = local.vm_image["server"].offer
      source_image_reference_version   = local.vm_image["server"].version
      source_image_reference_sku       = local.vm_image["server"].sku

      identity_type = "SystemAssigned"

      tags_ComputeType = "server"
    }
  }

  public_ips = {
    "${var.prefix}-fgt-pip1" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name              = "${var.prefix}-fgt-pip1"
      allocation_method = "Static"
      sku               = "Standard"
      domain_name_label = lower("${var.prefix}-fgt1")
    }
  }
}
