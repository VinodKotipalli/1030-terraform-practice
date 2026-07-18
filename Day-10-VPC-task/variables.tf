variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default = ""
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default = ""
}

variable "public_subnet_cidr" {
  description = "CIDR block for Public Subnet"
  type        = string
  default = ""
}

variable "private_subnet_cidr" {
  description = "CIDR block for Private Subnet"
  type        = string
  default = ""
}

variable "public_subnet_name" {
  description = "Public Subnet Name"
  type        = string
  default = ""
}

variable "private_subnet_name" {
  description = "Private Subnet Name"
  type        = string
  default = ""
}

variable "availability_zone" {
  description = "Availability Zone"
  type        = string
  default = ""
}

variable "igw_name" {
  description = "Internet Gateway Name"
  type        = string
  default = ""
}

variable "eip_name" {
  description = "Elastic IP Name"
  type        = string
  default = ""
}

variable "nat_gateway_name" {
  description = "NAT Gateway Name"
  type        = string
  default = ""
}

variable "public_route_table_name" {
  description = "Public Route Table Name"
  type        = string
  default = ""
}

variable "private_route_table_name" {
  description = "Private Route Table Name"
  type        = string
  default = ""
}

variable "security_group_name" {
  description = "Security Group Name"
  type        = string
  default = ""
}

variable "ami_id" {
  description = "Amazon Machine Image ID"
  type        = string
  default = ""
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default = ""
}

variable "public_instance_name" {
  description = "Public EC2 Instance Name"
  type        = string
  default = ""
}

variable "private_instance_name" {
  description = "Private EC2 Instance Name"
  type        = string
  default = ""
}