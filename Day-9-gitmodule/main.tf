module "terra" {
 source =  "github.com/CloudTechDevOps/1030-terraform-practice/Day-9-Modules-ec2"
 ami_id = "ami-01edba92f9036f76e"
    instance_type = "t3.micro"
    tags = "terra-instance"

}
