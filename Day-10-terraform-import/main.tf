resource "aws_instance" "name" {
  ami = "ami-0b826bb6d96d2afe4"
  instance_type = "t3.small"
  tags = {
    Name = "Test"
  }
}

resource "aws_s3_bucket" "name" {
  bucket = "kkkk-kkk-imp"
}

resource "aws_s3_bucket_versioning" "example_versioning" {
  bucket = aws_s3_bucket.name.id

  versioning_configuration {
    status = "Enabled"
  }
}