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

# database route table
resource "aws_route_table" "myntra-database-rt" {
  vpc_id = aws_vpc.myntra_vpc.id

  tags = {
    Name = "myntra-database-route-table"
  }
}

# web subnet association
resource "aws_route_table_association" "myntra-web-asc" {
  subnet_id      = aws_subnet.myntra-web-sn.id
  route_table_id = aws_route_table.myntra-web-rt.id
}

# database subnet association
resource "aws_route_table_association" "myntra-database-asc" {
  subnet_id      = aws_subnet.myntra-db-sn.id
  route_table_id = aws_route_table.myntra-database-rt.id
}

# web nacl
resource "aws_network_acl" "myntra-web-nacl" {
  vpc_id = aws_vpc.myntra_vpc.id


  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
     cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "myntra-web-nacl"
  }
}

# database nacl
resource "aws_network_acl" "myntra-db-nacl" {
  vpc_id = aws_vpc.myntra_vpc.id


  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
     cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "myntra-db-nacl"
  }
}

# web nacl association
resource "aws_network_acl_association" "myntra-web-nacl-asc" {
  network_acl_id = aws_network_acl.myntra-web-nacl.id
  subnet_id      = aws_subnet.myntra-web-sn.id
}

# database nacl association
resource "aws_network_acl_association" "myntra-db-nacl-asc" {
  network_acl_id = aws_network_acl.myntra-db-nacl.id
  subnet_id      = aws_subnet.myntra-db-sn.id
}

# web security group
resource "aws_security_group" "myntra-web-sg" {
  name        = "myntra-web-traffic"
  description = "Allow SSH - HTTP inbound traffic"
  vpc_id      = "${aws_vpc.myntra_vpc.id}"

  ingress {
    description = "SSH from WWW"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "HTTP from WWW"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "myntra-web-sg"
  }
}

