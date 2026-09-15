# How to scale Container App replicas

Replica count is controlled by the root variables `min_replicas` and `max_replicas`,
passed straight through to `modules/container_app`'s `template` block — there's no
autoscale rule configured yet, so Azure scales only on Container Apps' default HTTP
concurrency trigger between those bounds.

1. Update `min_replicas` / `max_replicas` in your environment's `terraform.tfvars`.
2. `terraform apply`.

To change CPU/memory per replica instead, edit the hardcoded `cpu = 0.5` / `memory = "1Gi"`
in `modules/container_app/main.tf` (not currently exposed as variables) and apply.

See [reference: container_app](../reference/modules/container_app.md) for the full
variable list.
