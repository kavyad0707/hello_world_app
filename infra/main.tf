locals {
  tags = {
    Project = var.project_name
    Managed = "terraform"
  }
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  tags         = local.tags
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
  tags         = local.tags
}

module "ecs" {
  source               = "./modules/ecs"
  project_name         = var.project_name
  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  container_port       = var.container_port
  ecr_repository_url   = module.ecr.repository_url
  app_healthcheck_path = var.app_healthcheck_path
  tags                 = local.tags
}
