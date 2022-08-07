# <Hetzner>

<Hetzner> hetzner for Gitpod testing

<!-- toc -->

- [Terraform Documentation](#terraform-documentation)
  * [Requirements](#requirements)
  * [Providers](#providers)
  * [Modules](#modules)
  * [Resources](#resources)
  * [Inputs](#inputs)
  * [Outputs](#outputs)

<!-- tocstop -->

# Terraform Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | >= 1.0.0, < 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | >= 1.0.0, < 2.0.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [hcloud_load_balancer.load_balancer](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer) | resource |
| [hcloud_load_balancer_service.http](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_service) | resource |
| [hcloud_load_balancer_service.https](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_service) | resource |
| [hcloud_load_balancer_target.nodes](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_target) | resource |
| [hcloud_network.network](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network) | resource |
| [hcloud_network_subnet.network-subnet](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network_subnet) | resource |
| [hcloud_placement_group.kubernetes](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/placement_group) | resource |
| [hcloud_server.node](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server) | resource |
| [hcloud_ssh_key.terraform](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/ssh_key) | resource |
| [time_sleep.servers](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_enabled"></a> [dns\_enabled](#input\_dns\_enabled) | Common variables | `any` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | n/a | `any` | n/a | yes |
| <a name="input_enable_airgapped"></a> [enable\_airgapped](#input\_enable\_airgapped) | n/a | `any` | n/a | yes |
| <a name="input_enable_external_database"></a> [enable\_external\_database](#input\_enable\_external\_database) | n/a | `any` | n/a | yes |
| <a name="input_enable_external_registry"></a> [enable\_external\_registry](#input\_enable\_external\_registry) | n/a | `any` | n/a | yes |
| <a name="input_enable_external_storage"></a> [enable\_external\_storage](#input\_enable\_external\_storage) | n/a | `any` | n/a | yes |
| <a name="input_http_proxy"></a> [http\_proxy](#input\_http\_proxy) | n/a | `any` | n/a | yes |
| <a name="input_https_proxy"></a> [https\_proxy](#input\_https\_proxy) | n/a | `any` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | n/a | `any` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Hetzner-specific variables | `any` | n/a | yes |
| <a name="input_name_format"></a> [name\_format](#input\_name\_format) | n/a | `any` | n/a | yes |
| <a name="input_name_format_global"></a> [name\_format\_global](#input\_name\_format\_global) | n/a | `any` | n/a | yes |
| <a name="input_no_proxy"></a> [no\_proxy](#input\_no\_proxy) | n/a | `any` | n/a | yes |
| <a name="input_proxy_trusted_ca"></a> [proxy\_trusted\_ca](#input\_proxy\_trusted\_ca) | n/a | `any` | n/a | yes |
| <a name="input_workspace_name"></a> [workspace\_name](#input\_workspace\_name) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_issuer"></a> [cert\_manager\_issuer](#output\_cert\_manager\_issuer) | n/a |
| <a name="output_cert_manager_secret"></a> [cert\_manager\_secret](#output\_cert\_manager\_secret) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_database"></a> [database](#output\_database) | n/a |
| <a name="output_domain_nameservers"></a> [domain\_nameservers](#output\_domain\_nameservers) | n/a |
| <a name="output_external_dns_secrets"></a> [external\_dns\_secrets](#output\_external\_dns\_secrets) | n/a |
| <a name="output_external_dns_settings"></a> [external\_dns\_settings](#output\_external\_dns\_settings) | n/a |
| <a name="output_k8s_connection"></a> [k8s\_connection](#output\_k8s\_connection) | n/a |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | n/a |
| <a name="output_load_balancer_address"></a> [load\_balancer\_address](#output\_load\_balancer\_address) | n/a |
| <a name="output_node_list"></a> [node\_list](#output\_node\_list) | n/a |
| <a name="output_proxy_settings"></a> [proxy\_settings](#output\_proxy\_settings) | n/a |
| <a name="output_region"></a> [region](#output\_region) | n/a |
| <a name="output_registry"></a> [registry](#output\_registry) | n/a |
| <a name="output_storage"></a> [storage](#output\_storage) | n/a |
<!-- END_TF_DOCS -->
