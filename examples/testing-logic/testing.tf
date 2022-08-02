
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_key_pair" "example" {
  key_name           = "AlwaysEC2"
  include_public_key = true
}

output "avalibility_zone" {
  value = length(data.aws_availability_zones.available.names)
}
variable "vpc_public_subnet_cidr" {
    type = list(string)
    default = ["10.12.1.0/24", "10.12.2.0/24","10.12.3.0/24", "10.12.4.0/24"]
}

output "vpc_cidr" {
    value = length(var.vpc_public_subnet_cidr)
}

output "public-subnets" {
    value = module.vpc.public-subnets[1].availability_zone
}
output "security-group" {
  value = module.vpc.security_group[0]
  
}

/*output "fingerprint" {
  value = data.aws_key_pair.example
}*/

locals {
  user_data = <<-EOT
  #! /bin/bash
  sudo apt-get update
  sudo apt-get install -y apache2
  sudo systemctl start apache2
  sudo systemctl enable apache2
  echo "The page was created by the user data" | sudo tee /var/www/html/index.html
  EOT
}

module "vpc" {
    source = "../../modules/vpc"
    infra_env = "TerraformTest"
    vpc_cidr = "10.12.0.0/16"
    vpc_public_subnet_cidr = ["10.12.1.0/24", "10.12.2.0/24" ]
    #vpc_private_subnet_cidr = ["10.12.21.0/24", "10.12.22.0/24"]
    vpc_private_subnet_cidr = [ ]

}

module "ec2" {
    source = "../../modules/ec2"
    infra_env = "Terraform"
    subnets = keys(module.vpc.vpc_public_subnets)
    key_name = "AlwaysEC2"
    vpc_security_group_ids = [ module.vpc.security_group[0].id ]
    user_data_base64 = base64encode(local.user_data)
    user_data_replace_on_change = true
    instance_type = "t2.micro"
    instance_ami = "ami-0cff7528ff583bf9a"
}
