provider "aws" {
  region = "us-east-1" # Update to your preferred region
}

module "vpc" {
  source = "./vpc"
}

module "rds" {
  source = "./rds"
  vpc_id        = module.vpc.vpc_id
  db_subnet_ids = module.vpc.db_subnet_ids
}

module "ecs" {
  source            = "./ecs"
  vpc_id            = module.vpc.vpc_id
  ecs_subnet_ids    = module.vpc.ecs_subnet_ids
  container_image   = "sinhapragya020/ipfs-metadata-app:latest"
  container_port    = 8080
  rds_endpoint      = module.rds.db_endpoint
  rds_username      = var.db_username
  rds_password      = var.db_password
}

module "loadbalancer" {
  source            = "./loadbalancer"
  vpc_id            = module.vpc.vpc_id
  ecs_target_group_arn = module.ecs.target_group_arn
}