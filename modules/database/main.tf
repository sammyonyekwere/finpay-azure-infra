resource "azurerm_mysql_flexible_server" "main" {
  name                   = "mysql-server-${var.name_prefix}"
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_passwrd
  sku_name               = var.sku_name
  version                = "8.0.21"
  delegated_subnet_id    = var.mysql_subnet_id
  private_dns_zone_id    = var.mysql_private_dns_zone_id

  storage {
    size_gb           = var.storage_gb
    auto_grow_enabled = true
  }
  backup_retention_days = 7
}

resource "azurerm_mysql_flexible_database" "main" {
  name                = "mysql-database-${var.name_prefix}"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_0900_ai_ci"
}

resource "azurerm_mysql_flexible_server_configuration" "example" {
  name                = "interactive_timeout"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main.name
  value               = "ON"
}


