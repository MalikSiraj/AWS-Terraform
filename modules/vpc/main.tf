resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  
  
  tags = {
    Name = "${var.infra}-vpc"    
    }
}
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_subnet" "public" {
  count = length(var.vpc_public_subnet_cidr)
  cidr_block = var.vpc_public_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]

  vpc_id = aws_vpc.vpc.id 
  tags = {
    Name = "${var.infra}-${count.index}-public-subnet"
  }
}

resource "aws_subnet" "private" {
  count = length(var.vpc_private_subnet_cidr)
  vpc_id = aws_vpc.vpc.id 
  cidr_block = var.vpc_private_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  tags = {
    Name = "${var.infra}-${count.index}-private-subnet"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.infra}-ig"
  }
}


resource "aws_eip" "nat"{
  count = var.enable_nat_gateway ? 1 : 0
    vpc = true
    tags = {
     Name = "${var.infra}-nat-ip"
    }
}
resource "aws_nat_gateway" "ngw"{
  count = var.enable_nat_gateway ? 1 : 0
  #count = "$(var.vpc_private_subnet_cidr ? 1 : 0)"
  allocation_id = aws_eip.nat[0].id

  #subnet_id = aws_subnet.public[element(keys(aws_subnet.public),0)].id
  subnet_id = aws_subnet.public[0].id
  tags = {
    Name = "${var.infra}-ngw"
  }
  depends_on = [
    aws_eip.nat
  ]
}

resource "aws_route_table" "public-rt" {
  count = length(var.vpc_public_subnet_cidr) > 0 ? 1 :0
  vpc_id = aws_vpc.vpc.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
    tags = {
    Name = "${var.infra}-public-rt"
  }
}

resource "aws_route" "nat-gateway-route" {
  count = var.enable_nat_gateway ? 1 : 0
  route_table_id = aws_route_table.private-rt[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ngw[0].id
  depends_on = [
    aws_nat_gateway.ngw,
    aws_route_table.private-rt
  ]
}

resource "aws_route_table" "private-rt" {
  count = length(var.vpc_private_subnet_cidr) > 0 ? 1 :0
  vpc_id = aws_vpc.vpc.id
  /*route{
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[0].id
  }*/
  tags = {
    Name = "${var.infra}-prvate-rt"
  }
}

resource "aws_route_table_association" "public" {
  #count = var.vpc_public_subnet_cidr ? 1 : 0
  count = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id

  route_table_id = aws_route_table.public-rt[0].id
  
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  subnet_id = aws_subnet.private[count.index].id

  route_table_id = aws_route_table.private-rt[0].id
  
}

resource "aws_security_group" "allow-ssh-http-https" {
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