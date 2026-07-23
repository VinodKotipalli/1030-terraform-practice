data "aws_subnet" "main" {
  filter {
    name   = "tag:Name"
    values = ["subnet-1"]
  }
}

data "aws_security_group" "main" {
  filter {
    name   = "tag:Name"
    values = ["my-security-group"]
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0b826bb6d96d2afe4"
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnet.main.id
  vpc_security_group_ids = [data.aws_security_group.main.id]

  tags = {
    Name = "Terraform-EC2"
  }
}