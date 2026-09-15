# Secrets and identity model

## Why RBAC-authorized Key Vault, not access policies

`modules/keyvault` sets `rbac_authorization_enabled = true` rather than using Key Vault's
legacy access-policy model. Access policies are per-vault and don't compose with Azure's
broader role system (they can't be scoped to a resource group, audited alongside other
role assignments, or granted via `azurerm_role_assignment` like everything else in this
repo). RBAC keeps "who can read/write secrets" answerable the same way as "who can pull
from ACR" — one mental model, one place (role assignments) to check.

## Why one managed identity for everything the app needs

There's a single `azurerm_user_assigned_identity.app` (created in `modules/registry`),
granted both `AcrPull` and `Key Vault Secrets User`. The Container App authenticates to
both ACR (to pull its image) and Key Vault (to read secrets at startup) as this one
identity — no admin-enabled registry credentials, no Key Vault access policies, no
connection strings with embedded credentials anywhere in the config. A compromised
Container App revision has exactly the two permissions it needs and nothing else,
because there's exactly one identity to reason about.

## Why secrets flow through a `map(string)` variable instead of being created ad hoc

The root `secrets` variable is a flat map, fanned out to individual
`azurerm_key_vault_secret` resources via `for_each` in `modules/keyvault`, then fanned
back into named `env` blocks via `dynamic "secret"` in `modules/container_app`. This
means adding a secret is a two-place change (the map, and the `env` block referencing
it) rather than a new resource block each time — see
[how-to: add an env var to the Container App](../how-to/add-an-env-var-to-the-container-app.md).
The tradeoff: nothing in Terraform enforces that every key in `secrets` is actually
consumed, or that every `secret_name` referenced in `container_app` exists in `secrets`
— that link is implicit, not type-checked. Keep [reference: container_app](../reference/modules/container_app.md)'s
"Env vars wired into the container" table in sync with the `secrets` keys you actually use.

## Why the versionless secret ID, not a pinned version

`modules/keyvault` outputs `secret_versionless_ids` (Key Vault's versionless secret
reference), not a version-pinned one. Azure Container Apps resolves the versionless
reference to the latest version at revision start, so rotating a secret
([how-to](../how-to/rotate-a-secret-in-key-vault.md)) plus restarting the app is enough —
there's no Terraform state to update to "point at" a new version.
