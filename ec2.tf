resource "aws_instance" "instance-1" {
  ami             = "ami-0e35ddab05955cf57"
  instance_type   = "t2.micro"
  key_name        = "malli"
  subnet_id       = aws_subnet.public-subnet-1.id
  security_groups = [aws_security_group.my-sg.id]
  root_block_device {
    volume_size = "10"
  }
}