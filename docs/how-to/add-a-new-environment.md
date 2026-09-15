# How to add a new environment (e.g. staging)

1. Create a backend config: `environments/staging.backend.hcl`, copied from
   `environments/dev.backend.hcl` with a different `key`:
   ```hcl
   resource_group_name  = "rg-finpayinfra-tfstate"
   storage_account_name = "stfinpayinfratfstatetbc"
   container_name       = "tfstate"
   key                  = "staging.terraform.tfstate"
   ```
   (Reuse the same state storage account unless staging needs to live in a different
   subscription — if so, [bootstrap remote state](bootstrap-remote-state.md) there first.)
2. Create a `terraform.tfvars` for staging (not committed — `*.tfvars` is gitignored).
   Set at minimum `resource_group_name`, `location`, `project`, `environment`, `sku_name`,
   `administrator_login`, `storage_gb`, `max_replicas`, `min_replicas`, `image_tag`. See
   [reference: root module](../reference/root-module.md) for the full list.
3. Switch backends and apply:
   ```sh
   terraform init -reconfigure -backend-config=environments/staging.backend.hcl
   terraform apply -var-file=staging.tfvars
   ```

## Notes

- Terraform workspaces are **not** used here — environments are separated by distinct
  state files (`key` in the backend config) and distinct resource groups, not
  `terraform workspace`. Don't mix the two approaches.
- Because `resource_group_name` and `environment` are both plain variables (not derived
  from each other), double-check they agree — nothing enforces `rg-finpayinfra-staging`
  matching `environment = "staging"`.
