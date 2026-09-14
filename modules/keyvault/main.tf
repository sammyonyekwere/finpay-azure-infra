resource "azurerm_key_vault" "main" {
  name                      = "kv-${var.name_prefix}-${random_string.s.result}"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  tenant_id                 = var.tenant_id
  sku_name                  = "standard"
  enable_rbac_authorization = true # authorize with Azure roles
}

resource "azurerm_role_assignment" "deployer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.deployer_principal_id # you / the CI identity
}

resource "azurerm_key_vault_secret" "this" {
  for_each     = var.secrets # map: name -> value
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.main.id
  depends_on   = [azurerm_role_assignment.deployer]
}