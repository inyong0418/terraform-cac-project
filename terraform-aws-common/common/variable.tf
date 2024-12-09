variable "region" {
  description = "The region where the resources are created."
  default     = "ap-northeast-2"
}

variable "user-id" {
  description = "User ID for restrict"
  type = string
  nullable = false

  validation {
    condition = !contains(["*"], var.user-id)
    error_message = "Do not use *"
  }
}

variable "duration" {
  description = "session duration"
  default = 2
  type = number
  nullable = false

  validation {
    condition = (var.duration) <= 2
    error_message = "Do not use *"
  }
}

variable "action" {
  description = "define action"
  type = string
  nullable = false

  validation {
    condition = !contains(["*"], var.action)
    error_message = "Do not use *"
  }
}

variable "cmdb-role" {
  description = "define cmdb-role"
  type = string
  nullable = false
}

variable "perms_s3" {
  description = "s3-permissions"
  type = list(object({
    s3_bucket_arn = string
    s3_access_point_arn = string
  }))
  nullable = false
  default = []
}

variable "resource_arn" {
  description = "s3-resource-arn"
  type = list(object({
    s3_bucket_arn = string
    s3_access_point_arn = string
  }))
  default = []
}

# variable "session-time" {
#   description = ""
# #  default = timeadd(timestamp(), var.duration)
#   type = string
#   nullable = false
# }