variable "project_name" {
  type        = string
  description = "Project name (also used as name prefix)."
  default     = "hello-fargate"
}

variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"
}

variable "container_port" {
  type        = number
  description = "Container port for the app."
  default     = 3000
}

variable "app_healthcheck_path" {
  type        = string
  description = "Health check path for ALB target group."
  default     = "/"
}
