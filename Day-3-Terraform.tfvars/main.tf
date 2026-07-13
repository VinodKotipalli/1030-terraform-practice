resource "aws_instance" "name" {
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = var.tags
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-123456"
}

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"
}
