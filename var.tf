variable "vpc_cidr"{
type = string
default = "10.0.0.0/24"
}
variable "sns_cidrs"{
type = list
default = ["10.0.0.0/25" , "10.0.0.128/25"]
}
variable "my_cidr"{
default = "0.0.0.0/0"
}
resource "aws_vpc" "vpc11" {
cidr_block=var.vpc_cidr
}
resource "aws_subnet" "sub11" {
  count = length[var.sns_cidrs]
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.sns_cidrs
  }
  resource "aws_internet_gateway" "gw11" {
  vpc_id = aws_vpc.vpc11.id
  }
  resource "aws_route_table" "rt111" {
  vpc_id = aws_vpc.vpc11.id
  }
  variable "igw_route" {
  type = map
  route {
  a="aws_internet_gateway.gw11"
  b="var.my_cidr"
  }
}

 