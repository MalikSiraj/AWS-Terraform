output "keyname" {
    value = module.EC2.keyname 
}
output "securityGroupEC2" {
    value = module.sg.security_group_ec2_id
  
}