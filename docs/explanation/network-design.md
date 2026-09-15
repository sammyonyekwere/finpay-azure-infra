# Network design

## Why three subnets, not one

`modules/networking` creates three subnets from a single `/16` VNet:

- `snet-container-apps` (`cidrsubnet(vnet_address_space, 7, 0)` — a `/23`, ~510 usable IPs)
- `snet-mysql` (`cidrsubnet(vnet_address_space, 12, 0)` — a `/28`, 11 usable IPs)
- `snet-private-endpoints` (`cidrsubnet(vnet_address_space, 12, 1)` — a `/28`, 11 usable IPs)

Each has a different reason to exist as its own subnet rather than sharing one:

- **`snet-container-apps` is large** because Container Apps environments consume IPs per
  replica/revision, not per app — undersizing this subnet is a common way to get
  surprise scaling failures later, so it's sized generously relative to the others.
- **`snet-mysql` exists separately because it needs a subnet delegation**
  (`Microsoft.DBforMySQL/flexibleServers`) that only MySQL Flexible Server can use — a
  delegated subnet can't be shared with unrelated resources.
- **`snet-private-endpoints` exists separately because private endpoints (currently just
  Redis's) have their own delegation-free requirements** and, more importantly, keeping
  them off the compute subnet keeps future private endpoints (Key Vault, ACR, storage)
  addable without touching the Container Apps subnet's sizing.

## Why private DNS zones per resource type

Azure Private Link resolves through a matching private DNS zone
(`privatelink.<service>.azure.com`-style names) linked to the VNet. Each zone here is
named with the environment's `name_prefix` baked in
(`<name_prefix>.private.mysql.database.azure.com`,
`<name_prefix>.privatelink.redis.cache.windows.net`) rather than the exact Azure-standard
zone name — this works today because nothing outside this VNet needs to resolve these
names, but it's worth knowing if a future need arises to peer this VNet with another one
expecting the standard zone names.

## What isn't here yet

No NSGs are attached to any subnet, and there's no bastion/jump host subnet — see
[architecture-overview](architecture-overview.md#known-architectural-gaps-as-of-this-writing)
and [how-to: connect to MySQL privately](../how-to/connect-to-mysql-privately.md).
