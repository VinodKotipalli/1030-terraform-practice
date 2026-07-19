# VPC
vpc_cidr = "10.0.0.0/16"
vpc_name = "Custom-VPC"

# Public Subnet
public_subnet_cidr = "10.0.1.0/24"
public_subnet_name = "Public-Subnet"

# Private Subnet
private_subnet_cidr = "10.0.2.0/24"
private_subnet_name = "Private-Subnet"

# Availability Zone
availability_zone = "us-east-1a"

# Internet Gateway
igw_name = "Custom-IGW"

# Elastic IP
# (eip_name is declared in variables.tf but not used in current config)
eip_name = "NAT-EIP"

# NAT Gateway
nat_gateway_name = "Custom-NAT"

# Route Tables
public_route_table_name = "Public-Route-Table"
private_route_table_name = "Private-Route-Table"

# Security Group
security_group_name = "Web-SG"

# EC2
ami_id = "ami-020cba7c55df1f615"
instance_type = "t3.micro"

public_instance_name = "Public-EC2"
private_instance_name = "Private-EC2"
