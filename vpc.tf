#module "vpc" {
#  source  = "terraform-aws-modules/vpc/aws"
#  version = "3.18.0"
#
#  name = "kube-vpc"
#  cidr = "10.0.0.0/16"
#
#  azs = [var.AWS_REGION]
#  enable_dns_support = "true"
#  enable_dns_hostnames = "true"
#
#  private_subnet = ["10.0.1.0/24"]
#  public_subnets = ["10.0.100.0/24"]
#
#  enable_nat_gateway = "true"
#
#  tags = {
#    Name = "kube-vpc"
#    Environment = "test"
#  }
#
#}

resource "aws_vpc" "kube_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "kube_vpc"
    Environment = "test"
  }
}

resource "aws_subnet" "kube_public_subnet" {
  vpc_id = aws_vpc.kube_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = var.AWS_AZ

  tags = {
    Name = "kube_public_subnet"
  }
}

resource "aws_subnet" "external_client_subnet" {
  vpc_id = aws_vpc.kube_vpc.id
  cidr_block = "10.0.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = var.AWS_AZ

  tags = {
    Name = "external_client_subnet"
  }
}



