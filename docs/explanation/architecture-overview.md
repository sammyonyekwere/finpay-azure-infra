# Architecture overview

FinPay's Azure infra is one root Terraform module that composes seven child modules
around a single resource group per environment. The shape is deliberately "one app, one
database, one cache, private by default" rather than a general-purpose platform — it
matches a single Container App workload, not a multi-service system.

## Why a resource-group-per-environment, not per-region or per-service

`environment` (dev/prod) is the unit of isolation. Everything for one environment —
network, data, compute — lives in one resource group and one Terraform state file (see
[state-and-bootstrap](state-and-bootstrap.md)). This keeps blast radius for `terraform
destroy` and for RBAC scoping obvious: one resource group, one environment, no
cross-environment resource sharing except the Terraform state storage account itself.

## Why private networking is the default, not an add-on

MySQL and Redis are both deployed with no public network path (VNet delegation for
MySQL, a private endpoint for Redis) from the start, rather than "public now, lock down
later." For a payments-adjacent app (the repo also touches `STRIPE_KEY` and `BTC_XPUB`
secrets), the cost of a public-by-default database is a much worse failure mode than the
inconvenience of needing a bastion for ad hoc access (see
[how-to: connect to MySQL privately](../how-to/connect-to-mysql-privately.md)). See
[network-design](network-design.md) for the subnet layout this requires.

## Why identity lives in the `registry` module

The Container App's managed identity, `AcrPull`, and `Key Vault Secrets User` role
assignments are created in `modules/registry`, not `modules/container_app` or a separate
`identity` module. This is because the identity's *first* job, chronologically in the
apply graph, is pulling the image — registry and identity are provisioned together so
the identity exists before `container_app` needs to reference it. It's a slightly
surprising home for it; see [secrets-and-identity-model](secrets-and-identity-model.md).

<!-- ## Known architectural gaps (as of this writing) -->
<!-- 
- **`modules/monitoring` is an empty stub.** The Log Analytics workspace Container Apps
  actually logs to is created inline inside `modules/container_app` instead. See
  [reference: monitoring](../reference/modules/monitoring.md).
- **No CI/CD pipeline exists yet**, despite the top-level README mentioning "OIDC based
  CI/CD" — that's a stated goal, not built infra. When it lands, it belongs in its own
  explanation page describing the trust model (federated credential, which identity it
  assumes, which environments it can apply to).
- **No bastion/jump host** for ad hoc private access to MySQL or Redis — see
  [how-to: connect to MySQL privately](../how-to/connect-to-mysql-privately.md).
- **Redis cache name is hardcoded** (`"redis-cache"`), not derived from `name_prefix` —
  see [reference: cache](../reference/modules/cache.md) for why that's a problem once a
  second environment shares the naming namespace. -->

<!-- Keeping this list here (rather than only in code comments) is deliberate: it's the kind
of context a new contributor needs before they assume monitoring or CI/CD already work. -->
