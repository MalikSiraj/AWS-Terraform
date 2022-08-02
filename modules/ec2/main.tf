resource "aws_instance" "ec2Instance" {
    
    #count = length(var.subnets)
    
    ami = var.instance_ami
    instance_type = var.instance_type
    subnet_id = var.subnets[0]
    vpc_security_group_ids = var.vpc_security_group_ids
    associate_public_ip_address = true

    root_block_device{
        volume_size = var.instance_storage
        volume_type = "gp2"
    }
    user_data = var.user_data_base64
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
resource "aws_eip" "ec2-ip" {
    vpc = true
    
    tags = {
      Name = "${var.infra_env}-ec2-ip"
    }
  
}

resource "aws_eip_association" "ec2-ip" {
    instance_id = aws_instance.ec2Instance.id
    allocation_id = aws_eip.ec2-ip.id
  
}
