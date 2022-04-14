# Gitpod Self-Hosted Infrastructure

Self-hosted infrastructure for testing

<!-- toc -->

- [Supported Clouds](#supported-clouds)
- [Terraform Documentation](#terraform-documentation)
  * [Requirements](#requirements)
  * [Providers](#providers)
  * [Modules](#modules)
  * [Resources](#resources)
  * [Inputs](#inputs)
  * [Outputs](#outputs)

<!-- tocstop -->

# Supported Clouds

- Azure
- Azure (airgapped)

# Terraform Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0, < 4.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_infrastructure"></a> [infrastructure](#module\_infrastructure) | ./infrastructure | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_location"></a> [azure\_location](#input\_azure\_location) | Region to use | `string` | `"northeurope"` | no |
| <a name="input_cloud"></a> [cloud](#input\_cloud) | The cloud provider to deploy to | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name Gitpod should be installed to - if left blank, DNS is not configured | `string` | `null` | no |
| <a name="input_enable_airgapped"></a> [enable\_airgapped](#input\_enable\_airgapped) | If supported by the cloud provider, configure a cluster isolated from the public internet | `bool` | `false` | no |
| <a name="input_enable_external_database"></a> [enable\_external\_database](#input\_enable\_external\_database) | If supported by the cloud provider, use an external database | `bool` | `true` | no |
| <a name="input_enable_external_registry"></a> [enable\_external\_registry](#input\_enable\_external\_registry) | If supported by the cloud provider, use an external registry | `bool` | `true` | no |
| <a name="input_enable_external_storage"></a> [enable\_external\_storage](#input\_enable\_external\_storage) | If supported by the cloud provider, use an external storage | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_issuer"></a> [cert\_manager\_issuer](#output\_cert\_manager\_issuer) | n/a |
| <a name="output_cert_manager_secret"></a> [cert\_manager\_secret](#output\_cert\_manager\_secret) | n/a |
| <a name="output_cert_manager_settings"></a> [cert\_manager\_settings](#output\_cert\_manager\_settings) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_database"></a> [database](#output\_database) | n/a |
| <a name="output_domain_nameservers"></a> [domain\_nameservers](#output\_domain\_nameservers) | n/a |
| <a name="output_enable_airgapped"></a> [enable\_airgapped](#output\_enable\_airgapped) | n/a |
| <a name="output_external_dns_secrets"></a> [external\_dns\_secrets](#output\_external\_dns\_secrets) | n/a |
| <a name="output_external_dns_settings"></a> [external\_dns\_settings](#output\_external\_dns\_settings) | n/a |
| <a name="output_k8s_connection"></a> [k8s\_connection](#output\_k8s\_connection) | n/a |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | n/a |
| <a name="output_region"></a> [region](#output\_region) | n/a |
| <a name="output_registry"></a> [registry](#output\_registry) | n/a |
| <a name="output_storage"></a> [storage](#output\_storage) | n/a |
<!-- END_TF_DOCS -->
