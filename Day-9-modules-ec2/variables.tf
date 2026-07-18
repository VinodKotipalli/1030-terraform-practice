variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = ""
}

variable "tags" {
  description = "The tags for the EC2 instance"
  type        = string
  default     = ""
}

variable "user_name" {
  description = "The name of the IAM user"
  type        = string
  default     = "dev"
}


