#vpc

resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "mallesh-vpc"
  }

}

#subnets

resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub-sub-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub-sub-2"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "pvt-sub-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "pvt-sub-2"
  }
}

#internetgateway

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-internet-gw"
  }

}

resource "aws_eip" "my-eip" {

}

#natgateway

resource "aws_nat_gateway" "natgateway" {
  allocation_id = aws_eip.my-eip.id
  subnet_id     = aws_subnet.public-subnet-1.id
  tags = {
    Name = "nat-gw"
  }
}

#route table

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = {
    Name = "my-pub-route"
  }

}

resource "aws_route_table" "pvt-rt" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgateway.id
  }
  tags = {
    Name = "my-pvt-route"
  }

}

#rt association

resource "aws_route_table_association" "pub-rt-asso" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-rt.id

}

resource "aws_route_table_association" "pvt-rt-asso" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.pvt-rt.id

}
