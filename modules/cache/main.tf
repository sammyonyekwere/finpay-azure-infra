# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "main" {
  name                          = "redis-cache"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  capacity                      = 2
  family                        = "C"
  sku_name                      = "Standard"
  non_ssl_port_enabled          = false
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  redis_configuration {
  }
}

resource "azurerm_private_endpoint" "redis" {
  name                = "${var.name_prefix}-pe-redis"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoints_subnet_id

  private_service_connection {
    name                           = "${var.name_prefix}psc-redis"
    private_connection_resource_id = azurerm_redis_cache.main.id
    subresource_names              = ["redisCache"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "redis-dns-zone-group"
    private_dns_zone_ids = [var.private_dns_zone]
  }
}