variable "secrets" {
  description = "Map of secret name to secret value to store in Key Vault"
  type        = map(string)
  sensitive   = true
}

variable "deployer_principal_id" {
  description = "The ID of the Azure role assignment deployer"
  type        = string
}

variable "tenant_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "name_prefix" {
  type = string
}