

resource "aws_vpc" "kpr" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "kpr1"
  }
}
resource "aws_subnet" "sub1" {
  vpc_id     = aws_vpc.kpr.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "mysub1"
  }
}
resource "aws_subnet" "sub2" {
  vpc_id     = aws_vpc.kpr.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "mysub2"
  }
}
resource "aws_subnet" "sub3" {
  vpc_id     = aws_vpc.kpr.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-1c"

  tags = {
    Name = "mysub3"
  }
}
resource "aws_subnet" "sub4" {
  vpc_id     = aws_vpc.kpr.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "mysub4"
  }
}
resource "aws_subnet" "sub5" {
  vpc_id     = aws_vpc.kpr.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "mysub5"
  }
}
resource "aws_subnet" "sub6" {
  vpc_id     = aws_vpc.kpr.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "ap-southeast-1c"

  tags = {
    Name = "mysub5"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id    = aws_vpc.kpr.id

  tags = {
    Name = "kpr"
  }
}

resource "aws_route_table" "rt11" {
  vpc_id = aws_vpc.kpr.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt1"
  }
}

resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt11.id
}
resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.rt11.id
}
resource "aws_route_table_association" "a3" {
  subnet_id      = aws_subnet.sub3.id
  route_table_id = aws_route_table.rt11.id
}
resource "aws_eip" "natelb" {
}
resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.natelb.id
  subnet_id     = aws_subnet.sub1.id

  tags = {
    Name = "my nat"
  }
  }
  resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.kpr.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat1.id
  }

  tags = {
    Name = "rt2"
  }
}
resource "aws_route_table_association" "a4" {
  subnet_id      = aws_subnet.sub4.id
  route_table_id = aws_route_table.rt2.id
}
resource "aws_route_table_association" "a5" {
  subnet_id      = aws_subnet.sub5.id
  route_table_id = aws_route_table.rt2.id
}
resource "aws_route_table_association" "a6" {
  subnet_id      = aws_subnet.sub6.id
  route_table_id = aws_route_table.rt2.id
}
resource "aws_elb" "myelb" {
     name = "myelb1"
     subnets = [aws_subnet.sub1.id, aws_subnet.sub2.id, aws_subnet.sub3.id]

    listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  }
  resource "aws_security_group" "sg1" {
  name        = "mysg"
  description = "mysg"
  vpc_id      = aws_vpc.kpr.id
  }
  resource "aws_security_group_rule" "rule1"{
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg1.id
}
 resource "aws_security_group_rule" "rule2"{
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg1.id
}
resource "aws_instance" "i1" {
  ami           = "ami-07315f74f3fa6a5a3"
  instance_type = "t2.micro"
  subnet_id =aws_subnet.sub4.id
  vpc_security_group_ids=[aws_security_group.sg1.id]
  user_data = <<-EOF
  #!/bin/bash
  apt-get update
  apt-get install apache2 -y
  EOF
  tags = {
    Name = "pandaggo"
  }
}
resource "aws_instance" "i2" {
  ami           = "ami-07315f74f3fa6a5a3"
  instance_type = "t2.micro"
  subnet_id =aws_subnet.sub5.id
  vpc_security_group_ids=[aws_security_group.sg1.id]
  user_data =file("./3.sh")
  tags = {
    Name = "pandaggo"
  }
}
resource "aws_elb_attachment" "kkpp" {
  elb      = aws_elb.myelb.id
  instance = aws_instance.i1.id
}
resource "aws_elb_attachment" "baz" {
  elb      = aws_elb.myelb.id
  instance = aws_instance.i2.id
}