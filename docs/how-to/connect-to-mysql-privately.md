# How to connect to MySQL privately

The MySQL Flexible Server is deployed with `delegated_subnet_id` and `private_dns_zone_id`
set (see [reference: networking](../reference/modules/networking.md) and
[reference: database](../reference/modules/database.md)) — there is no public endpoint.
You cannot reach it from your laptop directly.

Options, in order of how they fit this repo today:

1. **From the Container App** — it already resolves the server via the private DNS zone
   linked to the VNet (`DB_HOST` env var = `module.database.server_fqdn`). No extra setup
   needed; this is the intended path for the app itself.
2. **From your workstation** — there is no bastion/jump host or VPN gateway provisioned
   in this repo yet. To connect ad hoc, the fastest option is a throwaway VM (or
   `az container` instance) inside `snet-private-endpoints` or a new subnet in the same
   VNet, with the MySQL client installed, reached via `az vm run-command` or Bastion you
   attach manually — this infra doesn't automate that today.
3. **Azure Cloud Shell with VNet integration** is not currently wired up either.

If ad hoc private access becomes a recurring need, that's an argument for adding a small
bastion module rather than repeating step 2 manually — see
[explanation: network-design](../explanation/network-design.md).
