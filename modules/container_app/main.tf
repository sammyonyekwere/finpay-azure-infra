resource "azurerm_log_analytics_workspace" "main" {
  name                = "acctest-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "main" {
  name                       = "ca-main-environment"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  infrastructure_subnet_id   = var.container_apps_subnet_id
}

resource "azurerm_container_app" "main" {
  name                         = "ca-${var.name_prefix}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app.id]
  }

  registry {
    server   = var.acr_login_server
    identity = azurerm_user_assigned_identity.app.id
  }

  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas
    container {
      name   = "finpay"
      image  = "${var.acr_login_server}/finpay:${var.image_tag}"
      cpu    = 0.5
      memory = "1Gi"
      env {
        name  = "DB_HOST"
        value = var.db_host
      }
      env {
        name        = "DB_PASSWORD"
        secret_name = "db-password"
      } # from Key Vault
      env {
        name        = "JWT_SECRET"
        secret_name = "jwt-secret"
      }
      env {
        name        = "STRIPE_KEY"
        secret_name = "stripe-key"
      }
      env {
        name        = "BTC_XPUB"
        secret_name = "btc-xpub"
      }
      liveness_probe {
        transport = "HTTP"
        port      = 80
        path      = "/health.php"
      }
    }
    dynamic "secret" { # one block per Key Vault secret
      for_each = var.kv_secret_ids
      content {
        name                = secret.key
        key_vault_secret_id = secret.value
        identity            = azurerm_user_assigned_identity.app.id
      }
    }
  }
  depends_on = [
    azurerm_role_assignment.acr_pull,
    azurerm_role_assignment.kv_secret_user
  ]
}

