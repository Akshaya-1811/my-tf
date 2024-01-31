#VPC
resource "aws_vpc" "myntra_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "myntra"
  }
}

#web subnet
resource "aws_subnet" "myntra-web-sn" {
  vpc_id     = aws_vpc.myntra_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "myntra-web-subnet"
  }
}

#db subnet
resource "aws_subnet" "myntra-db-sn" {
  vpc_id     = aws_vpc.myntra_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "myntra-database-subnet"
  }
}

#Internet gateway
resource "aws_internet_gateway" "myntra-igw" {
  vpc_id = aws_vpc.myntra_vpc.id

  tags = {
    Name = "myntra-internet-gateway"
  }
}

# web route table
resource "aws_route_table" "myntra-web-rt" {
  vpc_id = aws_vpc.myntra_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myntra-igw.id
  }

  tags = {
    Name = "myntra-web-route-table"
  }
}