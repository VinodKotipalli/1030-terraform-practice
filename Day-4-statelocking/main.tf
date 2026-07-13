resource "aws_instance" "name" {
  ami           = "ami-01edba92f9036f76e"
  instance_type = "t3.micro"
  tags = {
    Name = "dev"
  }
}

resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }

}
