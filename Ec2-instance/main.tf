terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.62.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t3.micro"
  user_data = <<-EOF
                #!/bin/bash
                echo "Hello,world" > index.html
                nohup busybox httpd -f -p 80 &
                EOF
    user_data_replace_on_change = true

  tags = {
    Name = "HelloWorld"
  }
}