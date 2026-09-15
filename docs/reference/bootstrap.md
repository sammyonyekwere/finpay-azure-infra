# Bootstrap module reference

Source: `bootstrap/main.tf`, `bootstrap/variables.tf`, `bootstrap/outputs.tf`.

A standalone root module (own state, kept local — see
[explanation: state-and-bootstrap](../explanation/state-and-bootstrap.md)). Not part of
the `main.tf` module graph.

## Inputs

| Name | Type | Required | Description |
|---|---|---|---|
| `project` | `string` | yes | Project name, used to derive resource group and storage account names |

## Resources created

- `azurerm_resource_group.state` — named `rg-<project>-tfstate`
- `azurerm_storage_account.state` — named `st<project>tfstate<random 3-char suffix>`, `Standard`/`LRS`, TLS 1.2 minimum, blob versioning enabled
- `azurerm_storage_container.state` — named `tfstate`, private access

## Outputs

| Name | Description |
|---|---|
| `resource_group_name` | Name of the state resource group |
| `storage_account_name` | Name of the state storage account (feed this into `environments/*.backend.hcl`) |

Note: these two outputs are currently declared inline in `bootstrap/main.tf` rather than
in `bootstrap/outputs.tf` (which is empty) — functionally equivalent, just worth knowing
if you go looking for them.
