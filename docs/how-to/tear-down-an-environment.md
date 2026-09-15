# How to tear down an environment

```sh
terraform init -backend-config=environments/<env>.backend.hcl
terraform destroy -var-file=<env>.tfvars
```

## Notes

- This destroys everything in `main.tf` for that environment's state — resource group,
  networking, database, cache, Key Vault, registry, and the Container App — but **not**
  the shared state storage account created by `bootstrap/` (that's separate state and
  intentionally not tied to any single environment's lifecycle).
- `azurerm_mysql_flexible_server` and `azurerm_redis_cache` both have soft-delete/purge
  behavior in Azure independent of Terraform — if you recreate the environment
  immediately after destroying it, watch for name-collision errors (e.g. Key Vault name
  reuse, since `modules/keyvault` appends a random suffix specifically to reduce this,
  but MySQL/Redis names are not randomized).
- There's no `prevent_destroy` lifecycle guard on any resource currently, including the
  database — `terraform destroy` (or a plan that happens to replace the MySQL server)
  will not ask twice.
