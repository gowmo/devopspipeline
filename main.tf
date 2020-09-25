# Terraform state will be stored in S3
terraform {
  backend "s3" {
    bucket = "terraform-bucket-gowtham"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

# Use AWS Terraform provider
provider "aws" {
  region = "us-east-1"
}

# Create EC2 instance
resource "aws_instance" "default" {
  ami                    = var.ami
  count                  = var.instance_count
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.default.id]
  source_dest_check      = false
  instance_type          = var.instance_type

  tags = {
    Name = "terraform-gowtham-test1"
  }

       # Ansible requires Python to be installed on the remote machine as well as the local machine
  provisioner "remote-exec" {
    # Install Python for Ansible
    inline = ["sudo dnf -y install python libselinux-python"]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file(var.key_path)}"
      host        = "${self.public_ip}"
    }
  }
}

# Create Security Group for EC2
resource "aws_security_group" "default" {
  name = "terraform-default-sg"

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

}
