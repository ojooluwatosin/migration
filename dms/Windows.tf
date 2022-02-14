// create a windows instance for the AWS SCT
resource "aws_instance" "dms-oracle-sct" {

  ami                         = "ami-0a135b79b092e3de5"
  instance_type               = "t3a.xlarge"
  key_name                    = "Dms-keypair"
  vpc_security_group_ids      = ["${aws_security_group.dms-sg-rdp.id}"]
  subnet_id                   = aws_subnet.dms-subnet.id
  associate_public_ip_address = "true"
  root_block_device {
    volume_size           = "30"
    volume_type           = "standard"
    delete_on_termination = "true"
  }
  tags = {
    Name = "dms-oracle-sct"
  }
}