output "secret_versionless_ids" {
  value = {
    for name, secret in azurerm_key_vault_secret.this :
    name => secret.versionless_id
  }
}