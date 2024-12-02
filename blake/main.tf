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

locals {
  session = timeadd(timestamp(), var.duration + "h")
}

data "aws_iam_policy_document" "cac-policy" {
  statement {
    sid = "1"

    actions = [
      "s3:PutObject",
    ]

    resources = [
        "arn:aws:s3:::blake-test-1234567",
        "arn:aws:s3:::blake-test-1234567/*",
    ]

    condition {
      test     = "StringLike"
      variable = "aws:userid"
      values   = ["*:${var.user-id}"]
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
  name     = "${var.user-id}-policy"
  policy = data.aws_iam_policy_document.cac-policy.json
}


resource "aws_iam_role_policy_attachment" "readonly-attach" {
  role       = "SAML_Developer-1"
  policy_arn = aws_iam_policy.cac-policy.arn
}


