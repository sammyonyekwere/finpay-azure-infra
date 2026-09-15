# Module: cache

Source: `modules/cache/`

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Type | Required | Description |
|---|---|---|---|
| `location` | `string` | yes | Azure region |
| `resource_group_name` | `string` | yes | Resource group to deploy into |
| `name_prefix` | `string` | yes | Prefix used in resource names (not currently used in the Redis resource name itself — see note) |
| `private_endpoints_subnet_id` | `string` | yes | Subnet for the private endpoint (from `modules/networking`) |
| `private_dns_zone` | `string` | yes | Private DNS zone ID for `privatelink.redis.cache.windows.net` (from `modules/networking`) |

## Outputs

| Name | Description |
|---|---|
| `redis_hostname` | Hostname of the Redis cache |
| `redis_primary_access_key` | **Sensitive.** Primary access key |

## Resources

- `azurerm_redis_cache.main` — `Standard` SKU, capacity `2`, TLS 1.2 minimum,
  `non_ssl_port_enabled = false`, `public_network_access_enabled = false`
- `azurerm_private_endpoint.redis` — connects into `private_endpoints_subnet_id`,
  registered into `private_dns_zone`

## Known naming issue

`azurerm_redis_cache.main.name` is hardcoded to `"redis-cache"` rather than using
`name_prefix` — Redis cache names must be globally unique across Azure, so this will
collide if more than one environment/subscription combination tries to create it. Worth
fixing to `"redis-${var.name_prefix}"` before adding a second environment that shares a
subscription's DNS namespace.
<!-- END_TF_DOCS -->
