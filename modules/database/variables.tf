variable "name_prefix" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "administrator_login" {
  type = string
}

variable "administrator_passwrd" {
  type = string
}

variable "mysql_subnet_id" {
  type = string
}

variable "mysql_private_dns_zone_id" {
  type = string
}

variable "storage_gb" {
  type = string
}

variable "sku_name" {
  type = string
}