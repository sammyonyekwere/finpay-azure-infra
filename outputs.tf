output "acr_name" {
  value = module.registry.name
}

output "acr_login_server" {
  value = module.registry.login_server
}

output "app_url" {
  value = module.container_app.fqdn
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}