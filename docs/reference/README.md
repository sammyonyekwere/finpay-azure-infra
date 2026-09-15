# Reference

Dry, exact descriptions of inputs and outputs. If you want to understand *why* something
is shaped this way, see [explanation](../explanation/) instead.

- [Root module](root-module.md) — variables/outputs of the top-level config in `main.tf`
- [Backend config](backend-config.md) — `environments/*.backend.hcl`
- [Bootstrap module](bootstrap.md) — the separate `bootstrap/` root module
- Child modules (`modules/*`):
  - [networking](modules/networking.md)
  - [database](modules/database.md)
  - [cache](modules/cache.md)
  - [keyvault](modules/keyvault.md)
  - [registry](modules/registry.md)
  - [container_app](modules/container_app.md)
  - [monitoring](modules/monitoring.md) — currently a stub, see note in the page

Module pages between the `<!-- BEGIN_TF_DOCS -->`/`<!-- END_TF_DOCS -->` markers are
generated with `terraform-docs` (see `.terraform-docs.yml` at repo root and `make docs`).
Regenerate them after changing a module's `variables.tf` or `outputs.tf` rather than
hand-editing.
