# Module: registry

Source: `modules/registry/`

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Type | Required | Description |
|---|---|---|---|
| `key_vault_id` | `string` | yes | Key Vault ID to grant the app identity `Key Vault Secrets User` on |
| `location` | `string` | yes | Azure region |
| `resource_group_name` | `string` | yes | Resource group to deploy into |
| `name_prefix` | `string` | yes | Prefix used in resource names |

## Outputs

| Name | Description |
|---|---|
| `login_server` | ACR login server URL |
| `name` | ACR resource name |
| `identity_id` | Resource ID of the user-assigned managed identity |
| `identity_principal_id` | Principal (object) ID of the managed identity |

## Resources

- `azurerm_user_assigned_identity.app` — named `id-<name_prefix>-app`; this is the single
  identity the Container App runs as
- `azurerm_role_assignment.acr_pull` — grants `AcrPull` on the registry to the identity
- `azurerm_role_assignment.kv_secret_user` — grants `Key Vault Secrets User` on
  `var.key_vault_id` to the identity
- `azurerm_container_registry.this` — named `acr<name_prefix>` (hyphens stripped), `Basic`
  SKU, `admin_enabled = false` (pull is via managed identity only, no admin credentials)
<!-- END_TF_DOCS -->

Despite the name, this module also owns the app's managed identity and its role
assignments — see [explanation: secrets-and-identity-model](../../explanation/secrets-and-identity-model.md)
for why identity lives here rather than in `container_app`.
