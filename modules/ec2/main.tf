data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon", "self"]
}
data "aws_key_pair" "MyEC2Key" {
  key_name = "AlwaysEC2"
}

resource "aws_instance" "ec2Instance" {
    count = length(var.subnets)   
    ami = data.aws_ami.amazon_linux.id
    instance_type = var.instance_type
    subnet_id = var.subnets[count.index]
    security_groups = [var.security_group_id]
    associate_public_ip_address = true
    key_name = data.aws_key_pair.MyEC2Key.key_name
    user_data_base64 = var.user_data_base64
    tags = {
      Name = "${var.infra_env}-ec2"
    }
}
/*
resource "random_shuffle" "subnets" {
    input        = ["us-east-1a", "us-east-1c", "us-east-1d", "us-east-1e"]
    #input =  var.subnets
    result_count = 1
  
}*/