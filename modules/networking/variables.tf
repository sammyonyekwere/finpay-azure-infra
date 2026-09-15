variable "name_prefix" {
  type = string
}

variable "vnet_address_space" {
  type    = string
  default = "10.0.0.0/16"
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}
