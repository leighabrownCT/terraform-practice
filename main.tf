terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.46.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}



#find a specific ami image - ubuntu
data "aws_ami" "app" {
  most_recent = true

  filter {

    name = "name"

    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] #canonical owner ID
}

#create a default port number used in user_data and aws_security_group
variable "server_port" {
  description = "Port number for http requests"
  type = number
  default = 8080
}


#output variable for public ip
output "public_ip" {
  value = aws_instance.cloudcasts_web.public_ip
  description = "Public IP address of the server"
}


#create a new server
resource "aws_instance" "cloudcasts_web" {

  ami = data.aws_ami.app.id
  instance_type = "t3.small"
  vpc_security_group_ids = [aws_security_group.instance.id]

  root_block_device {
    volume_size = 8
  }

  user_data = <<-EOF
      #!/bin/bash
      echo "Hellp, World" > index.html
      nohup busybox httpd -f -p ${var.server_port} &
      EOF

    user_data_replace_on_change = true

    tags = {
      Name = "terraform-example"
    }
}

#create a security group
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = var.server_port
    protocol  = "tcp"
    to_port   = var.server_port
    cidr_blocks = ["0.0.0.0/0"]
  }


}



