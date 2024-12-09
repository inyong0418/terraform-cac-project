#terraform {
#  cloud {
#    organization = "cac-org"
#    hostname     = "app.terraform.io" # default

#    workspaces {
#      name = "terraform-aws-tfc-workflow"
#    }
#  }
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

# provider "aws" {
#   region = var.region
#   default_tags {
#     tags = {
#       role = var.cmdb-role
#     }
#   }
# }

 locals {
   session-module = timeadd(timestamp(), join("",[var.duration, "h"]))
 }

data "aws_iam_policy_document" "cac-policy-module" {
  statement {
    sid = "1"

    actions = [
      var.action,
    ]
#
    resources = [
        "arn:aws:s3:::${var.resource_arn}",
        "arn:aws:s3:::${var.resource_arn}/*",
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
   policy = data.aws_iam_policy_document.cac-policy-module.json
 }


 resource "aws_iam_role_policy_attachment" "policy-attach" {
   role       = "SAML_Developer-1"
   policy_arn = aws_iam_policy.cac-policy.arn
 }


