terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.54.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#creation of VPC with custom network configuration
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "custom_vpc"
  }
}

#creation of subnet with custom network configuration
resource "aws_subnet" "custom_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "custom_subnet"
  }
}

#creation of internet gateway with custom network configuration
resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "custom_igw"
  }
}

#creation of route table with custom network configuration
resource "aws_route_table" "custom_route_table" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "custom_route_table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }
}

#creation of route table association with custom network configuration
resource "aws_route_table_association" "custom_route_table_association" {
  subnet_id      = aws_subnet.custom_subnet.id
  route_table_id = aws_route_table.custom_route_table.id
}

#creation of security group with custom network configuration
resource "aws_security_group" "custom_security_group" {
  name        = "custom_security_group"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.custom_vpc.id

  #creation of ingress and egress rules for security group with custom network configuration
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#creation of EC2 instance with custom network configuration
resource "aws_instance" "custom_instance" {
  ami                         = "ami-01edba92f9036f76e"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.custom_subnet.id
  vpc_security_group_ids      = [aws_security_group.custom_security_group.id]
  associate_public_ip_address = true
  tags = {
    Name = "custom_instance"
  }
}

#create private server with custom network configuration
resource "aws_subnet" "custom_private_subnet" {
  vpc_id                  = aws_vpc.custom_private_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "custom-public-nat-subnet"
  }
}

resource "aws_eip" "custom_private_eip" {
  domain = "vpc"

  tags = {
    Name = "custom-private-eip"
  }
}

resource "aws_nat_gateway" "custom_private_nat" {
  subnet_id     = aws_subnet.custom_private_subnet.id
  allocation_id = aws_eip.custom_private_eip.id
  depends_on = [
    aws_internet_gateway.custom_private_igw
  ]
  tags = {
    Name = "custom-private-nat"
  }
}

resource "aws_route_table" "custom_private_public_rt" {
  vpc_id = aws_vpc.custom_private_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_private_igw.id
  }

  tags = {
    Name = "custom-private-public-route-table"
  }
}

resource "aws_route_table_association" "custom_private_public_route_table_association" {
  subnet_id      = aws_subnet.custom_private_subnet.id
  route_table_id = aws_route_table.custom_private_public_rt.id
}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.custom_private_vpc.id


  tags = {
    Name = "private-route-table"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.custom_private_nat.id
  }
}

resource "aws_route_table_association" "custom_private_route_table_association" {
  subnet_id      = aws_subnet.custom_private_subnet-1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_instance" "custom_private_instance" {
  ami                         = "ami-01edba92f9036f76e"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.custom_private_subnet-1.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.custom_private_sg.id]
  tags = {
    Name = "custom-private-instance"
  }
}

# creation of RDS instance with custom network configuration

# creation of VPC for RDS instance with custom network configuration
resource "aws_vpc" "custom_private_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "custom-private-vpc"
  }
}

# Internet gateway for the private VPC (required by the NAT gateway)
resource "aws_internet_gateway" "custom_private_igw" {
  vpc_id = aws_vpc.custom_private_vpc.id
  tags = {
    Name = "custom_private_igw"
  }
}


# creation of private subnets for RDS instance with custom network configuration
# Private Subnet 1
resource "aws_subnet" "custom_private_subnet-1" {
  vpc_id            = aws_vpc.custom_private_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "custom-private-subnet-1"
  }
}


# Private Subnet 2
resource "aws_subnet" "custom_private_subnet-2" {
  vpc_id            = aws_vpc.custom_private_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "custom-private-subnet-2"
  }
}


# creation of security group for RDS instance with custom network configuration
resource "aws_security_group" "custom_private_sg" {
  name        = "custom-private-sg"
  description = "Security group for EC2"
  vpc_id      = aws_vpc.custom_private_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "custom-private-sg"
  }
}


# RDS Security Group
resource "aws_security_group" "custom_rds_sg" {
  name        = "custom-rds-sg"
  description = "Allow MySQL from EC2"
  vpc_id      = aws_vpc.custom_private_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.custom_private_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "custom-rds-sg"
  }
}


# RDS DB Subnet Group
resource "aws_db_subnet_group" "custom_db_subnet_group" {
  name = "custom-db-subnet-group"

  subnet_ids = [
    aws_subnet.custom_private_subnet-1.id,
    aws_subnet.custom_private_subnet-2.id
  ]

  tags = {
    Name = "custom-db-subnet-group"
  }
}


# RDS MySQL Instance
resource "aws_db_instance" "custom_rds" {
  identifier = "custom-rds"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"

  db_name  = "TerraformDB"
  username = "admin"
  password = "Admin1234!"

  port = 3306

  db_subnet_group_name = aws_db_subnet_group.custom_db_subnet_group.name

  vpc_security_group_ids = [
    aws_security_group.custom_rds_sg.id
  ]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = 0

  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "Terra-rds"
  }
}





