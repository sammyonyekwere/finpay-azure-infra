# Module: keyvault

Source: `modules/keyvault/`

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Type | Required | Description |
|---|---|---|---|
| `secrets` | `map(string)` | yes | **Sensitive.** Secret name → value pairs to store |
| `deployer_principal_id` | `string` | yes | Object ID granted `Key Vault Secrets Officer` (typically the caller/CI identity) |
| `tenant_id` | `string` | yes | Azure AD tenant ID |
| `resource_group_name` | `string` | yes | Resource group to deploy into |
| `location` | `string` | yes | Azure region |
| `name_prefix` | `string` | yes | Prefix used in resource names |

## Outputs

| Name | Description |
|---|---|
| `secret_versionless_ids` | Map of secret name → versionless secret ID, for consumers (e.g. `modules/container_app`) that should always resolve the latest version |
| `id` | Key Vault resource ID |

## Resources

- `azurerm_key_vault.main` — named `kv-<name_prefix>-<random 4-char suffix>`, `standard`
  SKU, **RBAC authorization** (not legacy access policies)
- `azurerm_role_assignment.deployer` — grants `Key Vault Secrets Officer` to
  `deployer_principal_id`
- `azurerm_key_vault_secret.this` — one per key in `secrets`, `for_each` over
  `nonsensitive(keys(var.secrets))` (only the *names* are treated as non-sensitive so
  `for_each` can use them; values stay sensitive)
<!-- END_TF_DOCS -->

See [explanation: secrets-and-identity-model](../../explanation/secrets-and-identity-model.md).
