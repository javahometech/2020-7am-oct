# Create VPC

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name     = "iac-demo-${local.ws}"
    Location = "Banglore"
  }
}

# Create public subnets

resource "aws_subnet" "public" {
  count             = length(local.az_names)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = local.az_names[count.index]
  tags = {
    Env  = local.ws
    Name = "public-${local.ws}-${count.index + 1}"
  }
}

# Create private subnets

resource "aws_subnet" "private" {
  count             = length(local.az_names)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + length(local.az_names))
  availability_zone = local.az_names[count.index]
  tags = {
    Env  = local.ws
    Name = "private-${local.ws}-${count.index + 1}"
  }
}

# aws internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# create public router
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-router"
  }
}

# attache public router to public subnets
resource "aws_route_table_association" "public" {
  count          = length(local.az_names)
  subnet_id      = local.pub_sub_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# create elastic ip
resource "aws_eip" "gateway" {
  vpc = true
}

# create nat gateway 

/*
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.gateway.id
  subnet_id     = local.pub_sub_ids[0]

  tags = {
    Name = "NAT Gateway"
  }
}

# create private router
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name = "private-router"
  }
}

# attache private router to private subnets
resource "aws_route_table_association" "private" {
  count = length(local.az_names)
  subnet_id      = local.pri_sub_ids[count.index]
  route_table_id = aws_route_table.private.id
}
*/