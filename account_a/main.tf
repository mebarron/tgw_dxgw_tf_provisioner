terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

variable AWS_ACCOUNT_A_NUMBER {}

provider "aws" {
  region = "us-west-2"
  #assume_role {
   # role_arn     = "arn:aws:iam::${var.AWS_ACCOUNT_A_NUMBER}:role/tfrunner"
    #session_name = "tfsession-us-west-2"
  #}
}

# Create transit gateway

module "tgw" {
  source  = "../../../tfmodules/terraform-aws-transit-gateway"

  name             = "us-west-test-tgw"
  description      = "Test transit gateway"
  amazon_side_asn  = 65401

  enable_auto_accept_shared_attachments = false

  vpc_attachments = {
    vpc = {
      vpc_id       = module.vpc.vpc_id
      subnet_ids   = module.vpc.private_subnets
      dns_support  = true
      ipv6_support = true

      tgw_routes = [
        {
          destination_cidr_block = "10.0.0.0/16"
        },
        {
          blackhole = true
          destination_cidr_block = "40.0.0.0/20"
        }
      ]
    }
  }
  tags = {
    Purpose = "us-west-test-tgw"
  }
}

# Create VPC

module "vpc" {
  source  = "../../../tfmodules/terraform-aws-vpc"

  name = "us-west-test-vpc"

  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [0, 1, 2]
}

resource "aws_ec2_transit_gateway_policy_table" "test-tgw-policy" {
  transit_gateway_id = module.tgw.ec2_transit_gateway_id

  tags = {
    segment = "prod"
  }
}

data "aws_region" "current" {}

output "account_a_tgw_id" {
  value = module.tgw.ec2_transit_gateway_id
}

output "account_a_tgw_region" {
  value = data.aws_region.current
}

output "account_a_tgw_owner_id" {
  value = module.tgw.ec2_transit_gateway_owner_id
}
