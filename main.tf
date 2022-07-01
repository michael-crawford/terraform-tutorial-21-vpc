provider "aws" {
  region = var.region
}

locals {
  environment = var.environment
  company = var.company
  project = var.project

  common_tags = {
    Environment = local.environment
    Company     = local.company
    Project     = local.project
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "${local.environment}-VPC"
  cidr = var.vpc_cidr
  azs  = slice(data.aws_availability_zones.available.names,0,3)

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_dhcp_options = true
  dhcp_options_domain_name = var.domain

  // These need to be rewritten to use cidrsubnets with slice as a single statement)
  public_subnets   = [cidrsubnet(var.vpc_cidr, 5, var.zone_map[substr(data.aws_availability_zones.available.names[0],-1,1)]*8+0),
                      cidrsubnet(var.vpc_cidr, 5, var.zone_map[substr(data.aws_availability_zones.available.names[1],-1,1)]*8+0),
                      cidrsubnet(var.vpc_cidr, 5, var.zone_map[substr(data.aws_availability_zones.available.names[2],-1,1)]*8+0)]

  private_subnets  = [cidrsubnet(var.vpc_cidr, 5, var.zone_map[substr(data.aws_availability_zones.available.names[0],-1,1)]*8+2),
                      cidrsubnet(var.vpc_cidr, 5, var.zone_map[substr(data.aws_availability_zones.available.names[1],-1,1)]*8+2),
                      cidrsubnet(var.vpc_cidr, 5, var.zone_map[substr(data.aws_availability_zones.available.names[2],-1,1)]*8+2)]

  database_subnets = [cidrsubnet(var.vpc_cidr, 5, var.zone_map[substr(data.aws_availability_zones.available.names[0],-1,1)]*8+5),
                      cidrsubnet(var.vpc_cidr, 5, var.zone_map[substr(data.aws_availability_zones.available.names[1],-1,1)]*8+5),
                      cidrsubnet(var.vpc_cidr, 5, var.zone_map[substr(data.aws_availability_zones.available.names[2],-1,1)]*8+5)]

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.common_tags
}
