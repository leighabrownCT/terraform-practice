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

resource "aws_instance" "example" {
  ami = "ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-Linux2"
  }
}
