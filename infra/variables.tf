variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "container_port" {
  type = number
}

variable "app_healthcheck_path" {
  type = string
}

variable "tags" {
  type = map(string)
}