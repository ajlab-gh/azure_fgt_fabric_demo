# Azure FortiGate-VM Fabric Integration Demo

## Introduction

This Infrastructure as Code (IaC) template deploys a FortiGate-VM and a vulnerable workload into Azure. Its primary purpose is to integrate with an on-premise environment over IPSec VPN and join a Fortinet Fabric, showcasing cloud integrations.

### Design

This IaC solution deploys a single pre-configured FortiGate-VM along with a server system running applications within Docker. The design simulates typical web service publishing and Site-to-Site communications over VPN. It is preconfigured to allow users to target the server via the Internet or on-premise, providing a realistic user experience.

This setup enables testing with minimal changes to the infrastructure or configurations.

### Containers running on the server

- Damn Vulnerable Web Application (DVWA)
- Juiceshop
- Petstore
- Demo-Web-App (benoitbmtl)

### Deployment

To get started with this IaC solution, follow these steps:

1. Clone the repository: `git clone https://github.com/AJLab-GH/azure_fgt_fabric_demo.git`
2. Initialize Terraform: `cd azure_fgt_fabric_demo && terraform init`
3. Apply the configuration: `terraform apply`

### Choose your Licensing Type

The default licensing model used for this deployment is Pay-as-you-go (Payg). If you would like to use Bring-your-own-license (BYOL) or FortiFlex, please set the relevant variable values accordingly:

```text
variable "license_type" {
  description = "Provide the license type for FortiGate-VM Instances, either byol or payg."
  type = string
  default = "byol"

    validation {
    condition     = contains(["byol", "payg"], var.license_type)
    error_message = "The license_type variable must be either 'byol' or 'payg'."
  }
}```

by default when the "license_type": "byol" is selected, this deployment expect a file called "license.lic" in the root directory with the contents of your license file. If you would prefer to use FortiFlex, simply add your Flex_Token to this file and change the "license_format" variable to "token"

```text
variable "license_format" {
  description = "Provide the license type for FortiGate-VM Instances, either token or file."
  type = string
  default = "token"

    validation {
      condition = contains(["token", "file"], var.license_format)
      error_message = "You must define whether you are providing a FortiFlex Token, or License File for License Content in BYOL"
    }
}```

### Deployment Outputs

To view the deployment outputs, including your username and password, run: `terraform output -json`

### Style Guide

Any contributor looking to collaborate on this project should follow the Terragrunt Style Guide, along with these supplementary guidances, following these guidelines will help maintain consistency, reduce errors, and improve overall code quality.

[Terragrunt Style Guide](https://docs.gruntwork.io/guides/style/terraform-style-guide)

**Naming Convention**: When defining resources, the `symbolicName` should represent the `resource_type` minus any service provider prefix such as `azurerm_`.

  Example:

```hcl
resource "azurerm_subnet" "subnet" {
  # configuration details
}
```

**Iteration with for_each**: Use 'for_each' to iterate over resources, setting it to a local variable that represents the collection of those resources. The local should be the symbolicName with an "s" at the end to denote plurality.

Example:

```hcl
resource "azurerm_subnet" "subnet" {
  for_each = local.subnets
  name     = each.value.name
  # other configurations
}
```

**Attribute Access**: Access attributes for each instance within a 'for_each' using the 'each.value' prefix

**Outputs**: should be named after the locals they reference, ensuring consistency across the module. Additionally, outputs should conditionally return a value based on the enable_output variable to control their creation.

Example:

```hcl
output "subnets" {
  value = var.enable_output ? azurerm_subnet.subnet[*] : null
}
```
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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_output"></a> [enable\_output](#input\_enable\_output) | Enable/Disable output | `bool` | `false` | no |
| <a name="input_license"></a> [license](#input\_license) | Add the name of your license file for BYOL deployment | `string` | `"license.lic"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The Prefix to append to your resources | `string` | n/a | yes |
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
