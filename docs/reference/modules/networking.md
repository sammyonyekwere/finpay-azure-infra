# Module: networking

Source: `modules/networking/`

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Type | Default | Required | Description |
|---|---|---|---|---|
| `name_prefix` | `string` | — | yes | Prefix used in resource names |
| `vnet_address_space` | `string` | `"10.0.0.0/16"` | no | CIDR for the VNet |
| `location` | `string` | — | yes | Azure region |
| `resource_group_name` | `string` | — | yes | Resource group to deploy into |

## Outputs

| Name | Description |
|---|---|
| `container_apps_subnet_id` | ID of `snet-container-apps` (delegated to `Microsoft.App/environments`) |
| `mysql_private_dns_zone_id` | ID of the private DNS zone `<name_prefix>.private.mysql.database.azure.com` |
| `mysql_subnet_id` | ID of `snet-mysql` (delegated to `Microsoft.DBforMySQL/flexibleServers`) |
| `private_endpoints_subnet_id` | ID of `snet-private-endpoints` (no delegation) |
| `redis_private_dns_zone_id` | ID of the private DNS zone `<name_prefix>.privatelink.redis.cache.windows.net` |

## Resources

- `azurerm_virtual_network.main`
- `azurerm_subnet.container_apps` — `cidrsubnet(vnet_address_space, 7, 0)`
- `azurerm_subnet.mysql` — `cidrsubnet(vnet_address_space, 12, 0)`
- `azurerm_subnet.private_endpoints` — `cidrsubnet(vnet_address_space, 12, 1)`
- `azurerm_private_dns_zone.private_mysql` + `azurerm_private_dns_zone_virtual_network_link.vnet_mysql`
- `azurerm_private_dns_zone.privatelink_redis` + `azurerm_private_dns_zone_virtual_network_link.vnet_redis`
<!-- END_TF_DOCS -->

See [explanation: network-design](../../explanation/network-design.md) for the subnet
sizing and delegation rationale.
