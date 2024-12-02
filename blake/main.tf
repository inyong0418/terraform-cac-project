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
      name        = "${var.user-id[0]}-iam-policy"
      role = var.user-id[0]
    }
  }
}

locals {
  session = timeadd(timestamp(), join("",[var.duration, "h"]))
  cac_account = "851725357209"
}

data "aws_iam_policy_document" "cac-policy" {
  statement {
    sid = "1"

    actions = [
      "${var.action}:PutObject",
    ]

    resources = [
        "arn:aws:s3:::blake-test-1234567",
        "arn:aws:s3:::blake-test-1234567/*",
    ]

    condition {
      test     = "StringLike"
      variable = "aws:userid"
      values   = ["*:${var.user-id[0]}"]
    }
#
    condition {
      test     = "DateLessThan"
      variable = "aws:CurrentTime"
      values   = ["${local.session}"]
    }
  }
}

resource "aws_iam_policy" "cac-policy" {
  name     = "${var.user-id[0]}-policy"
  policy = data.aws_iam_policy_document.cac-policy.json
}


resource "aws_iam_role_policy_attachment" "readonly-attach" {
  role       = "SAML_Developer-1"
  policy_arn = aws_iam_policy.cac-policy.arn
}


