# Infrastructure

Provision infrastructure to deploy a Gitpod instance

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

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud"></a> [cloud](#input\_cloud) | n/a | `any` | n/a | yes |
| <a name="input_dns_enabled"></a> [dns\_enabled](#input\_dns\_enabled) | n/a | `any` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | n/a | `any` | n/a | yes |
| <a name="input_enable_airgapped"></a> [enable\_airgapped](#input\_enable\_airgapped) | n/a | `any` | n/a | yes |
| <a name="input_enable_external_database"></a> [enable\_external\_database](#input\_enable\_external\_database) | n/a | `any` | n/a | yes |
| <a name="input_enable_external_registry"></a> [enable\_external\_registry](#input\_enable\_external\_registry) | n/a | `any` | n/a | yes |
| <a name="input_enable_external_storage"></a> [enable\_external\_storage](#input\_enable\_external\_storage) | n/a | `any` | n/a | yes |
| <a name="input_name_format"></a> [name\_format](#input\_name\_format) | n/a | `any` | n/a | yes |
| <a name="input_name_format_global"></a> [name\_format\_global](#input\_name\_format\_global) | n/a | `any` | n/a | yes |
| <a name="input_workspace_name"></a> [workspace\_name](#input\_workspace\_name) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_issuer"></a> [cert\_manager\_issuer](#output\_cert\_manager\_issuer) | n/a |
| <a name="output_cert_manager_secret"></a> [cert\_manager\_secret](#output\_cert\_manager\_secret) | n/a |
| <a name="output_cert_manager_settings"></a> [cert\_manager\_settings](#output\_cert\_manager\_settings) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_database"></a> [database](#output\_database) | n/a |
| <a name="output_domain_nameservers"></a> [domain\_nameservers](#output\_domain\_nameservers) | n/a |
| <a name="output_external_dns_secrets"></a> [external\_dns\_secrets](#output\_external\_dns\_secrets) | n/a |
| <a name="output_external_dns_settings"></a> [external\_dns\_settings](#output\_external\_dns\_settings) | n/a |
| <a name="output_k8s_connection"></a> [k8s\_connection](#output\_k8s\_connection) | n/a |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | n/a |
| <a name="output_region"></a> [region](#output\_region) | n/a |
| <a name="output_registry"></a> [registry](#output\_registry) | n/a |
| <a name="output_storage"></a> [storage](#output\_storage) | n/a |
<!-- END_TF_DOCS -->
