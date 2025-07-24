
# Create a key pair and save the .pem file locally
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "my-ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content              = tls_private_key.ec2_key.private_key_pem
  filename             = "${path.module}/my-ec2-key.pem"
  file_permission      = "0400"
  directory_permission = "0700"
}

# Security group allowing only internal access (private subnet)
resource "aws_security_group" "ec2_sg" {
  name        = "private-ec2-sg"
  description = "Allow internal VPC traffic"
  vpc_id      = "vpc-0f0ca2e5e4458f0af" # <-- Replace with your VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # only allow internal access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch EC2 instance in private subnet
resource "aws_instance" "private_ec2" {
  ami                    = "ami-020cba7c55df1f615" # Amazon Linux 2 in us-east-1 (update as needed)
  instance_type          = "t3.micro"
  subnet_id              = "subnet-09efa2557ded7889f" # <-- Replace with your private subnet ID
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = aws_key_pair.ec2_key_pair.key_name
  associate_public_ip_address = false

  tags = {
    Name = "PrivateEC2"
  }
}
