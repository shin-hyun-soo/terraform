# VPC 구간
resource "aws_vpc" "terra-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "terra-vpc"
  }
}

# Subnet 구간
resource "aws_subnet" "terra-sub-public1" {
  vpc_id                  = aws_vpc.terra-vpc.id
  cidr_block              = "10.0.0.0/20"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "terra-sub-public1"
  }
}

resource "aws_subnet" "terra-sub-public2" {
  vpc_id                  = aws_vpc.terra-vpc.id
  cidr_block              = "10.0.16.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "terra-sub-public2"
  }
}

resource "aws_subnet" "terra-sub-private1" {
  vpc_id            = aws_vpc.terra-vpc.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "terra-sub-private1"
  }
}

resource "aws_subnet" "terra-sub-private2" {
  vpc_id            = aws_vpc.terra-vpc.id
  cidr_block        = "10.0.48.0/20"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "terra-sub-private2"
  }
}

resource "aws_subnet" "terra-sub-private3" {
  vpc_id            = aws_vpc.terra-vpc.id
  cidr_block        = "10.0.64.0/20"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "terra-sub-private3"
  }
}

resource "aws_subnet" "terra-sub-private4" {
  vpc_id            = aws_vpc.terra-vpc.id
  cidr_block        = "10.0.80.0/20"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "terra-sub-private4"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "terra-igw" {
  vpc_id = aws_vpc.terra-vpc.id
  tags = {
    Name = "terra-igw"
  }
}

# NAT 인스턴스에 사용할 Elastic IP를 할당
resource "aws_eip" "nat" {
  vpc = true
}

# NAT 게이트웨이 생성
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.terra-sub-public1.id
  tags = {
    Name = "terra-NAT"
  }
}

# 라우팅 테이블 생성
resource "aws_route_table" "terra-public1" {
  vpc_id = aws_vpc.terra-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id
  }
  tags = {
    Name = "terra-public1"
  }
}

resource "aws_route_table_association" "terra-routing-public1" {
  subnet_id      = aws_subnet.terra-sub-public1.id
  route_table_id = aws_route_table.terra-public1.id
}

resource "aws_route_table_association" "terra-routing-public2" {
  subnet_id      = aws_subnet.terra-sub-public2.id
  route_table_id = aws_route_table.terra-public2.id
}

# Private 라우팅 테이블 생성
resource "aws_route_table" "terra-private1" {
  vpc_id = aws_vpc.terra-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "terra-private1"
  }
}

resource "aws_route_table_association" "terra-routing-private1" {
  subnet_id      = aws_subnet.terra-sub-private1.id
  route_table_id = aws_route_table.terra-private1.id
}

resource "aws_route_table_association" "terra-routing-private2" {
  subnet_id      = aws_subnet.terra-sub-private2.id
  route_table_id = aws_route_table.terra-private2.id
}

resource "aws_route_table_association" "terra-routing-private3" {
  subnet_id      = aws_subnet.terra-sub-private3.id
  route_table_id = aws_route_table.terra-private3.id
}

resource "aws_route_table_association" "terra-routing-private4" {
  subnet_id      = aws_subnet.terra-sub-private4.id
  route_table_id = aws_route_table.terra-private4.id
}
