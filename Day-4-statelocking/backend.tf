terraform {
  backend "s3" {
    bucket = "terraform-statefileconfig"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}