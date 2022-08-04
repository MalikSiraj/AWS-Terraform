module "vpc" {
    source = "../../modules/vpc"
    infra = "TerraformTest"
    vpc_cidr = "10.12.0.0/16"
    #vpc_public_subnet_cidr = ["10.12.0.0/24","10.12.1.0/24","10.12.2.0/24"]
    vpc_public_subnet_cidr = [ "10.12.0.0/24" ]
    vpc_private_subnet_cidr = [ "10.12.3.0/24" ]
    enable_nat_gateway = false
}