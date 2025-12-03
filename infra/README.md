# Infraestrutura - Template App

Este diretório contém toda a infraestrutura como código (IaC) usando Terraform.

## 📁 Estrutura

```
infra/
├── environments/       # Configurações por ambiente
│   ├── dev.tfvars
│   ├── staging.tfvars
│   └── prod.tfvars
├── modules/           # Módulos reutilizáveis
│   ├── vpc/
│   ├── ecs/
│   ├── alb/
│   ├── rds/
│   └── elasticache/
├── scripts/           # Scripts auxiliares
├── backend.tf         # Configuração do backend S3
├── provider.tf        # Provider AWS
├── variables.tf       # Variáveis
├── locals.tf          # Variáveis locais
├── data.tf            # Data sources
├── main.tf            # Recursos principais
└── outputs.tf         # Outputs
```

## 🚀 Como usar

### 1. Inicializar Terraform

```bash
terraform init
```

### 2. Validar configuração

```bash
terraform validate
terraform fmt -recursive
```

### 3. Planejar mudanças

```bash
# Development
terraform plan -var-file="environments/dev.tfvars"

# Production
terraform plan -var-file="environments/prod.tfvars"
```

### 4. Aplicar mudanças

```bash
# Development
terraform apply -var-file="environments/dev.tfvars"

# Production
terraform apply -var-file="environments/prod.tfvars"
```

### 5. Destruir recursos (com cuidado!)

```bash
terraform destroy -var-file="environments/dev.tfvars"
```

## 🏗️ Componentes

### VPC
- VPC com subnets públicas e privadas
- NAT Gateway para acesso à internet
- Security Groups

### ECS Fargate
- Cluster ECS
- Task Definition
- Service com Auto Scaling
- CloudWatch Logs

### Application Load Balancer
- ALB público/privado
- Target Groups
- Health Checks
- HTTPS (opcional)

### RDS PostgreSQL
- Instance Multi-AZ (prod)
- Automated Backups
- Secrets Manager para credenciais

### ElastiCache Redis
- Cluster Redis
- Subnet Group
- Security Group

### ECR
- Repository para imagens Docker
- Lifecycle policies

## 📝 Variáveis Importantes

| Variável | Descrição | Default |
|----------|-----------|---------|
| `environment` | Ambiente (dev/staging/prod) | - |
| `aws_region` | Região AWS | us-east-1 |
| `vpc_cidr` | CIDR da VPC | 10.0.0.0/16 |
| `ecs_task_cpu` | CPU do ECS task | 256 |
| `ecs_task_memory` | Memória do ECS task | 512 |
| `db_instance_class` | Classe da instância RDS | db.t3.micro |

## 🔒 Segurança

- Secrets armazenados no AWS Secrets Manager
- Security Groups com acesso restrito
- Subnets privadas para recursos sensíveis
- Logs centralizados no CloudWatch
- Backups automáticos do RDS

## 📊 Outputs

Após o `terraform apply`, você terá acesso a:

- URL da aplicação (ALB DNS)
- Endpoint do banco de dados
- Endpoint do Redis
- URL do repositório ECR
- Nome do cluster ECS

## 🔄 Workflows

### Desenvolvimento
1. Fazer mudanças no código Terraform
2. `terraform fmt`
3. `terraform validate`
4. `terraform plan`
5. Revisar e aprovar
6. `terraform apply`

### Rollback
1. `git checkout <commit-anterior>`
2. `terraform plan`
3. `terraform apply`

## ⚠️ Importante

- **Sempre** revise o `terraform plan` antes do `apply`
- Use ambientes separados (dev/staging/prod)
- Mantenha o state no S3 com DynamoDB lock
- Nunca commite credenciais ou secrets
- Use tags consistentes em todos os recursos
