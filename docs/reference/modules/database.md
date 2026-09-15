# Module: database

Source: `modules/database/`

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Type | Required | Description |
|---|---|---|---|
| `name_prefix` | `string` | yes | Prefix used in resource names |
| `resource_group_name` | `string` | yes | Resource group to deploy into |
| `location` | `string` | yes | Azure region |
| `administrator_login` | `string` | yes | MySQL admin username |
| `administrator_passwrd` | `string` | yes | **Sensitive.** MySQL admin password |
| `mysql_subnet_id` | `string` | yes | Delegated subnet ID (from `modules/networking`) |
| `mysql_private_dns_zone_id` | `string` | yes | Private DNS zone ID (from `modules/networking`) |
| `storage_gb` | `string` | yes | Storage size in GB |
| `sku_name` | `string` | yes | MySQL Flexible Server SKU tier |

## Outputs

| Name | Description |
|---|---|
| `server_fqdn` | FQDN of the MySQL Flexible Server |

## Resources

- `azurerm_mysql_flexible_server.main` — version `8.0.21`, VNet-injected (no public
  endpoint), `auto_grow_enabled = true`, `backup_retention_days = 7`
- `azurerm_mysql_flexible_database.main` — `utf8mb4` / `utf8mb4_0900_ai_ci`
- `azurerm_mysql_flexible_server_configuration.example` — sets `interactive_timeout = ON`
  (resource is named `example`; functional, name is just a leftover)
<!-- END_TF_DOCS -->
