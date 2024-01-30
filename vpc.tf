#VPC
resource "aws_vpc" "myntra_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "myntra"
  }
}

#Wed subnet
resource "aws_subnet" "myntra-web-sn" {
  vpc_id     = aws_vpc.myntra_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "myntra-web-subnet"
  }
}