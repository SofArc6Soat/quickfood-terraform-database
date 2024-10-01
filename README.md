- [Infraestrutura SQL com Terraform](#infraestrutura-sql-com-terraform)
  - [Tecnologias Utilizadas](#tecnologias-utilizadas)
  - [Estrutura do Projeto](#estrutura-do-projeto)
  - [Como Configurar o Terraform](#como-configurar-o-terraform)
    - [Pré-requisitos](#pré-requisitos)
    - [Passos para Executar](#passos-para-executar)
  - [Configurações e Recursos](#configurações-e-recursos)
  - [Autores](#autores)

 ---

 # Infraestrutura SQL com Terraform

 Este repositório contém a configuração do Terraform para provisionar a infraestrutura do SQL necessário para o backend do projeto Quickfood na AWS.

 ## Tecnologias Utilizadas

 - **Terraform**: Para gerenciamento de infraestrutura como código.
 - **AWS**: Provedor de nuvem utilizado para hospedar a aplicação.

 ## Estrutura do Projeto

 ```plaintext
 .
 ├── main.tf           # Configuração principal do Terraform
 ```

 ## Como Configurar o Terraform

 ### Pré-requisitos

 - [Terraform](https://www.terraform.io/downloads.html) instalado.
 - [AWS CLI](https://aws.amazon.com/cli/) configurado com suas credenciais.

 ### Passos para Executar

 1. **Clone o repositório:**
    ```bash
    git clone https://github.com/SofArc6Soat/quickfood-terraform-database.git
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

## Autores

- **Anderson Lopez de Andrade RM: 350452** <br>
- **Henrique Alonso Vicente RM: 354583**<br>