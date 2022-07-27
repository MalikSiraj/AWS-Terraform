
data "aws_availability_zones" "available" {
  state = "available"
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

module "vpc" {
    source = "../../modules/vpc"
    infra_env = "TerraformTest"
    vpc_cidr = "10.12.0.0/16"
    vpc_public_subnet_cidr = ["10.12.1.0/24", "10.12.2.0/24","10.12.3.0/24", "10.12.4.0/24", "10.12.5.0/24", "10.12.6.0/24","10.12.7.0/24", "10.12.8.0/24"]
    vpc_private_subnet_cidr = ["10.12.21.0/24", "10.12.20.0/24"]

}
