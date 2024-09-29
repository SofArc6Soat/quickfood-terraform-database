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

# Provedor AWS
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

# Criando a sub-rede na VPC
resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "MainSubnet"
  }
}

# Recurso de grupo de segurança para SQL Server
resource "aws_security_group" "sql_sg" {
  name        = "sql-sg"
  description = "Security group for SQL Server instance"

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main_vpc.cidr_block] # Permitir acesso apenas na VPC
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
  ami           = "ami-12345678" # Insira a AMI desejada aqui
  instance_type = "t2.medium" # Para rodar SQL Server, um tipo de instância maior pode ser necessário

  vpc_security_group_ids = [aws_security_group.sql_sg.id]
  subnet_id              = aws_subnet.main_subnet.id  # Associar à sub-rede

  user_data = <<-EOF
              #!/bin/bash
              # Atualizar e instalar Docker
              apt-get update
              apt-get install -y docker.io
              systemctl start docker
              
              # Rodar o SQL Server em um container Docker
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

output "security_group_id" {
  value = aws_security_group.sql_sg.id
}

output "sql_server_ip" {
  value = aws_instance.sqlserver.private_ip
}
