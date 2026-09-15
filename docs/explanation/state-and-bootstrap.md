# State and bootstrap

## The chicken-and-egg problem

The root module's backend is `azurerm` — Terraform state lives in an Azure Storage
blob container. But that storage account is itself an Azure resource, and Terraform
can't manage the very backend it's about to store its state in on the first run: there's
nowhere to put the state for "create the state storage account" if that state is
supposed to live in the storage account being created.

## Why `bootstrap/` is a fully separate root module

`bootstrap/` solves this by being its own tiny Terraform root, with its own **local**
state (`bootstrap/terraform.tfstate`, gitignored like all `*.tfstate` files — see
`.gitignore`). It has no backend block, so it defaults to local state.
This is a one-time, rarely-touched piece of infra (a resource group, a storage account, a
container) — the operational cost of local state (no locking, no remote backup) is low
because almost nobody applies it more than once per subscription, and the alternative
(a "backend for the backend") just pushes the same problem up a level.

Practical implication: **`bootstrap/terraform.tfstate` is the one state file that isn't
protected by Azure Storage's locking/versioning.** If it's lost, Terraform will plan to
recreate the resource group and storage account (a resource group with the same name
would then need to be dealt with as an import or a conflict) — see
[how-to: bootstrap remote state](../how-to/bootstrap-remote-state.md) for what "losing it"
actually costs.

## Why one state storage account backs multiple environments

`environments/dev.backend.hcl` and `environments/prod.backend.hcl` point at the same
`resource_group_name`/`storage_account_name`, differing only in blob `key`
(`dev.terraform.tfstate` vs `prod.terraform.tfstate`). Environments are isolated by
having entirely separate resource groups and state files, not by having separate state
*storage accounts* — the storage account itself is infrastructure-for-infrastructure,
shared the same way a CI system or a package registry would be. See
[reference: backend-config](../reference/backend-config.md).
