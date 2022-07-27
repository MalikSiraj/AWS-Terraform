variable "infra_env" {
  type = string
  description = "Infrastructure Environment"
  default = "Terraform"
}

variable "vpc_cidr" {
  type = string
  description = "VPC cidr range"
  default = "10.0.0.0/16"
}

variable "vpc_public_subnet_cidr" {
  type = list(string)
  description = "List of cidr to create public subnets in given avalibility zone within VPC"

}

variable "vpc_private_subnet_cidr" {
  type = list(string)
  description = "List of cidr to create private subnets in given avalibility zone within VPC"
}

variable "public_subnet_numb" {
  type = map(number)

  description = "Map the AZ to a number"

  default = {
    "us-east-1a" = 1
    "us-east-1b" = 2
    "us-east-1c" = 3
    "us-east-1d" = 4
  }
}

variable "private_subnet_numb" {
  type = map(number)

  description = "Map the AZ to a number"

  default = {
    "us-east-1a" = 5
    "us-east-1b" = 6
    "us-east-1c" = 7
    "us-east-1c" = 8
  }
}