
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_address_space" {
  type    = string
  default = ["10.0.0.0/16"]
}


variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "administrator_login" {
  type = string
}

variable "storage_gb" {
  type = string
}

variable "administrator_passwrd" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "acr_id" {
  type = string
}

variable "secrets" {
  type      = map(string)
  sensitive = true
}

variable "max_replicas" {
  type = number
}

variable "min_replicas" {
  type = number
}

variable "image_tag" {
  type = string
}