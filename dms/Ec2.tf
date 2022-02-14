// setup a red hat 7 system for the oracle source
resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "aws_instance" "dms-oracle-source" {
  ami                         = "ami-0341aeea105412b57" ###(ami is the ami for the instance of your choice in the your desired region)
  instance_type               = "t2.micro"
  key_name                    = "Dms-keypair"
  vpc_security_group_ids      = ["${aws_security_group.dms-sg-ssh.id}"]
  subnet_id                   = aws_subnet.dms-subnet.id
  associate_public_ip_address = "true"
  user_data                   = base64encode(local.instance-userdata)
  root_block_device {
    volume_size           = "30"
    volume_type           = "standard"
    delete_on_termination = "true"
  }
  tags = {
    Name = "dms-oracle-source"
  }
}