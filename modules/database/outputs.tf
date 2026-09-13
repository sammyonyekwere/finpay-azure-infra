# Outputing the server fqdn
output "server_fqdn" {
  value = azurerm_mysql_flexible_server.main.fqdn
}