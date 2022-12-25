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


#create a new server
resource "aws_instance" "cloudcasts_web" {

  ami = data.aws_ami.app.id

  instance_type = "t3.small"

  root_block_device {
    volume_size = 8



  }
}

