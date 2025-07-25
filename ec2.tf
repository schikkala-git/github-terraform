resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg-ssh"
  description = "Allow SSH from anywhere"
  vpc_id      = "vpc-0188603251f260c53"  # <-- Replace with your VPC ID

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg-ssh" 
    Environment="prod-instance"
  }
}

resource "aws_instance" "private_ec2" {
  ami                    = "ami-020cba7c55df1f615"  # Amazon Linux 2 (update as needed)
  instance_type          = "t2.micro"
  subnet_id              = "subnet-075332923667ce70a"        # <-- Replace with your Private Subnet ID
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "my-keypair"             # <-- Optional: Replace with your key pair name

  associate_public_ip_address = false  # Since it's in a private subnet

  tags = {
    Name = "PrivateEC2Instance"
  }
}