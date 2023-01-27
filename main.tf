terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_instance" "master" {

  ami = "ami-09a41e26df464c548"
  instance_type = "t2.medium"
  key_name = "terraform"
  vpc_security_group_ids = [aws_security_group.kuber_sg.id]
  subnet_id = aws_subnet.kube_public_subnet.id
  private_ip = "10.0.1.10"

  root_block_device {
    volume_size = 50
    volume_type = "standard"
  }

  tags = {
    Name = "master"
  }
}

resource "aws_instance" "node" {

  ami = "ami-09a41e26df464c548"
  instance_type = "t2.micro"
  key_name = "terraform"
  vpc_security_group_ids = [aws_security_group.kuber_sg.id]
  subnet_id = aws_subnet.kube_public_subnet.id
  count = 2

  root_block_device {
    volume_size = 20
    volume_type = "standard"
  }

  tags = {
    Name = "node"
  }
}

output "master_ip" {
  value = aws_instance.master.public_ip
}

output "node_ip" {
  value = aws_instance.node[*].public_ip
}

#resource "aws_instance" "client" {
#
#  ami = "ami-08c40ec9ead489470"
#  instance_type = "t3.small"
#  key_name = "terraform"
#  vpc_security_group_ids = [aws_security_group.kuber_sg.id]
#  subnet_id = aws_subnet.external_client_subnet.id
#  count = 1
#
#  root_block_device {
#    volume_size = 10
#  }
#
#  tags = {
#    Name = "client"
#  }
#}

#resource "aws_security_group" "test_security_group" {
#  egress = [
#    {
#      cidr_blocks      = [ "0.0.0.0/0", ]
#      description      = "test for kuber"
#      from_port        = 0
#      ipv6_cidr_blocks = []
#      prefix_list_ids  = []
#      protocol         = "-1"
#      security_groups  = []
#      self             = false
#      to_port          = 0
#    }
#  ]
# ingress                = [
#   {
#     cidr_blocks      = [ "0.0.0.0/0", ]
#     description      = "test ssh"
#     from_port        = 22
#     ipv6_cidr_blocks = []
#     prefix_list_ids  = []
#     protocol         = "tcp"
#     security_groups  = []
#     self             = false
#     to_port          = 22
#  },
#   {
#     cidr_blocks      = [ "0.0.0.0/0", ]
#     description      = "app incoming"
#     from_port        = 80
#     to_port          = 80
#     ipv6_cidr_blocks = []
#     prefix_list_ids  = []
#     protocol         = "tcp"
#     security_groups  = []
#     self             = false
#   },
#
#  ]
#}
