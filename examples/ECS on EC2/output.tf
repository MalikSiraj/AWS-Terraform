/*output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "igw_id" {
  value = module.vpc.igw_id
}
output "vpc_public_subnets" {
  value = module.vpc.public_subnets 
}
*/
output "alb_dns" {
  value = module.alb.lb.dns_name
}
