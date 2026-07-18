variable "iam_user_name" {
  description = "IAM User Name"
  type        = string
  default = ""
}

variable "iam_group_name" {
  description = "IAM Group Name"
  type        = string
  default = ""
}

variable "iam_role_name" {
  description = "IAM Role Name"
  type        = string
  default = ""
}

variable "instance_profile_name" {
  description = "EC2 Instance Profile"
  type        = string
  default = ""
}

variable "policy_name" {
  description = "IAM Policy Name"
  type        = string
  default = ""
}