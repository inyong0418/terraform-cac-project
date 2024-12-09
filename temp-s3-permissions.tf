
locals {
    std_perms_s3_resources = flatten([
        [for s3_bucket in var.perms_s3 : [s3_bucket["s3_bucket_arn"], "${s3_bucket["s3_bucket_arn"]}/*"] if lookup(s3_bucket, "s3_bucket_arn", null) != null],
        [for s3_bucket in var.perms_s3 : [s3_bucket["s3_access_point_arn"], "${s3_bucket["s3_access_point_arn"]}/*"] if lookup(s3_bucket, "s3_access_point_arn", null) != null]
    ])

    create_std_perms_policy = anytrue(
        length(var.var.perms_s3) > 0,
    )
}

resource "random_string" "std_perms_s3_policy_sid_suffix" {
    count = 3
    length = 10
    special = false
    upper = false
    lower = false
}

data "aws_iam_policy_document" "std_perms" {
    dynamic "statement" {
        for_each = length(var.perms_s3) > 0 ? [""] : []
        content {
          sid = "CAC Reference PolicyIDs${random_string.std_perms_s3_policy_sid_suffix[0].id}"
          effect = "Allow"
          actions = [
            "s3:List*",
            "s3:HeadBucket",
          ]
          resources = ["*"]
        }
    }
    dynamic "statement" {
        for_each = length(var.perms_s3) > 0 ? [""] : []
        content {
          sid = "CAC Reference PolicyIDs${random_string.std_perms_s3_policy_sid_suffix[1].id}"
          effect = "Allow"
          actions = [
            "s3:PutObjet",
          ]
          resources = local.std_perms_s3_resources
        }
    }
}