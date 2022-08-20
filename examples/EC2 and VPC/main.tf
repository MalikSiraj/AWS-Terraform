module "vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  #version        = "2.38.0"
  name           = "EC2-VPC"
  cidr           = "10.13.0.0/16"
  azs            = ["us-east-1a"]
  public_subnets = ["10.13.1.0/24"]
  tags = {
    "env"       = "dev"
    "createdBy" = "Siraj"
  }
}

locals {
  instance-userdata = <<EOF
#!/bin/bash
echo "*** Installing apache2"
sudo mkdir test 
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
echo "*** Completed Installing apache2"
EOF
}
data "aws_key_pair" "MyEC2Key" {
  key_name = "AlwaysEC2"
}

module "EC2" {
    source = "../../modules/ec2"
    subnets = module.vpc.public_subnets 
    security_group_id = module.sg.security_group_ec2_id
    user_data_base64 = "${base64encode(local.instance-userdata)}"
}
module "sg" {
  source = "../../modules/sg"
  vpc_id = module.vpc.vpc_id

  
}