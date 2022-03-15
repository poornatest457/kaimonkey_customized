terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.11"
    }
  }
}

provider "aws" {
  region = var.region
}

# module "network" {
#   source       = "./modules/network"
#   environment  = var.environment
#   default_tags = var.default_tags
# }


module "compute" {
  source = "./modules/compute"
  environment = var.environment
  region = var.region
  elb_target_group_arn = module.network.target_lb_group_arn
  private_subnet = module.network.private_subnet
  public_subnet = module.network.public_subnet
  elb_sg = module.network.target_lb_security_group
  elb_url = module.network.elb_url
}

resource "local_file" "web-access" {
  content  = <<JSON
{
  "fqdn": "${module.network.elb_url}"
}
  JSON
  filename = "./web-access.json"
}
