/****EC2*****/
resource "aws_key_pair" "DevNV" {
  key_name = "DevNV"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCa2lHiJw7H/r8R8vySiORDN4375EHysY70SwlI+5WAcSZIeCnnCzSqero1cR1gy3+FiZSpZaKphr778gj3v1ua97867hSg9ha6O/7Hyn9pFIlhH/1i+pSodyFY2fSF/t/R3Wnd6XAfqJgMPWWIS3Qp3gzhjdw2UodBGk6puFTpMV7QRKM56fvFlRfD9EQuvlVr+qCA/RkXUd6O3i6BJgTtXR80q5Q3rsREx5AhmiH5CWcBUwyyYvi+lxIvn37UGya8u6x3qQfzKU6BpBl2KkGWW5Ofvr8n/Pi1rLVfTOD5uUpPbukHqGCeG+xP66kDsRF34g6JPKkW48hKjevysjV/ DevNV"
}



resource "aws_network_interface" "jen" {
    subnet_id = "${var.public_subnets_id}"
    tags = {
    Name = "primary_network_interface"
    }
  }

resource "aws_instance" "jenkins" {
    ami = "ami-07b068f843ec78e72"
#    subnet_id =
    instance_type = "t2.micro"
    key_name = "${aws_key_pair.DevNV.id}"
    security_groups = [aws_security_group.jen.name]
    network_interface {
    network_interface_id = aws_network_interface.jen.id
    device_index         = 0
  }
    provisioner "remote-exec" {
      inline = [
            "sudo apt update",
            "sudo apt install -y default-jre ",
            "wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -",
            "sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
            "sudo apt update",
            "sudo apt install -y jenkins",
            "sudo systemctl start jenkins",
            "sudo ufw allow 8080",
          ]
    }
    
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("/home/gharge/Downloads/DevNV.pem")
    }
    
    tags = {
    "Name"      = "Jenkins_Server"
    "Terraform" = "true"
  }
}


variable "ingressrules" {
  type    = list(number)
  default = [80, 443, 22, 8080]
}

resource "aws_security_group" "jen" {
  name        = "Allow web traffic"
  description = "Allow ssh and standard http/https ports inbound and everything outbound"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["106.193.199.91/32"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}