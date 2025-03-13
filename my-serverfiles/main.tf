data "aws_vpc" "existing_vpc" {
  id = "vpc-0b3be8152e05206bc"  # Replace with your actual VPC ID
}

data "aws_subnet" "default_subnet" {
  filter {
    name   = "vpc-0b3be8152e05206bc"
    values = [data.aws_vpc.vpc-0b3be8152e05206bc]
  }
}

resource "aws_instance" "test-server" {
  ami                    = "ami-00bb6a80f01f03502"
  instance_type          = "t2.micro"
  key_name               = "mohanm.pem"
  vpc_security_group_ids = ["sg-027a44025af40f8db"]
  subnet_id              = data.aws_subnet.subnet-04441ad5ed7050ca2  # Added subnet reference

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
    command = "echo ${aws_instance.test-server.public_ip} > inventory"
  }

  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/Banking-Project/my-serverfiles/finance-playbook.yml"
  }
}


