terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

variable AWS_ACCOUNT_A_NUMBER {}
variable AWS_ACCOUNT_B_NUMBER {}
variable AWS_DX_ACCOUNT_NUMBER {}

provider "aws" {
  alias  = "aws-dxgw-account"
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::${var.AWS_DX_ACCOUNT_NUMBER}:role/tfrunner"
    session_name = "tfsession-us-east-1"
  }
}

provider "aws" {
  alias  = "aws-account-a-west"
  region = "us-west-2"
  #assume_role {
  #  role_arn     = "arn:aws:iam::${var.AWS_ACCOUNT_A_NUMBER}:role/tfrunner"
  #  session_name = "tfsession-us-west-2"
  #}
}

provider "aws" {
  alias  = "aws-account-b-east"
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::${var.AWS_ACCOUNT_B_NUMBER}:role/tfrunner"
    session_name = "tfsession-us-east-1"
  }
}

locals {
  account_a_data = jsondecode(file("../account_a/terraform.tfstate"))
  account_b_data = jsondecode(file("../account_b/terraform.tfstate"))
}

resource "aws_dx_gateway" "test-dxgw" {
  provider        = aws.aws-dxgw-account
  name            = "east-test-dxgw"
  amazon_side_asn = "65001"
}

resource "aws_dx_gateway_association_proposal" "account_a_proposal" {
  provider                    = aws.aws-account-a-west
  depends_on                  = [aws_dx_gateway.test-dxgw]
  dx_gateway_owner_account_id = aws_dx_gateway.test-dxgw.owner_account_id
  dx_gateway_id               = aws_dx_gateway.test-dxgw.id
  associated_gateway_id       = local.account_a_data.outputs.account_a_tgw_id.value 
  
  allowed_prefixes = [
    "10.0.0.0/16"
  ]
}

resource "aws_dx_gateway_association_proposal" "account_b_proposal" {
  provider                    = aws.aws-account-b-east
  depends_on                  = [aws_dx_gateway.test-dxgw]  
  dx_gateway_owner_account_id = aws_dx_gateway.test-dxgw.owner_account_id 
  dx_gateway_id               = aws_dx_gateway.test-dxgw.id
  associated_gateway_id       = local.account_b_data.outputs.account_b_tgw_id.value

  allowed_prefixes = [
    "192.0.0.0/16"
  ]
}

resource "aws_dx_gateway_association" "account_a_association" {
  provider                             = aws.aws-dxgw-account
  depends_on                           = [aws_dx_gateway_association_proposal.account_a_proposal]  
  proposal_id                          = aws_dx_gateway_association_proposal.account_a_proposal.id
  dx_gateway_id                        = aws_dx_gateway.test-dxgw.id
  associated_gateway_owner_account_id  = local.account_a_data.outputs.account_a_tgw_owner_id.value
}

resource "aws_dx_gateway_association" "account_b_association" {
  provider                             = aws.aws-dxgw-account
  depends_on                           = [aws_dx_gateway_association_proposal.account_b_proposal]
  proposal_id                          = aws_dx_gateway_association_proposal.account_b_proposal.id
  dx_gateway_id                        = aws_dx_gateway.test-dxgw.id
  associated_gateway_owner_account_id  = local.account_b_data.outputs.account_b_tgw_owner_id.value
}
