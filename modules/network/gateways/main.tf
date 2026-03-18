resource "aws_internet_gateway" "igw_primary" {

  vpc_id = var.vpc_id["primary"]
  tags = {
    Name = "igw-primary"
  }

}

data "aws_ssm_parameter" "al2023_primary" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_ssm_parameter" "al2023_standby" {
  provider = aws.standby_region_aws
  name     = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_security_group" "primary_nat" {
  name        = "nat-primary-sg"
  description = "Security group for the primary region NAT instance"
  vpc_id      = var.vpc_id["primary"]

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidrs["primary"]]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nat-primary-sg"
  }
}

resource "aws_security_group" "standby_nat" {
  provider    = aws.standby_region_aws
  name        = "nat-standby-sg"
  description = "Security group for the standby region NAT instance"
  vpc_id      = var.vpc_id["standby"]

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidrs["standby"]]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nat-standby-sg"
  }
}

resource "aws_instance" "primary_nat" {
  ami                         = data.aws_ssm_parameter.al2023_primary.value
  instance_type               = var.nat_instance_type
  subnet_id                   = var.public_subnet_ids["primary"]
  vpc_security_group_ids      = [aws_security_group.primary_nat.id]
  source_dest_check           = false
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              set -euxo pipefail
              sysctl -w net.ipv4.ip_forward=1
              echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/99-nat.conf
              nft add table ip nat
              nft 'add chain ip nat postrouting { type nat hook postrouting priority 100; }'
              nft add rule ip nat postrouting oifname "eth0" masquerade
              EOF

  tags = {
    Name = "nat-primary"
  }
}

resource "aws_instance" "standby_nat" {
  provider                    = aws.standby_region_aws
  ami                         = data.aws_ssm_parameter.al2023_standby.value
  instance_type               = var.nat_instance_type
  subnet_id                   = var.public_subnet_ids["standby"]
  vpc_security_group_ids      = [aws_security_group.standby_nat.id]
  source_dest_check           = false
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              set -euxo pipefail
              sysctl -w net.ipv4.ip_forward=1
              echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/99-nat.conf
              nft add table ip nat
              nft 'add chain ip nat postrouting { type nat hook postrouting priority 100; }'
              nft add rule ip nat postrouting oifname "eth0" masquerade
              EOF

  tags = {
    Name = "nat-standby"
  }
}
resource "aws_internet_gateway" "igw_standby" {
  provider = aws.standby_region_aws
  vpc_id   = var.vpc_id["standby"]
  tags = {
    Name = "igw-standby"
  }

}
