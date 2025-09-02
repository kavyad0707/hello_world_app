project_name         = "hello-fargate"
region               = "us-east-1"
container_port       = 3000
app_healthcheck_path = "/"
tags = {
  "app-name"    = "hello-world-fargate-app"
  "created-by"  = "kavya"
  "team"        = "slipway"
  "environment" = "dev"
}