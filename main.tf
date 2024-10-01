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
  region = "us-east-1"  # Altere para a região desejada
}

# Criar uma VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Criar uma Subnet
resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
}

# Security Group para o SQL Server
resource "aws_security_group" "sql_sg" {
  vpc_id      = aws_vpc.main_vpc.id
  name        = "sql-sg"

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.main_subnet.cidr_block]  # Permitir apenas na mesma VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Permitir todo o tráfego de saída
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Instância do SQL Server
resource "aws_instance" "sqlserver" {
  ami                    = "ami-12345678"  # Insira a AMI do SQL Server
  instance_type         = "t2.micro"
  subnet_id             = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.sql_sg.id]

  tags = {
    Name = "SQLServerInstance"
  }
}

# Security Group para o Backend
resource "aws_security_group" "backend_sg" {
  vpc_id      = aws_vpc.main_vpc.id
  name        = "backend-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir acesso público na porta 80
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Permitir todo o tráfego de saída
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Instância do Backend
resource "aws_instance" "backend" {
  ami                    = "ami-12345678"  # Insira a AMI da aplicação
  instance_type         = "t2.micro"
  subnet_id             = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  tags = {
    Name = "BackendInstance"
  }
}

# Output para o endereço IP da instância do banco de dados
output "sql_server_ip" {
  value = aws_instance.sqlserver.private_ip
}

# Output para o endereço IP da instância do backend
output "backend_ip" {
  value = aws_instance.backend.private_ip
}
