variable "infra_env" {
    type = string
    description = "Environment namespace"
    default = "Terraform"  
}

variable "instance_type" {
    type = string
    description = "Type of EC2 instance"
    default = "t3.micro"
}
variable "instance_ami" {
    type = string
    description = "AMI of EC2 instance"  
}
variable "instance_storage" {
    type = number
    description = "Total number of EBS"
    default = 8
}


variable "subnets"{
    type = list(string)
    description = "list of subnets to create Ec2 instance"
}
variable "security_group" {
    type = list(string)
    description = "list of security group to attach to EC2 instance"
    default = [  ]
}