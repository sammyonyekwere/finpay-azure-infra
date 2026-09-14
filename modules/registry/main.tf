# Managed Identity
resource "azurerm_user_assigned_identity" "app" {
  name                = "id-${var.name_prefix}-app"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Asign roles to the managed identity 
# AcrPull scoped to the container registry
resource "azurerm_role_assignment" "acr_pull" {
  scope              = var.acr_id
  role_definition_id = "AcrPull"
  principal_id       = azurerm_user_assigned_identity.app.id
}

# Key Vault Secrets User scoped to the key_vault
resource "azurerm_role_assignment" "kv_secret_user" {
  scope              = var.key_vault_id
  role_definition_id = "Key Vault Secrets User"
  principal_id       = azurerm_user_assigned_identity.app.id
}
