
# VPC

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

# Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.igw_name
  }
}

# Public Subnet

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_name
  }
}

# Private Subnet

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = var.private_subnet_name
  }
}

# Elastic IP for NAT Gateway

resource "aws_eip" "nat_eip" {

  domain = "vpc"

  tags = {
    Name = "NAT-EIP"
  }
}

# NAT Gateway

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  connectivity_type = "public"

  tags = {
    Name = "Terraform-NAT"
  }
}

# Public Route Table

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id

  }

  tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_route_table_association" "public" {

  subnet_id      = aws_subnet.public.id

  route_table_id = aws_route_table.public_rt.id

}

# Private Route Table

resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat.id

  }

  tags = {

    Name = var.private_route_table_name

  }

}

resource "aws_route_table_association" "private" {

  subnet_id = aws_subnet.private.id

  route_table_id = aws_route_table.private_rt.id

}

# Security Group

resource "aws_security_group" "web_sg" {

  name = var.security_group_name

  description = "Allow SSH and HTTP"

  vpc_id = aws_vpc.main.id

  ingress {

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}

# Public EC2

resource "aws_instance" "public_instance" {

  ami = var.ami_id

  instance_type = var.instance_type

  subnet_id = aws_subnet.public.id

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {

    Name = var.public_instance_name

  }

}

# Private EC2

resource "aws_instance" "private_instance" {

  ami = var.ami_id

  instance_type = var.instance_type

  subnet_id = aws_subnet.private.id

  associate_public_ip_address = false

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {

    Name = var.private_instance_name

  }

}