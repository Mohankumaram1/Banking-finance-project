resource "aws_instance" "ansible_node" {
  ami                    = "ami-00bb6a80f01f03502"
  instance_type          = "t2.micro"
  key_name               = "mohanm"
  vpc_security_group_ids = ["sg-027a44025af40f8db"]

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
