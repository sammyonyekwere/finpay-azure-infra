resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.name_prefix}"
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "container_apps" {
  name                 = "snet-container-apps"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_address_space, 7, 0)]

  delegation {
    name = "aca"
    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "mysql" {
  name                 = "snet-mysql"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_address_space, 12, 0)]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_address_space, 12, 1)]

}

# mysql private dns zone
resource "azurerm_private_dns_zone" "private_mysql" {
  name                = "${var.name_prefix}.private.mysql.database.azure.com"
  resource_group_name = var.resource_group_name
}

# Linking mysql private dns zone to main VNet
resource "azurerm_private_dns_zone_virtual_network_link" "vnet_mysql" {
  name                  = "vnet-mysql-zone"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_mysql.name
  virtual_network_id    = azurerm_virtual_network.main.id
}

# Redis private DNS zone
resource "azurerm_private_dns_zone" "privatelink_redis" {
  name                = "${var.name_prefix}.privatelink.redis.cache.windows.net"
  resource_group_name = var.resource_group_name
}

# Linking redis private dns zone to main VNet
resource "azurerm_private_dns_zone_virtual_network_link" "vnet_redis" {
  name                  = "vnet-redis-zone"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_redis.name
  virtual_network_id    = azurerm_virtual_network.main.id
}


