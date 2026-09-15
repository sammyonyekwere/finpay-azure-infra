output "login_server" {
  value = azurerm_container_registry.this.login_server
}

output "name" {
  value = azurerm_container_registry.this.name
}

output "identity_id" {
  value = azurerm_user_assigned_identity.app.id
}

output "identity_principal_id" {
  value = azurerm_user_assigned_identity.app.principal_id
}