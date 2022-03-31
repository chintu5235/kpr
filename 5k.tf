resource "aws_instance" "i8" {
  ami           = "ami-07315f74f3fa6a5a3"
  instance_type = "t2.micro"
  subnet_id =aws_subnet.sub5.id
  tags = {
    Name = "myyy"
  }
}
resource "aws_eip" "myeip" {
}
resource "aws_eip_association" "eip1" {
  instance_id   = aws_instance.i8.id
  allocation_id = aws_eip.myeip.id
}