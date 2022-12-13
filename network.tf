resource "aws_internet_gateway" "kube_igw" {
  vpc_id = aws_vpc.kube_vpc.id

  tags = {
    Name = "kube_igw"
  }
}

resource "aws_route_table" "kube_rt" {
  vpc_id         = aws_vpc.kube_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kube_igw.id
  }

  tags = {
    Name = "kube_rt"
  }
}

resource "aws_route_table_association" "kube_rt_ta" {
  route_table_id = aws_route_table.kube_rt.id
  subnet_id = aws_subnet.kube_public_subnet.id
}

resource "aws_route_table_association" "kube_rt_ta2" {
  route_table_id = aws_route_table.kube_rt.id
  subnet_id = aws_subnet.external_client_subnet.id
}

resource "aws_security_group" "kuber_sg" {
  vpc_id = aws_vpc.kube_vpc.id

  egress {
    from_port = 0
    protocol  = -1
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    protocol  = "icmp"
    to_port   = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    protocol  = "tcp"
    to_port   = 65535
   # cidr_blocks = [aws_subnet.kube_public_subnet.cidr_block]
    cidr_blocks = ["10.0.0.0/8"]
  }
  ingress {
    from_port = 8080
    protocol  = "tcp"
    to_port   = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kuber_sg"
  }
}