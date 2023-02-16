terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

variable AWS_ACCOUNT_B_NUMBER {}

provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::${var.AWS_ACCOUNT_B_NUMBER}:role/tfrunner"
    session_name = "tfsession-us-east-1"
  }
}

locals {
  account_a_data = jsondecode(file("../account_a_attachment/terraform.tfstate"))
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "account-b-peering-accepter" {
  transit_gateway_attachment_id = local.account_a_data.outputs.account_a_attachment_id.value

  tags = {
    Name = "Example cross-account attachment"
  }
}

