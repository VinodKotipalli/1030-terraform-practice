resource "aws_instance" "name" {
  ami = "ami-0b826bb6d96d2afe"
  instance_type = "t3.small"
  tags = {
    Name = "Test"
  }
 
lifecycle {
    ignore_changes = [ tags ]

}
lifecycle {
  create_before_destroy = true
}

 lifecycle {
    prevent_destroy = true
}

}

