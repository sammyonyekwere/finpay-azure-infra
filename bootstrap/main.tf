# random string generator
resource "random_string" "random" {
  length  = 3
  special = false
  upper   = false
}

# resource group
resource "azurerm_resource_group" "state" {
  name     = "rg-${var.project}-tfstate"
  location = "West Europe"
}

# azure storage account
resource "azurerm_storage_account" "state" {
  name                     = "st${var.project}tfstate${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.state.name
  location                 = azurerm_resource_group.state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  blob_properties {
    versioning_enabled = true
  }
}

resource "azurerm_storage_container" "state" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"
}


output "resource_group_name" {
  description = "name of the resource group"
  value       = azurerm_resource_group.state.name
}

output "storage_account_name" {
  description = "name of the storage account"
  value       = azurerm_storage_account.state.name
}


