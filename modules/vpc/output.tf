output "vpc_id" {
  value = aws_vpc.vpc.id  
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "vpc_public_subnets" {
  value = {
    for subnet in aws_subnet.public :
    subnet.id => subnet.cidr_block
  }
  
}
/*variable "security_group" {
  value = [ aws_security_group.allow-ssh-http-https ] 
}*/