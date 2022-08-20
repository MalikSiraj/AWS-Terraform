variable "infra" {
    type = string
    description = "Namespace of infrastructure"
    default = "Teraform"
}
variable "ecs_task_execution_role" {
    description = "ECS task execution role"
  
}
variable "region" {
    type = string
    default = "us-east-1"
}

variable "app_port" {
    description = "Application port"
    default = 80
  
}
variable "app_count" {
    type = number
    description = "No of app"
    default = 2
}

variable "ecs_subnets" {
    #type = list(string)
    description = "list of ALB subnets"
    default = ["10.12.0.0/24","10.12.1.0/24","10.12.2.0/24"]
}
variable "security_groups" {
    description = "Security group attached to ALB"  
}

variable "alb_target_group" {
    description = "ALB target group" 
}
variable "alb_listener" {
    description = "ECS service launch depends on Application load balancer listner"
}
variable "iam_role_policy_attachment" {
    description = "ECS service launch after successfully launch of ecs_iam_role_policy_attachment"
}
