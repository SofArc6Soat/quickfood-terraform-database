 # Quickfood Backend - Infraestrutura com Terraform
 
 Este repositório contém a configuração do Terraform para provisionar a infraestrutura necessária para o backend do projeto Quickfood na AWS.
 
 ## Tecnologias Utilizadas
 
 - **Terraform**: Para gerenciamento de infraestrutura como código.
 - **AWS**: Provedor de nuvem utilizado para hospedar a aplicação.
 
 ## Estrutura do Projeto
 
 ```plaintext
 .
 ├── main.tf           # Configuração principal do Terraform
 └── variables.tf      # Variáveis utilizadas na configuração
 ```
 
 ## Como Configurar o Terraform
 
 ### Pré-requisitos
 
 - [Terraform](https://www.terraform.io/downloads.html) instalado.
 - [AWS CLI](https://aws.amazon.com/cli/) configurado com suas credenciais.
 
 ### Passos para Executar
 
 1. **Clone o repositório:**
    ```bash
    git clone https://github.com/seu_usuario/quickfood-backend.git
    cd quickfood-backend/infra
    ```
 
 2. **Inicialize o Terraform:**
    ```bash
    terraform init
    ```
 
 3. **Verifique o que será criado:**
    ```bash
    terraform plan
    ```
 
 4. **Aplique as configurações:**
    ```bash
    terraform apply
    ```
 
    Confirme a execução digitando `yes` quando solicitado.
 
 5. **Destrua a infraestrutura (se necessário):**
    ```bash
    terraform destroy
    ```
 
    Confirme a execução digitando `yes` quando solicitado.
 
 ## Configurações e Recursos
 
 O arquivo `main.tf` contém a configuração para provisionar a infraestrutura, incluindo:
 
 - Instâncias EC2 para rodar a aplicação.
 - Grupos de segurança para gerenciar o acesso à aplicação.
 
