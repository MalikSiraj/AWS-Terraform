module "ec2" {
    source = "./modules/ec2"
    infra_env = ""
    subnets = keys(module.vpc.vpc_public_subnets)
    #security_group = module.vpc.security_group
    instance_type = "t2.micro"
    instance_ami = "ami-0cff7528ff583bf9a"
}

module "vpc" {
    source = "./modules/vpc"
    infra_env = "TerraformTest"
    vpc_cidr = "10.0.0.0/16"
}