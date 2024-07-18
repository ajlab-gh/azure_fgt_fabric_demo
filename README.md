
# Fortinet Competitive Environment Reference Architecture

## Introduction

As you explore the world of network security, it can be overwhelming to choose the right solutions for your unique needs. This repository provides an infrastructure as code (IaC) solution that deploys and preconfigures competing products from leading vendors, including FortiGate and FortiWeb, Azure Firewall Premium, and Azure Application Gateway with WAF_V2.

Our goal is to provide a comprehensive environment where you can evaluate these solutions side by side, making it easier for you to decide which one best meets your requirements. This repository does not aim to promote or demote any specific product; instead, it serves as a neutral tool to facilitate your evaluation process.

### Design

This IaC solution deploys security components, including FortiGate-VM, FortiWeb-VM, Azure Firewall Premium, and Azure Application Gateway with WAF_V2. Each component is preconfigured to provide a comprehensive view of how these solutions work, and to highlight their use-cases.

In addition to the security components, the environment includes client and server systems with applications running within docker. This design simulates the typical flow for publishing web services, yet is preconfigured to allow for the targetting these applications along alternate paths, simplifying the testing and analysis of these security solutions.

In this way, testing can be accomplished without affecting the underlying infrastructure, streamlining the testing and validation of the security measures and their effectiveness in various use cases.

Containers running on client

- Darwin2

Containers running on server

- Damn Vulnerable Web Application (DVWA)
- Juiceshop
- Petstore
- Demo-Web-App (benoitbmtl)

### Network Diagram

![Detailed View](https://raw.githubusercontent.com/AJLab-GH/ftnt-demo/main/docs/CompetitiveEnv.PNG)

### Deployment

To get started with this IaC solution, follow these steps:

1. Clone the repository: `git clone https://github.com/AJLab-GH/ftnt-demo.git`
2. Initialize Terraform: `cd ftnt-demo && terraform init`
3. Apply the configuration: `terraform apply`

### Deployment Outputs

To view the deployment outputs, run: `terraform output -json`

### Evaluation and Comparison

Use this IaC solution as a starting point for your own evaluation and comparison of these competing products. We encourage you to explore each component's features, configurations, and performance characteristics by launching pre-configured sets of attacks where you can test the security features of each solution by attempting to exploit vulnerabilities in the demo applications to make an informed decision about which product best fits your needs.

Remember, the goal is not to promote or demote any specific product; it's to provide a comprehensive environment where you can evaluate and compare solutions side by side, making it easier for you to decide which one best meets your requirements.

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
| [azurerm_application_gateway.application_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/application_gateway) | resource |
| [azurerm_firewall.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/firewall) | resource |
| [azurerm_firewall_policy.firewall_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy_rule_collection_group.firewall_policy_rule_collection_group](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_linux_virtual_machine.linux_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.managed_disk](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/managed_disk) | resource |
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
| [azurerm_virtual_machine_data_disk_attachment.virtual_machine_data_disk_attachment](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_network.virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/virtual_network) | resource |
| [azurerm_web_application_firewall_policy.web_application_firewall_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.98.0/docs/resources/web_application_firewall_policy) | resource |
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
| <a name="output_application_gateways"></a> [application\_gateways](#output\_application\_gateways) | n/a |
| <a name="output_client_via_internet_connection_string"></a> [client\_via\_internet\_connection\_string](#output\_client\_via\_internet\_connection\_string) | Host to launch attacks from |
| <a name="output_disk_attachments"></a> [disk\_attachments](#output\_disk\_attachments) | n/a |
| <a name="output_firewall_policies"></a> [firewall\_policies](#output\_firewall\_policies) | n/a |
| <a name="output_firewall_policy_rule_collection_groups"></a> [firewall\_policy\_rule\_collection\_groups](#output\_firewall\_policy\_rule\_collection\_groups) | n/a |
| <a name="output_firewalls"></a> [firewalls](#output\_firewalls) | n/a |
| <a name="output_fortigate_connection_string"></a> [fortigate\_connection\_string](#output\_fortigate\_connection\_string) | This string represents the connection string for the Management of the FortiGate |
| <a name="output_fortiweb_connection_string"></a> [fortiweb\_connection\_string](#output\_fortiweb\_connection\_string) | This string represents the connection string for the Management of the FortiWeb |
| <a name="output_linux_virtual_machines"></a> [linux\_virtual\_machines](#output\_linux\_virtual\_machines) | n/a |
| <a name="output_managed_disks"></a> [managed\_disks](#output\_managed\_disks) | n/a |
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
