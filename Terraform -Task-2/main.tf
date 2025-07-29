provider "aws" {
    region = "us-east-1"
    alias = "east"     
}

provider "aws" {
    region = "us-west-1"
    alias = "west"
}


resource "aws_instance" "east-1" {
    provider = aws.east
    ami = "ami-08a6efd148b1f7504"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.web-sg-east.name]

     user_data = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y nginx
        systemctl start nginx
        systemctl enable nginx
        echo "HELLO FROM TERRAFORM-1" > /usr/share/nginx/html/index.html
    EOF


  
  tags ={
    Name = "my-east-instance"
  } 
}

resource "aws_security_group" "web-sg-east" {
  provider = aws.east
  name = "web-sg-east"
  description = "Createing a security group and allowing ssh and http" 
  
  ingress {
    from_port =  22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
 ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  egress  {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_instance" "west-1" {
  provider = aws.west
  ami = "ami-032db79bb5052ca0f"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web-sg-west.name]

     user_data = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y nginx
        systemctl start nginx
        systemctl enable nginx
        echo "HELLO FROM TERRAFORM-2" > /usr/share/nginx/html/index.html
    EOF



  tags = {
    Name = "my-west-instance"
  }
}

resource "aws_security_group" "web-sg-west" {
  provider = aws.west
  name = "web-sg-west"
  description = "Createing a security group and allowing ssh and http" 

  ingress {
    from_port =  22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
 ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  egress  {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "weat_instance_ip" {
   value = aws_instance.west-1.public_ip
}

output "east_instance_ip" {
  value = aws_instance.east-1.public_ip
}