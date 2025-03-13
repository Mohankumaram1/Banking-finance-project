
variable "vpc_id" {
  description = "vpc-07a0f675711f3e439"
  type        = string
}

variable "subnet_id" {
  description = "subnet-015b916651629df59"
  type        = string
}

resource "aws_instance" "test-server" {
  ami           = "ami-00bb6a80f01f03502" 
  instance_type = "t2.micro" 
  key_name      = "mohanm.pem"
  subnet_id     = var.subnet-015b916651629df59
  vpc_security_group_ids = ["sg-027a44025af40f8db"]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./mohanm.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = ["echo 'wait to start instance' "]
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

