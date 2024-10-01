# Configuração do Terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "SofArc6Soat"
    workspaces {
      name = "quickfood-database"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Criando a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MainVPC"
  }
}

# Criando a Subnet
resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "MainSubnet"
  }
}

# Criando o Security Group para SQL Server
resource "aws_security_group" "sql_sg" {
  name        = "sql-sg"
  description = "Security group for SQL Server instance"

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main_vpc.cidr_block]  # Permitir comunicação apenas na VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Permitir todo o tráfego de saída
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Instância EC2 para rodar SQL Server
resource "aws_instance" "sqlserver" {
  ami           = "ami-0a313d6098716f372" # AMI do Ubuntu (modifique conforme a necessidade)
  instance_type = "t2.medium" # Para SQL Server, uma instância maior pode ser necessária

  vpc_security_group_ids = [aws_security_group.sql_sg.id]
  subnet_id              = aws_subnet.main_subnet.id

  user_data = <<-EOF
              #!/bin/bash
              # Instalação e configuração do SQL Server no Docker
              apt-get update
              apt-get install -y docker.io
              systemctl start docker
              docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=quickfood-backend#2024" \
              -e "MSSQL_PID=Developer" -p 1433:1433 -d mcr.microsoft.com/mssql/server:2019-latest
              EOF

  tags = {
    Name = "Quickfood SQL Server"
  }
}

# Outputs para exportar variáveis
output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "subnet_id" {
  value = aws_subnet.main_subnet.id
}

output "sql_server_ip" {
  value = aws_instance.sqlserver.private_ip
}
