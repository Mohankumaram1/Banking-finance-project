 resource "aws_instance" "ansible_node" {
  ami                    = "ami-0e35ddab05955cf57"
  instance_type          = "t2.medium"
  key_name               = "mohanm"
  subnet_id              = "subnet-0e6a0ab76019f0db3"  # Replace with a valid subnet ID
  vpc_security_group_ids = ["sg-01c9102e963de3064"]
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

