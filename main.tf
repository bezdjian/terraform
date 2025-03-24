provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "web-server" {
  instance_type     = "t3.micro"
  ami               = "ami-0c2e61fdcb5495691"
  availability_zone = "eu-north-1a"
  key_name          = "my-key-pair"

  network_interface {
    network_interface_id = aws_network_interface.main-nw-int.id
    device_index         = 0
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install httpd -y
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<h1>Deployed via Terraform</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "WebServer"
  }
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MainVPC"
  }
}

resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    "Name" = "MainSubnet"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    "Name" = "MainIGW"
  }
}

resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  route {
    ipv6_cidr_block = "::/0" # To get out to the internet
    gateway_id      = aws_internet_gateway.main_igw.id
  }

  tags = {
    "Name" = "MainRT"
  }
}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_rt.id
}

resource "aws_security_group" "app_sg" {
  name = "app_sg_web_traffic"
  ingress {
    description      = "Allow HTTP traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "Allow 8080 traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all traffic to go out"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "app_sg_web_traffic"
  }

}

resource "aws_network_interface" "main-nw-int" {
  subnet_id       = aws_subnet.main_subnet.id
  security_groups = [aws_security_group.app_sg.id]
  private_ips     = ["10.0.1.50"]

  tags = {
    "Name" = "MainNetworkInterface"
  }
}

resource "aws_eip" "eip" {
  network_interface         = aws_network_interface.main-nw-int.id
  depends_on                = [aws_internet_gateway.main_igw, aws_instance.web-server]
  associate_with_private_ip = "10.0.1.50"
  domain                    = "vpc"
  instance                  = aws_instance.web-server.id

  tags = {
    "Name" = "MainEIP"
  }
}
