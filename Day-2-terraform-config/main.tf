resource "aws_vpc" "dev" {
    cidr_block = "var.cidr_block"
    tags = {
        Name = "var.tag"
    }
  
}

resource "aws_vpc" "test" {
    cidr_block = "var.cidr_block-vpc-2"
    tags = {
        Name = "var.tag-vpc-2"
    }
  
}

resource "aws_subnet" "dev" { 
    vpc_id = aws_vpc.dev.id
    cidr_block = "var.cidr_block_subnet"
    tags = {
        Name = "dev"
    }
}

resource "s3_bucket" "my_bucket" {
    bucket = "my-unique-bucket-name-123456"
    acl    = "public-read"
}