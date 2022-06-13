provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo" {
  ami           = "ami-0667149a69bc2c367"
  instance_type = "t2.micro"
  key_name      = "aj355y"

  #   user_data = file("scripts/mysql.sh")

  tags = {
    Name = "Test1"
    OS   = "centos7"
  }

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /etc/environment",
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
      "echo 'CLI_IP=${aws_instance.demo.public_ip}' >> /etc/environment",
    ]
  }

  connection {
    type        = "ssh"
    user        = "centos"
    host        = self.public_ip
    ## path to key file
    private_key = file("id_rsa")
    # Important
    agent = false
  }

}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.demo.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.demo.public_ip
}