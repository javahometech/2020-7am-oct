# create ec2 in publicsubnets

resource "aws_instance" "web" {
  ami                         = lookup(var.web_ami, var.region)
  instance_type               = "t2.micro"
  subnet_id                   = local.pub_sub_ids[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.we_sg.id]
  key_name                    = "9am2020"
  user_data                   = <<EOF
    #!/bin/bash
    yum install httpd -y
    echo "<h1> Java Home terraform Demo</h1>" > /var/www/html/index.html
    chkconfig httpd on
    service httpd start
  EOF
  tags = {
    Name = "web-1"
  }
}
# web security group

resource "aws_security_group" "we_sg" {
  name        = "web-sg-demo"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "allow 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}