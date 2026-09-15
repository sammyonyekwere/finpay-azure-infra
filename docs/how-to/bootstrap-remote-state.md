# How to bootstrap remote state for a new subscription

Do this once per Azure subscription, before anyone runs `terraform init` on the root module.

1. Set the project name in `bootstrap/terraform.tfvars`:
   ```hcl
   project = "finpayinfra"
   ```
2. Apply:
   ```sh
   cd bootstrap
   terraform init
   terraform apply
   ```
   This creates `rg-<project>-tfstate` and a storage account `st<project>tfstate<random>`
   with a `tfstate` blob container (versioning enabled).
3. Copy the `storage_account_name` output into the relevant `environments/<env>.backend.hcl`
   file (`resource_group_name` and `container_name` are stable; `storage_account_name` has
   a random suffix generated per bootstrap run).
4. Anyone deploying to this subscription now runs
   `terraform init -backend-config=environments/<env>.backend.hcl` from the root module.

## Notes

- `bootstrap/` is deliberately its own root module with its own local state — it can't use
  the `azurerm` backend it's creating. Its state file (`bootstrap/terraform.tfstate`) is
  small and low-churn; treat it as precious (back it up, don't delete it) since losing it
  means Terraform will try to recreate the storage account next time. See
  [explanation: state and bootstrap](../explanation/state-and-bootstrap.md).
- One state storage account currently backs both `dev` and `prod` (same resource group,
  different blob `key` per `environments/*.backend.hcl`) — you don't need to re-run this
  per environment, only per subscription.
