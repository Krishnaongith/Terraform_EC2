terraform {
  backend "s3" {
    bucket = "terraform-remote-state-krishna-bonus"  
    key    = "infrastructure/terraform.tfstate"     
    region = "us-east-1"
    encrypt = true
  }
}

provider "aws"{
  region = "us-east-1" 
}
resource "aws_key_pair" "Deliv3" {
  key_name   = "Deliv3"
  public_key = file("Deliv3.pem.pub")
}

data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.default.id
}

resource "aws_security_group_rule" "rdp" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.default.id
}


data "aws_subnet" "default" {
  default_for_az    = true
  availability_zone = "us-east-1a"
}


resource "aws_instance" "al23" {
  ami                    = "ami-09e6f87a47903347c" 
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [data.aws_security_group.default.id]
  key_name               = "Deliv3" 

  tags = {
    Name = "AL23_Instance"
  }
}

resource "aws_instance" "ubuntu" {
  ami                    = "ami-020cba7c55df1f615" 
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [data.aws_security_group.default.id]
  key_name               = "Deliv3" 

  tags = {
    Name = "Ubuntu_Instance"
  }
}

resource "aws_instance" "windows" {
  ami                    = "ami-0345f44fe05216fc4" 
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [data.aws_security_group.default.id]
  key_name               = "Deliv3" 

  tags = {
    Name = "Windows_Instance"
  }
}

output "AL23_public_ip" {
  value = aws_instance.al23.public_ip
}

output "Ubuntu_public_ip" {
  value = aws_instance.ubuntu.public_ip
}

output "Windows_public_ip" {
  value = aws_instance.windows.public_ip
}

