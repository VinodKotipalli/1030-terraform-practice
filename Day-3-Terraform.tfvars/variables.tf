variable "ami" {
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

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  
}

