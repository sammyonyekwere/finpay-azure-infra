
variable "acr_id" {
  description = "Azure Container Registry ID"
  type        = string
}

variable "key_vault_id" {
  description = "Key Vault ID"
  type        = string
}

variable "location" {
  description = "Location"
  type        = string
}


variable "resource_group_name" {
  description = "The name of the Resource Group"
  type        = string
}

variable "name_prefix" {
  description = "The name prefix"
  type        = string
}