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

# Buscar a última AMI Ubuntu
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Recurso de grupo de segurança para SQL Server
resource "aws_security_group" "sql-sg" {
  name        = "sql-sg"
  description = "Security group for SQL Server instance"

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir acesso público à porta 1433 (ajuste conforme necessário)
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
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium" # Para rodar SQL Server, um tipo de instância maior pode ser necessário

  # Conectar à segurança da rede
  vpc_security_group_ids = [aws_security_group.sql-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              # Atualizar e instalar Docker
              apt-get update
              apt-get install -y docker.io
              systemctl start docker
              
              # Rodar o SQL Server em um container Docker
              docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=quickfood-backend#2024" \
              -e "MSSQL_PID=Developer" -e "MSSQL_TCP_PORT=1433" \
              -p 1433:1433 -d mcr.microsoft.com/mssql/server:2019-latest
              EOF

  tags = {
    Name = "Quickfood SQL Server"
  }
}
