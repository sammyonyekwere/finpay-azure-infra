# Tutorial: Deploy the dev environment from scratch

This walks through standing up FinPay's `dev` environment end to end, on a machine that
has never touched this repo before. By the end you'll have a running Container App
backed by a private MySQL Flexible Server, Redis, and Key Vault, and you'll know how to
find its URL.

## Prerequisites

- Terraform `>= 1.6.0, < 2.0.0`
- Azure CLI, logged in (`az login`) against the subscription this should deploy to
- Contributor + User Access Administrator (or equivalent) on that subscription, since
  Terraform creates role assignments

## 1. Create the remote state backend (one-time, per subscription)

Terraform's `azurerm` backend needs a storage account to exist before `terraform init`
can use it — `bootstrap/` is a separate, tiny root module that creates just that.

```sh
cd bootstrap
terraform init
terraform apply
```

This creates a resource group (`rg-<project>-tfstate`) and a storage account with a
`tfstate` container. Note the `storage_account_name` output — `environments/dev.backend.hcl`
already points at it, but if you're bootstrapping a **new** subscription the generated
name will differ (it has a random suffix) and you'll need to update that file.

> Skip this step if the backend in `environments/dev.backend.hcl` already exists (e.g.
> you're a second person deploying to the same subscription).

## 2. Initialize the root module against the dev backend

```sh
cd ..
terraform init -backend-config=environments/dev.backend.hcl
```

## 3. Supply variables

Non-sensitive values for dev already live in the (gitignored) `terraform.tfvars` at the
repo root — copy them from a teammate or recreate from `variables.tf`:

```hcl
resource_group_name = "rg-finpayinfra-dev"
location             = "uksouth"
project              = "finpay"
environment          = "dev"
sku_name             = "B_Standard_B1ms"
administrator_login  = "finpayadmin"
storage_gb           = 20
max_replicas         = 3
min_replicas         = 1
image_tag            = "v1"
```

`administrator_passwrd` and `secrets` are sensitive and are **not** in `terraform.tfvars`.
Supply them as environment variables instead:

```sh
export TF_VAR_administrator_passwrd="<mysql admin password>"
export TF_VAR_secrets='{"db-password":"...","jwt-secret":"...","stripe-key":"...","btc-xpub":"..."}'
```

The four keys in `secrets` (`db-password`, `jwt-secret`, `stripe-key`, `btc-xpub`) matter —
`modules/container_app` wires exactly those secret names into the Container App's env vars.
See [reference: root module](../reference/root-module.md) for the full variable list and
[how-to: rotate a secret](../how-to/rotate-a-secret-in-key-vault.md) if you're changing one later.

## 4. Plan and apply

```sh
terraform plan
terraform apply
```

This provisions, in order: the resource group, VNet + subnets + private DNS zones,
MySQL Flexible Server, Redis, Key Vault + secrets, ACR + managed identity, the Container
Apps environment, and finally the Container App itself.

## 5. Verify

```sh
terraform output app_url
```

Hit that URL — the app exposes a liveness endpoint at `/health.php` that Azure itself
polls, so a 200 there is a good sign the app started and could reach its secrets.

If it doesn't come up, check [how-to: connect to MySQL privately](../how-to/connect-to-mysql-privately.md)
and the Log Analytics workspace for the container's logs.
