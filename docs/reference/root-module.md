# Root module reference

Source: `main.tf`, `variables.tf`, `outputs.tf`, `providers.tf`, `versions.tf`.

## Requirements

| Name | Version |
|---|---|
| terraform | `>= 1.6.0, < 2.0.0` |
| azurerm | `~> 4.0` |
| random | `~> 3.6` |

Backend: `azurerm` (configured per-environment via `-backend-config=environments/<env>.backend.hcl` — see [backend-config](backend-config.md)).

## Inputs

| Name | Type | Default | Required | Description |
|---|---|---|---|---|
| `resource_group_name` | `string` | — | yes | Name of the resource group everything is created in |
| `location` | `string` | — | yes | Azure region |
| `vnet_address_space` | `string` | `"10.0.0.0/16"` | no | CIDR for the VNet |
| `project` | `string` | — | yes | Project name, used for naming (e.g. state storage) |
| `environment` | `string` | — | yes | Environment name (`dev`, `prod`, ...) |
| `sku_name` | `string` | — | yes | MySQL Flexible Server SKU (e.g. `B_Standard_B1ms`) |
| `administrator_login` | `string` | — | yes | MySQL admin username |
| `storage_gb` | `string` | — | yes | MySQL storage size in GB |
| `administrator_passwrd` | `string` | — | yes | **Sensitive.** MySQL admin password |
| `secrets` | `map(string)` | — | yes | **Sensitive.** App secrets pushed to Key Vault. Must include `db-password`, `jwt-secret`, `stripe-key`, `btc-xpub` — see [container_app reference](modules/container_app.md) |
| `max_replicas` | `number` | — | yes | Container App max replica count |
| `min_replicas` | `number` | — | yes | Container App min replica count |
| `image_tag` | `string` | — | yes | Tag of the `finpay` image in ACR to deploy |

## Outputs

| Name | Description |
|---|---|
| `acr_name` | Name of the Azure Container Registry |
| `acr_login_server` | ACR login server URL |
| `app_url` | FQDN of the deployed Container App |
| `resource_group_name` | Name of the resource group |

## Module wiring

```
resource_group (azurerm_resource_group.main)
├── networking          (vnet, subnets, private dns zones)
├── database            ← networking (mysql_subnet_id, mysql_private_dns_zone_id)
├── cache                ← networking (private_endpoints_subnet_id, redis_private_dns_zone_id)
├── keyvault             ← data.azurerm_client_config.current (tenant_id, deployer_principal_id)
├── registry             ← keyvault (key_vault_id)
├── monitoring           (currently no inputs — see modules/monitoring.md)
└── container_app        ← registry (identity_id), database (server_fqdn),
                           keyvault (secret_versionless_ids), networking (container_apps_subnet_id)
                           explicit depends_on: [registry, cache, database, keyvault, monitoring]
```

See [explanation: architecture-overview](../explanation/architecture-overview.md) for why
it's wired this way.
