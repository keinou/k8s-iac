# K3s-Oracle-Free-Tier

Este repositório tem como objetivo fornecer uma forma automatizada e fácil de configurar um cluster Kubernetes (k8s) usando o K3s no Free Tier da Oracle Cloud Infrastructure (OCI), usando Terraform, Ansible e Oracle Cloud CLI.

## Pré-requisitos

Para utilizar este repositório, você precisará de:

- Uma conta na Oracle Cloud Infrastructure (OCI) com permissões suficientes para criar e gerenciar recursos (você pode utilizar o [Free Tier](https://www.oracle.com/cloud/free/)).
- Instalação local do [Terraform](https://www.terraform.io/downloads.html) (versão 1.0.0 ou superior).
- Instalação local do [OCI CLI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm).

## Configuração

1. Clone este repositório para o seu computador local.

    ```
    git clone https://github.com/keinou/k8s-iac.git
    ```

2. Navegue para o diretório do repositório clonado.

    ```
    cd repo
    ```

3. Copie o arquivo de exemplo `terraform.tfvars.example` para `terraform.tfvars` e preencha os valores necessários para sua configuração de infraestrutura.

    ```
    cp terraform.tfvars.example terraform.tfvars
    ```

    Note que o arquivo `terraform.tfvars` deve ser preenchido com suas credenciais OCI e detalhes do recurso. Por favor, não compartilhe este arquivo, já que ele contém informações sensíveis.

4. Inicialize o Terraform.

    ```
    terraform init
    ```

## Implementação

Para implementar o cluster K3s, execute o seguinte comando:

```
terraform apply
```

Depois de confirmar a ação, o Terraform começará a criar os recursos na Oracle Cloud Infrastructure. Dependendo das especificações da sua infraestrutura, isso pode levar algum tempo.



## Acesso ao Cluster

Depois que o cluster K3s for implantado, você pode se conectar a ele com `kubectl`. O arquivo de configuração do Kubeconfig será armazenado no seu diretório atual com o nome `kubeconfig`.

Para usar o `kubectl` com este arquivo de configuração, execute:
