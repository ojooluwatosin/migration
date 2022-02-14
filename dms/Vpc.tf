

// create the virtual private network
resource "aws_vpc" "dms-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dms-vpc"
  }
}
// create the internet gateway
resource "aws_internet_gateway" "dms-igw" {
  vpc_id = aws_vpc.dms-vpc.id
  tags = {
    Name = "dms-igw"
  }
}
// create a dedicated subnet
resource "aws_subnet" "dms-subnet" {
  vpc_id            = aws_vpc.dms-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-1c"
  tags = {
    Name = "dms-subnet"
  }
}
// create a second dedicated subnet, this is required for RDS
resource "aws_subnet" "dms-subnet-2" {
  vpc_id            = aws_vpc.dms-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-1b"
  tags = {
    Name = "dms-subnet-2"
  }
}
// create routing table which points to the internet gateway
resource "aws_route_table" "dms-route" {
  vpc_id = aws_vpc.dms-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dms-igw.id
  }
  tags = {
    Name = "dms-igw"
  }
}
// associate the routing table with the subnet
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.dms-subnet.id
  route_table_id = aws_route_table.dms-route.id
}
// create a security group for ssh access to the linux systems
resource "aws_security_group" "dms-sg-ssh" {
  name        = "dms-sg-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.dms-vpc.id

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  // allow access to the internet
  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "dms-sg-ssh"
  }
}
// create a security group for rdp access to the windows systems
resource "aws_security_group" "dms-sg-rdp" {
  name        = "dms-sg-rdp"
  description = "Allow RDP inbound traffic"
  vpc_id      = aws_vpc.dms-vpc.id

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // allow access to the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "dms-sg-rdp"
  }
}