variable "cidr_block" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = ""
  
}

variable "tag" {
    description = "The name tag for the VPC"
    type        = string
    default     = ""
  
}

variable "cidr_block-vpc-2" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = ""


  
}

variable "cidr_block_subnet" {
    description = "The CIDR block for the Subnet"
    type        = string
    default     = ""
}

variable "tag_subnet" {
    description = "The name tag for the Subnet"
    type        = string
    default     = "vinod"
}