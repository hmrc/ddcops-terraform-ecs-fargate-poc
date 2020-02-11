/*====
Variables used across all modules
======*/
locals {
  sandbox_availability_zones = ["eu-west-2a", "eu-west-2b"]
}

provider "aws" {
  region  = var.region
  profile = "ddcops-sandbox"
}

//resource "aws_key_pair" "key" {
//  key_name = "sandbox_key"
//  // get this from a pki somewhere
//  public_key = file("sandbox_key.pub")
//}

module "networking" {
  source               = "./modules/networking"
  environment          = "sandbox"
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.10.0/24", "10.0.20.0/24"]
  region               = var.region
  availability_zones   = local.sandbox_availability_zones
  key_name             = "sandbox_key"
}

module "rds" {
  source            = "./modules/rds"
  environment       = "sandbox"
  allocated_storage = "20"
  database_name     = var.sandbox_database_name
  database_username = var.sandbox_database_username
  database_password = var.sandbox_database_password
  subnet_ids        = module.networking.private_subnets_id
  vpc_id            = module.networking.vpc_id
  instance_class    = "db.t2.micro"
}

module "ecs" {
  source             = "./modules/ecs"
  environment        = "sandbox"
  vpc_id             = module.networking.vpc_id
  availability_zones = local.sandbox_availability_zones
  repository_name    = "deskpro/sandbox"
  subnets_ids        = module.networking.private_subnets_id
  public_subnet_ids  = module.networking.public_subnets_id
  security_groups_ids = [
    "module.rds.db_access_sg_id",
  ]
#fixme
  #security_groups_ids = [
  #  "module.networking.security_groups_ids",
  #  "module.rds.db_access_sg_id",
  #]
  database_endpoint = module.rds.rds_address
  database_name     = var.sandbox_database_name
  database_username = var.sandbox_database_username
  database_password = var.sandbox_database_password
  secret_key_base   = var.sandbox_secret_key_base
}

