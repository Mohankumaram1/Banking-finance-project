# Create VPC
resource "aws_vpc" "my_VPC" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "my_VPC"
  }
}

# Create Public Subnet
resource "aws_subnet" "my_Publicsubnet" {
  vpc_id     = aws_vpc.my_VPC.id
  cidr_block = "10.10.1.0/24"

  tags = {
    Name = "my_Publicsubnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_VPC.id

  tags = {
    Name = "my_igw"
  }
}

# Create Route Table
resource "aws_route_table" "my_routetable" {
  vpc_id = aws_vpc.my_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my_routetable"
  }
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "my_rt_association" {
  subnet_id      = aws_subnet.my_Publicsubnet.id
  route_table_id = aws_route_table.my_routetable.id
}

# Create Security Group
resource "aws_security_group" "my_SG" {
  name   = "my_SG"
  vpc_id = aws_vpc.my_VPC.id

  # Allow SSH (Port 22) - Required for remote access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow All Egress Traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_SG"
  }
}

# Create EC2 Instance
resource "aws_instance" "test-server" {
  ami                    = "ami-00bb6a80f01f03502"
  instance_type          = "t2.micro"
  key_name               = "mohanm"
  subnet_id              = aws_subnet.my_Publicsubnet.id
  vpc_security_group_ids = [aws_security_group.my_SG.id]
  associate_public_ip_address = true

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./mohanm.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = ["echo 'wait to start instance'"]
  }

  tags = {
    Name = "test-server"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > inventory"
  }

  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/Banking-Project/my-serverfiles/finance-playbook.yml"
  }
}
