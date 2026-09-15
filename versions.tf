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
    resource_group_name  = "rg-finpayinfra-tfstate"
    storage_account_name = "stfinpayinfratfstatetbc"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
