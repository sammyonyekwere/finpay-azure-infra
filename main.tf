data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {

}

locals {
  name_prefix         = "${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
}


resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = local.location
}

module "networking" {
  source              = "./modules/networking"
  vnet_address_space  = var.vnet_address_space
  name_prefix         = local.name_prefix
  location            = local.location
  resource_group_name = local.resource_group_name
}

module "database" {
  source                    = "./modules/database"
  name_prefix               = local.name_prefix
  location                  = var.location
  resource_group_name       = local.resource_group_name
  sku_name                  = var.sku_name
  administrator_login       = var.administrator_login
  storage_gb                = var.storage_gb
  administrator_passwrd     = var.administrator_passwrd
  mysql_private_dns_zone_id = module.networking.mysql_private_dns_zone_id
  mysql_subnet_id           = module.networking.mysql_subnet_id
  depends_on                = [module.networking]
}

module "cache" {
  source                      = "./modules/cache"
  name_prefix                 = local.name_prefix
  location                    = local.location
  resource_group_name         = local.resource_group_name
  private_endpoints_subnet_id = module.networking.private_endpoints_subnet_id
  private_dns_zone            = module.networking.redis_private_dns_zone_id
  depends_on                  = [module.networking]
}

module "registry" {
  source              = "./modules/registry"
  name_prefix         = local.name_prefix
  location            = local.location
  resource_group_name = local.resource_group_name
  key_vault_id        = var.key_vault_id
  acr_id              = var.acr_id
}

module "keyvault" {
  source                = "./modules/keyvault"
  resource_group_name   = local.resource_group_name
  location              = local.location
  name_prefix           = local.name_prefix
  deployer_principal_id = data.azurerm_client_config.current.object_id
  tenant_id             = data.azurerm_client_config.current.tenant_id
  secrets               = var.secrets
}

module "monitoring" {
  source = "./modules/monitoring"
}

module "container_app" {
  source                   = "./modules/container_app"
  location                 = local.location
  resource_group_name      = local.resource_group_name
  name_prefix              = local.name_prefix
  db_host                  = module.database.server_fqdn
  acr_login_server         = module.registry.login_server
  max_replicas             = var.max_replicas
  min_replicas             = var.min_replicas
  kv_secret_ids            = module.keyvault.secret_versionless_ids
  container_apps_subnet_id = module.networking.container_apps_subnet_id
  image_tag                = var.image_tag
  depends_on               = [module.registry, module.cache, module.database, module.keyvault, module.monitoring]
}


