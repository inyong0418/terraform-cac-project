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

variable "session-time" {
  description = ""
  type = string
  nullable = false

  validation {
    condition = (var.session-time - timestamp()) > 2
    error_message = "Do not use *"
  }
}