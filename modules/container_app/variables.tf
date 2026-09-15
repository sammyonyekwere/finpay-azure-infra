
variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "container_apps_subnet_id" {
  type = string
}

variable "acr_login_server" {
  type = string
}


variable "min_replicas" {
  type = number
}

variable "max_replicas" {
  type = number
}

variable "name_prefix" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "db_host" {
  type = string
}

variable "kv_secret_ids" {
  type = map(string)
}

variable "identity_id" {
  type = string
}
