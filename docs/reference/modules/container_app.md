# Module: container_app

Source: `modules/container_app/`

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Type | Required | Description |
|---|---|---|---|
| `location` | `string` | yes | Azure region |
| `resource_group_name` | `string` | yes | Resource group to deploy into |
| `container_apps_subnet_id` | `string` | yes | VNet-injected subnet for the Container Apps environment |
| `acr_login_server` | `string` | yes | Registry the image is pulled from |
| `min_replicas` | `number` | yes | Minimum replica count |
| `max_replicas` | `number` | yes | Maximum replica count |
| `name_prefix` | `string` | yes | Prefix used in resource names |
| `image_tag` | `string` | yes | Tag of the `finpay` image to deploy |
| `db_host` | `string` | yes | MySQL FQDN, injected as `DB_HOST` |
| `kv_secret_ids` | `map(string)` | yes | Key Vault secret name → versionless ID map (from `modules/keyvault`) |
| `identity_id` | `string` | yes | User-assigned identity resource ID (from `modules/registry`) |

## Outputs

| Name | Description |
|---|---|
| `fqdn` | Latest revision FQDN of the Container App |

## Resources

- `azurerm_log_analytics_workspace.main` — named `acctest-01` (leftover example name),
  `PerGB2018`, 30-day retention
- `azurerm_container_app_environment.main` — VNet-injected via `container_apps_subnet_id`
- `azurerm_container_app.main` — single revision mode, external ingress on port 80,
  100% traffic to latest revision, pulls `<acr_login_server>/finpay:<image_tag>` using
  the user-assigned identity, `cpu = 0.5` / `memory = "1Gi"` (hardcoded, not a variable),
  liveness probe: HTTP `GET /health.php` on port 80

### Env vars wired into the container

| Env var | Source |
|---|---|
| `DB_HOST` | plain value, `var.db_host` |
| `DB_PASSWORD` | secret `db-password` |
| `JWT_SECRET` | secret `jwt-secret` |
| `STRIPE_KEY` | secret `stripe-key` |
| `BTC_XPUB` | secret `btc-xpub` |

The `secret { }` blocks referencing these names are generated dynamically from
`var.kv_secret_ids` — the four names above must exist as keys in the root `secrets`
variable or the corresponding `env` block will reference a secret that doesn't exist.
<!-- END_TF_DOCS -->

## Known gap

The Log Analytics workspace is created **inside this module**, not in `modules/monitoring`
(which is currently empty). See [module: monitoring](monitoring.md) and
[explanation: architecture-overview](../../explanation/architecture-overview.md).
