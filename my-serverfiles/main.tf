 resource "aws_instance" "ansible_node" {
  ami                    = "ami-00bb6a80f01f03502"
  instance_type          = "t2.medium"
  key_name               = "mohanm"
  subnet_id              = "subnet-04441ad5ed7050ca2"  # Replace with a valid subnet ID
  vpc_security_group_ids = ["sg-026ff8db2ec83f7a0"]
  associate_public_ip_address = true   # Ensures a public IP is assigned

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
    Name = "ansible_node"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.ansible_node.public_ip} > inventory"
  }

  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/banking-finance/my-serverfiles/banking-playbook.yml"
  }
}

