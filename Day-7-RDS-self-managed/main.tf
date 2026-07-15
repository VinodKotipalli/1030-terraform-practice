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
  storage_type          = "gp2"

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

resource "aws_security_group" "custom_redis_sg" {
  name        = "custom-redis-sg"
  description = "Security group for Redis"
  vpc_id      = aws_vpc.custom_private_vpc.id

  ingress {
    from_port       = 6379
    to_port         = 6379
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
    Name = "custom-redis-sg"
  }
}

resource "aws_elasticache_subnet_group" "custom_redis_subnet_group" {
  name       = "custom-redis-subnet-group"
  subnet_ids = [
    aws_subnet.custom_private_subnet-1.id,
    aws_subnet.custom_private_subnet-2.id
  ]

  tags = {
    Name = "custom-redis-subnet-group"
  }
}

resource "aws_elasticache_replication_group" "custom_redis" {
  replication_group_id = "custom-redis"

  description = "Redis cache for application"

  engine         = "redis"
  engine_version = "7.1"

  node_type = "cache.t3.micro"
  port      = 6379

  num_cache_clusters = 1

  subnet_group_name = aws_elasticache_subnet_group.custom_redis_subnet_group.name

  security_group_ids = [
    aws_security_group.custom_redis_sg.id
  ]

  automatic_failover_enabled = false
  multi_az_enabled           = false

  tags = {
    Name = "custom-redis"
  }
}