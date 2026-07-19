resource "aws_vpc" "custom_private_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "custom-private-vpc"
  }
}

resource "aws_internet_gateway" "custom_private_igw" {
  vpc_id = aws_vpc.custom_private_vpc.id

  tags = {
    Name = "custom_private_igw"
  }
}

resource "aws_subnet" "custom_private_subnet-1" {
  vpc_id            = aws_vpc.custom_private_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "custom-private-subnet-1"
  }
}

resource "aws_subnet" "custom_private_subnet-2" {
  vpc_id            = aws_vpc.custom_private_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "custom-private-subnet-2"
  }
}

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

resource "aws_db_subnet_group" "custom_db_subnet_group" {
  name = "custom-db-subnet-group"

  subnet_ids = [
    aws_subnet.custom_private_subnet-1.id,
    aws_subnet.custom_private_subnet-2.id,
  ]

  tags = {
    Name = "custom-db-subnet-group"
  }
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  identifier = "nit-rds-instance"
  engine = "mysql"
  engine_version = "8.0"
  family = "mysql8.0"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  max_allocated_storage = 100
  storage_type = "gp2"

  db_name = "mydatabase"
  username = "admin"
  manage_master_user_password = true
  port = 3306

  publicly_accessible = false
  multi_az = false

  db_subnet_group_name = aws_db_subnet_group.custom_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.custom_rds_sg.id]
  create_db_parameter_group = false
  create_db_option_group = false
  backup_retention_period = 1
  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "NIT-RDS-instance"
  }
}
