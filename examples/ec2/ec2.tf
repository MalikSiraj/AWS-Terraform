/*
data "aws_ami_ids" "amazon" {
  owners = ["amazon"]
 

  filter {
    name   = "name"
    values = ["Amazon Linux 2 AMI (HVM)"]
    #values = ["amzn2-ami-hvm-*-gp2"]
  }
    filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
    filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
    filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
output "ami-id" {
    value = data.aws_ami_ids.amazon
  
}
*/
module "ec2" {
    source = "../../modules/ec2"
    infra_env = ""
    subnets = keys(module.vpc.vpc_public_subnets)
    security_group = module.vpc.security_group
    instance_type = "t2.micro"
    instance_ami = "ami-0cff7528ff583bf9a"
}