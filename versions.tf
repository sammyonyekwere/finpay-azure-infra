terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  
  backend "azurerm" {
    use_azuread_auth = true    # authenticate to state with Azure AD, not a key
    # resource_group_name / storage_account_name / container_name / key
    # are provided at init:  terraform init -backend-config=environments/dev.backend.hcl
  }
}
