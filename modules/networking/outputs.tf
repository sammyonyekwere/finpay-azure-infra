output "container_apps_subnet_id" {
  value = azurerm_subnet.container_apps.id
}

output "mysql_private_dns_zone_id" {
  value = azurerm_private_dns_zone.private_mysql.id
}

output "mysql_subnet_id" {
  value = azurerm_subnet.mysql.id
}

output "private_endpoints_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}

output "redis_private_dns_zone_id" {
  value = azurerm_private_dns_zone.privatelink_redis.id
}