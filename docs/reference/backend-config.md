# Backend config reference

Source: `environments/*.backend.hcl`, used via `terraform init -backend-config=<file>`.

Backend type: `azurerm` (declared in `versions.tf`).

## Keys

| Key | Description |
|---|---|
| `resource_group_name` | Resource group holding the state storage account (created by `bootstrap/`) |
| `storage_account_name` | Storage account holding the `tfstate` container |
| `container_name` | Blob container name (`tfstate` for all environments) |
| `key` | Blob name for this environment's state file — the only field that differs between environment backend files |

## Current environments

| File | `key` |
|---|---|
| `environments/dev.backend.hcl` | `dev.terraform.tfstate` |
| `environments/prod.backend.hcl` | `prod.terraform.tfstate` |

Both currently point at the same `resource_group_name` / `storage_account_name` — one
state storage account backs all environments, separated only by blob key. See
[how-to: add a new environment](../how-to/add-a-new-environment.md).
