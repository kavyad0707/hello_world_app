variable "project_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "container_port" {
  type = number
}
variable "ecr_repository_url" {
  type = string
}
variable "app_healthcheck_path" {
  type = string
}
variable "tags" {
  type = map(string)
}
