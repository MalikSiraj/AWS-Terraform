variable "infra_env" {
    type = string
    description = "Environment namespace"
    default = "Terraform"  
}
variable "instance_type" {
    type = string
    description = "Type of EC2 instance"
    default = "t2.micro"
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
variable "security_group_id" {
    description = "list of security group to attach to EC2 instance"
}

variable "key_name" {
    type = string
    description = "name of keypair to use"
    default = "AlwaysEC2"

}
variable "vpc_security_group_ids" {
    type = list(string)
    description = "List of security groups"
    default = null  
}
variable "user_data_base64" {
  description = "User data to provide during the launching the instance"
  default = "null"
}
variable "user_data_replace_on_change" {
    type = bool
    description = "When used in combination with user_data or user_data_base64 will trigger a destroy and recreate when set to true. Defaults to false if not set"
    default = "false"  
}
