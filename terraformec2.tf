provider "aws" {
  access_key = "Your ACCESS KEY"
  secret_key = "Your Secret Key"
  region     = "us-east-1"
}


data "template_file" "installapache" {
template = "${file("installapache.tpl")}"
}
  
resource "aws_instance" "EC2_Terraform" {
	ami                    = "ami-0323c3dd2da7fb37d"
	instance_type          = "t2.micro"
	key_name = "testpair"
	vpc_security_group_ids = ["${aws_security_group.instance.id}"]
	
  user_data = "${data.template_file.installapache.rendered}"
	
	tags = {
		Name = "Ec2Terraform"
	}
}



resource "aws_security_group" "instance" {
  name = "terraform-SG"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
   ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}
