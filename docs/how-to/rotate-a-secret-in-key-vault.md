# How to rotate a secret in Key Vault

The four app secrets (`db-password`, `jwt-secret`, `stripe-key`, `btc-xpub`) are pushed
into Key Vault from the `secrets` variable on the root module — Key Vault is not the
source of truth, Terraform state and your `TF_VAR_secrets` input are.

1. Update the value in your `TF_VAR_secrets` JSON (or wherever you source it — a secrets
   manager, CI secret store, etc). Do not edit the secret directly in the Azure Portal;
   Terraform will drift and overwrite it on the next apply.
2. Re-apply:
   ```sh
   terraform apply
   ```
   `modules/keyvault` creates one `azurerm_key_vault_secret` per key via `for_each`, so
   changing a value creates a new secret **version** — it does not delete history.
3. The Container App picks up the new version automatically on its next restart/revision,
   because `modules/container_app` references `secret_versionless_ids` (the versionless
   ID, not a pinned version) — see [reference: keyvault](../reference/modules/keyvault.md)
   and [reference: container_app](../reference/modules/container_app.md).
4. If you're rotating `administrator_passwrd` (the MySQL admin password) instead, that's a
   separate root variable, not part of `secrets` — update `TF_VAR_administrator_passwrd`
   and re-apply; expect Terraform to update the MySQL server in place.

## Notes

- The Terraform deployer identity needs the **Key Vault Secrets Officer** role (granted
  automatically to whoever/whatever runs `terraform apply`, via
  `data.azurerm_client_config.current.object_id`) to write secrets. A CI identity without
  that role will fail on `azurerm_key_vault_secret.this`.
