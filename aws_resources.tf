resource "aws_vpc" "kube_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "kube_vpc"
  }
}

resource "aws_subnet" "kube_sub" {
  vpc_id                  = aws_vpc.kube_vpc.id
  cidr_block              = "10.0.0.0/25"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

resource "aws_security_group" "kube_sg" {
  name        = "sg_kube"
  description = "creating sg for k8s"
  vpc_id      = aws_vpc.kube_vpc.id


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "IGW_1" {
  vpc_id = aws_vpc.kube_vpc.id
}

resource "aws_route_table" "docker_table" {
  vpc_id = aws_vpc.kube_vpc.id
}

resource "aws_route" "route_for_dock" {
  route_table_id         = aws_route_table.docker_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.IGW_1.id
}

resource "aws_route_table_association" "docker_asc" {
  subnet_id      = aws_subnet.kube_sub.id
  route_table_id = aws_route_table.docker_table.id
}



resource "aws_instance" "kube_server" {
  ami                    = "ami-09c813fb71547fc4f"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.kube_sub.id
  vpc_security_group_ids = [aws_security_group.kube_sg.id]

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  user_data = file("kube.sh")

  tags = {
    Name = "k8s_server"
  }

}


output "ec2_info" {
  value = aws_instance.kube_server
}