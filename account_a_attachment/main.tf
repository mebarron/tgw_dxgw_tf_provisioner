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
  assume_role {
    role_arn     = "arn:aws:iam::${var.AWS_ACCOUNT_A_NUMBER}:role/tfrunner"
    session_name = "tfsession-us-west-1"
  }
}

locals {
  account_a_data = jsondecode(file("../account_a/terraform.tfstate"))
  account_b_data = jsondecode(file("../account_b/terraform.tfstate"))
}

resource "aws_ec2_transit_gateway_peering_attachment" "account-a-peering-attachment" {
  peer_account_id         = local.account_b_data.outputs.account_b_tgw_owner_id.value
  peer_region             = local.account_b_data.outputs.account_b_tgw_region.value.name
  peer_transit_gateway_id = local.account_b_data.outputs.account_b_tgw_id.value
  transit_gateway_id      = local.account_a_data.outputs.account_a_tgw_id.value

  tags = {
    Name = "West Transit Gateway"
  }
}

output "account_a_attachment_id" {
  value = aws_ec2_transit_gateway_peering_attachment.account-a-peering-attachment.id
}
