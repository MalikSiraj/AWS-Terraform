resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  
  
  tags = {
    Name = "${var.infra_env}-vpc"    
    }
}
resource "aws_subnet" "public" {
  for_each = var.public_subnet_numb
  
  vpc_id = aws_vpc.vpc.id 
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block,4,each.value)
  tags = {
    Name = "${var.infra_env}-${each.key}-public-subnet"
    subnet = "${each.key}-${each.value}"
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnet_numb
  
  vpc_id = aws_vpc.vpc.id 
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block,4,each.value)
  tags = {
    Name = "${var.infra_env}-${each.key}-private-subnet"
    subnet = "${each.key}-${each.value}"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.infra_env}-ig"
  }
}


resource "aws_eip" "nat"{
  vpc = true

  tags = {
    Name = "${var.infra_env}-nat-ip"
  }
}

resource "aws_nat_gateway" "ngw"{
  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public[element(keys(aws_subnet.public),0)].id
  tags = {
    Name = "${var.infra_env}-ngw"
  }
}


resource "aws_route_table" "public-rt" {
  
  vpc_id = aws_vpc.vpc.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
    tags = {
    Name = "${var.infra_env}-public-rt"
  }
}

resource "aws_route_table" "private-rt" {
  
  vpc_id = aws_vpc.vpc.id
  route{
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = "${var.infra_env}-prvate-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id = aws_subnet.public[each.key].id

  route_table_id = aws_route_table.public-rt.id
  
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private
  subnet_id = aws_subnet.private[each.key].id

  route_table_id = aws_route_table.private-rt.id
  
}

resource "aws_security_group" "allow-ssh" {
  description = "Allow ssh http https from anywhere"
  vpc_id = aws_vpc.vpc.id
  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]  
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },
  {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]  
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false      
  },

    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]  
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false      
    }
  ]
    
  /*egress = [ {
    cidr_blocks = "0.0.0.0/0"
    description = "Allow all trafic at egress"
    from_port = 0
    protocol = "-1"
    to_port = 0
  } ]*/
  tags = {
    Name = "allow-ssh-http-https"
  }
}