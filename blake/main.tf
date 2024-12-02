terraform {
#  cloud {
#    organization = "cac-org"
#    hostname     = "app.terraform.io" # default

#    workspaces {
#      name = "terraform-aws-tfc-workflow"
#    }
#  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      name        = "${var.user-id}-iam-policy"
      role = var.user-id
    }
  }
}

resource "aws_iam_policy" "cac-policy" {
  name     = "${var.user-id}-policy"
  policy = data.aws_iam_policy_document.cac-policy.json
}


resource "aws_iam_role_policy_attachment" "readonly-attach" {
  role       = "SAML_Developer-1"
  policy_arn = aws_iam_policy.cac-policy.arn
}



