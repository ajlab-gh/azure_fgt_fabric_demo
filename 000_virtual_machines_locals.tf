locals {

  vm_image = {
    "client" = {
      publisher = "almalinux"
      offer     = "almalinux"
      vm_size   = "Standard_F2s_v2"
      version   = "latest"
      sku       = "8-gen2"
    },
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
      sku       = "fortinet_fg-vm"
    },
    "fwb" = {
      publisher = "fortinet"
      offer     = "fortinet_fortiweb-vm_v5"
      vm_size   = "Standard_F2s_v2"
      version   = "latest"
      sku       = "fortinet_fw-vm_payg_v2"
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

      custom_data = base64encode(templatefile("cloud-init/fgt.tpl", {
        var_host_name               = "${var.prefix}-fgt"
        var_vnet_address_prefix     = azurerm_virtual_network.virtual_network["${var.prefix}-vnet"].address_space[0]
        var_external_subnet_gateway = cidrhost(azurerm_subnet.subnet["${var.prefix}-external"].address_prefixes[0], 1)
        var_internal_subnet_gateway = cidrhost(azurerm_subnet.subnet["${var.prefix}-internal"].address_prefixes[0], 1)
        var_ipconfig1               = azurerm_network_interface.network_interface["${var.prefix}-fgt-nic-ext"].private_ip_address
        var_port1_netmask           = cidrnetmask(azurerm_subnet.subnet["${var.prefix}-external"].address_prefixes[0])
        var_port2_ip                = azurerm_network_interface.network_interface["${var.prefix}-fgt-nic-int"].private_ip_address
        var_port2_netmask           = cidrnetmask(azurerm_subnet.subnet["${var.prefix}-internal"].address_prefixes[0])
        var_server_mappedip         = azurerm_network_interface.network_interface["${var.prefix}-server-nic"].private_ip_address
        var_license_file            = var.license
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
    "${var.prefix}-fwb" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name = "${var.prefix}-fwb"
      size = local.vm_image["fwb"].vm_size

      disable_password_authentication = "false"
      allow_extension_operations      = false

      admin_username = random_pet.admin_username.id
      admin_password = random_password.admin_password.result

      custom_data = base64encode(
        templatefile("cloud-init/fwb.tpl", {
          var_hostname                = "${var.prefix}-fwb"
          var_vnet_address_prefix     = azurerm_virtual_network.virtual_network["${var.prefix}-vnet"].address_space[0]
          var_internal_subnet_gateway = cidrhost(azurerm_subnet.subnet["${var.prefix}-internal"].address_prefixes[0], 1)
          var_server_mappedip         = azurerm_network_interface.network_interface["${var.prefix}-server-nic"].private_ip_address
          var_admin_username          = random_pet.admin_username.id
          var_admin_password          = random_password.admin_password.result
          var_prefix                  = var.prefix
          var_location                = local.location
          var_sn2IPfwbA               = azurerm_network_interface.network_interface["${var.prefix}-fwb-nic-int"].private_ip_address
          var_fgtp2                   = azurerm_network_interface.network_interface["${var.prefix}-fgt-nic-int"].private_ip_address
          var_ipconfig1               = azurerm_network_interface.network_interface["${var.prefix}-fwb-nic-ext"].private_ip_address
          var_ipconfig2               = azurerm_network_interface.network_interface["${var.prefix}-fwb-nic-ext"].ip_configuration[1].private_ip_address
          var_ipconfig3               = azurerm_network_interface.network_interface["${var.prefix}-fwb-nic-ext"].ip_configuration[2].private_ip_address
          var_ipconfig4               = azurerm_network_interface.network_interface["${var.prefix}-fwb-nic-ext"].ip_configuration[3].private_ip_address
        })
      )

      network_interface_ids = [
        azurerm_network_interface.network_interface["${var.prefix}-fwb-nic-ext"].id,
        azurerm_network_interface.network_interface["${var.prefix}-fwb-nic-int"].id
      ]

      identity_type = "SystemAssigned"

      os_disk = {
        name                 = "${var.prefix}-fwb-osdisk"
        caching              = "ReadWrite"
        create_option        = "FromImage"
        storage_account_type = "Standard_LRS"
      }

      plan_publisher = local.vm_image["fwb"].publisher
      plan_product   = local.vm_image["fwb"].offer
      plan_name      = local.vm_image["fwb"].sku

      source_image_reference_publisher = local.vm_image["fwb"].publisher
      source_image_reference_offer     = local.vm_image["fwb"].offer
      source_image_reference_version   = local.vm_image["fwb"].version
      source_image_reference_sku       = local.vm_image["fwb"].sku

      identity_type = "SystemAssigned"

      tags_ComputeType = "fwb"
    },
    "${var.prefix}-client" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name = "${var.prefix}-client"
      size = local.vm_image["client"].vm_size

      disable_password_authentication = "false"
      allow_extension_operations      = false

      admin_username = random_pet.admin_username.id
      admin_password = random_password.admin_password.result

      custom_data = base64encode(
        templatefile("cloud-init/client.tpl", {
          var_fgt-DVWAURL        = local.attack_targets.fgt.DVWAURL
          var_fgt-JUICESHOPURL   = local.attack_targets.fgt.JUICESHOPURL
          var_fgt-PETSTOREURL    = local.attack_targets.fgt.PETSTOREURL
          var_fgt-BANKURL        = local.attack_targets.fgt.BANKURL
          var_fwb-DVWAURL        = local.attack_targets.fwb.DVWAURL
          var_fwb-JUICESHOPURL   = local.attack_targets.fwb.JUICESHOPURL
          var_fwb-PETSTOREURL    = local.attack_targets.fwb.PETSTOREURL
          var_fwb-BANKURL        = local.attack_targets.fwb.BANKURL
          var_azfw-DVWAURL       = local.attack_targets.azfw.DVWAURL
          var_azfw-JUICESHOPURL  = local.attack_targets.azfw.JUICESHOPURL
          var_azfw-PETSTOREURL   = local.attack_targets.azfw.PETSTOREURL
          var_azfw-BANKURL       = local.attack_targets.azfw.BANKURL
          var_appgw-DVWAURL      = local.attack_targets.appgw.DVWAURL
          var_appgw-JUICESHOPURL = local.attack_targets.appgw.JUICESHOPURL
          var_appgw-PETSTOREURL  = local.attack_targets.appgw.PETSTOREURL
          var_appgw-BANKURL      = local.attack_targets.appgw.BANKURL
        })
      )
      network_interface_ids = [azurerm_network_interface.network_interface["${var.prefix}-client-nic"].id]

      identity_type = "SystemAssigned"

      os_disk = {
        name                 = "${var.prefix}-client-osdisk"
        caching              = "ReadWrite"
        create_option        = "FromImage"
        storage_account_type = "Standard_LRS"
      }

      plan_publisher = local.vm_image["client"].publisher
      plan_product   = local.vm_image["client"].offer
      plan_name      = local.vm_image["client"].sku

      source_image_reference_publisher = local.vm_image["client"].publisher
      source_image_reference_offer     = local.vm_image["client"].offer
      source_image_reference_version   = local.vm_image["client"].version
      source_image_reference_sku       = local.vm_image["client"].sku

      identity_type = "SystemAssigned"

      tags_ComputeType = "client"
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
        templatefile("cloud-init/server.tpl", {})
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

  managed_disks = {
    "${var.prefix}-fwb-datadisk" = {
      name                 = "${var.prefix}-fwb-datadisk"
      resource_group_name  = azurerm_resource_group.resource_group[local.resource_group_name].name
      location             = azurerm_resource_group.resource_group[local.resource_group_name].location
      storage_account_type = "Standard_LRS"
      create_option        = "Empty"
      disk_size_gb         = 30
    }
  }

  virtual_machine_data_disk_attachments = {
    disk1 = {
      virtual_machine_id = azurerm_linux_virtual_machine.linux_virtual_machine["${var.prefix}-fwb"].id
      managed_disk_id    = azurerm_managed_disk.managed_disk["${var.prefix}-fwb-datadisk"].id
      lun                = 0
      caching            = "ReadWrite"
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
    },
    "${var.prefix}-fwb-pip1" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name              = "${var.prefix}-fwb-pip1"
      allocation_method = "Static"
      sku               = "Standard"
      domain_name_label = lower("${var.prefix}-fwb1")
    },
    "${var.prefix}-fwb-pip2" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name              = "${var.prefix}-fwb-pip2"
      allocation_method = "Static"
      sku               = "Standard"
      domain_name_label = lower("${var.prefix}-fwb2")
    },
    "${var.prefix}-fwb-pip3" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name              = "${var.prefix}-fwb-pip3"
      allocation_method = "Static"
      sku               = "Standard"
      domain_name_label = lower("${var.prefix}-fwb3")
    },
    "${var.prefix}-fwb-pip4" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name              = "${var.prefix}-fwb-pip4"
      allocation_method = "Static"
      sku               = "Standard"
      domain_name_label = lower("${var.prefix}-fwb4")
    },
    "${var.prefix}-appgw-pip1" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name              = "${var.prefix}-appgw-pip1"
      allocation_method = "Static"
      sku               = "Standard"
      domain_name_label = lower("${var.prefix}-appgw1")
    },
    "${var.prefix}-azfw-pip1" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name              = "${var.prefix}-azfw-pip1"
      allocation_method = "Static"
      sku               = "Standard"
      domain_name_label = lower("${var.prefix}-azfw1")
    },
    "${var.prefix}-client-pip" = {
      resource_group_name = azurerm_resource_group.resource_group[local.resource_group_name].name
      location            = azurerm_resource_group.resource_group[local.resource_group_name].location

      name              = "${var.prefix}-client-pip"
      allocation_method = "Static"
      sku               = "Standard"
      domain_name_label = lower("${var.prefix}-client")
    }
  }
}
