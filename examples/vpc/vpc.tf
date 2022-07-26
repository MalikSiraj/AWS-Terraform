module "vpc" {
    source = "../../modules/vpc"
    infra_env = "TerraformTest"
    vpc_cidr = "10.0.0.0/16"
}