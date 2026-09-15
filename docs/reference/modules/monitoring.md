# Module: monitoring

Source: `modules/monitoring/`

<!-- BEGIN_TF_DOCS -->
## Inputs

_None currently defined (`variables.tf` is empty)._

## Outputs

_None currently defined (`outputs.tf` is empty)._

## Resources

_None currently defined (`main.tf` is empty)._
<!-- END_TF_DOCS -->

## Status: stub

This module is called from the root `main.tf` (`module "monitoring"`) but currently
creates nothing. The Log Analytics workspace that Container Apps actually uses today is
created inline in [`modules/container_app`](container_app.md) instead. This is a known
inconsistency, not an intentional design — the workspace should move here once this
module is built out, so monitoring resources (workspace, diagnostic settings, alerts)
have one home instead of being scattered across modules that need them incidentally.
