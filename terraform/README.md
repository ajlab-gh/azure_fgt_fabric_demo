# terraform

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.98.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.98.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.2 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.linux_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.network_interface](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.network_security_rule](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.fgt_managed_identity](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/role_assignment) | resource |
| [azurerm_route.route](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/route) | resource |
| [azurerm_route_table.route_table](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/route_table) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.subnet_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.subnet_route_table_association](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/virtual_network) | resource |
| [null_resource.initialize_dvwa](https://registry.terraform.io/providers/hashicorp/null/3.2.2/docs/resources/resource) | resource |
| [null_resource.marketplace_agreement](https://registry.terraform.io/providers/hashicorp/null/3.2.2/docs/resources/resource) | resource |
| [random_password.admin_password](https://registry.terraform.io/providers/hashicorp/random/3.6.1/docs/resources/password) | resource |
| [random_pet.admin_username](https://registry.terraform.io/providers/hashicorp/random/3.6.1/docs/resources/pet) | resource |
| [azurerm_subscription.primary](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_output"></a> [enable\_output](#input\_enable\_output) | Enable/Disable output | `bool` | `false` | no |
| <a name="input_license_file_location"></a> [license\_file\_location](#input\_license\_file\_location) | Add the name of your license file for BYOL deployment | `string` | `"../cloud-init/license.lic"` | no |
| <a name="input_license_format"></a> [license\_format](#input\_license\_format) | Provide the license type for FortiGate-VM Instances, either token or file. | `string` | `"file"` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | Provide the license type for FortiGate-VM Instances, either BYOL or PAYG. | `string` | `"payg"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The Prefix to append to your resources | `string` | n/a | yes |
| <a name="input_remote_gw"></a> [remote\_gw](#input\_remote\_gw) | Add the Peer IP for your Site to Site VPN | `string` | n/a | yes |
| <a name="input_virtual_network_cidr"></a> [virtual\_network\_cidr](#input\_virtual\_network\_cidr) | CIDR Notation for Virtual Network | `string` | `"10.20.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password) | Password for admin account |
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username) | Username for admin account |
| <a name="output_fortigate_connection_string"></a> [fortigate\_connection\_string](#output\_fortigate\_connection\_string) | This string represents the connection string for the Management of the FortiGate |
| <a name="output_linux_virtual_machines"></a> [linux\_virtual\_machines](#output\_linux\_virtual\_machines) | n/a |
| <a name="output_network_interfaces"></a> [network\_interfaces](#output\_network\_interfaces) | n/a |
| <a name="output_network_security_groups"></a> [network\_security\_groups](#output\_network\_security\_groups) | n/a |
| <a name="output_network_security_rules"></a> [network\_security\_rules](#output\_network\_security\_rules) | n/a |
| <a name="output_public_ips"></a> [public\_ips](#output\_public\_ips) | n/a |
| <a name="output_resource_groups"></a> [resource\_groups](#output\_resource\_groups) | n/a |
| <a name="output_route_tables"></a> [route\_tables](#output\_route\_tables) | n/a |
| <a name="output_routes"></a> [routes](#output\_routes) | n/a |
| <a name="output_subnet_network_security_group_associations"></a> [subnet\_network\_security\_group\_associations](#output\_subnet\_network\_security\_group\_associations) | n/a |
| <a name="output_subnet_route_table_associations"></a> [subnet\_route\_table\_associations](#output\_subnet\_route\_table\_associations) | n/a |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | n/a |
| <a name="output_virtual_networks"></a> [virtual\_networks](#output\_virtual\_networks) | n/a |
<!-- END_TF_DOCS -->
