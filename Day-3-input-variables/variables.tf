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

# terraform apply -var-ami=ami-01edba92f9036f76e -var-instance_type=t3.micro -var-tags=my_instance