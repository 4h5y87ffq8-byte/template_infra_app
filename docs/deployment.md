# Guia de Deploy

Este documento descreve o processo de deploy da aplicação em diferentes ambientes.

## 🎯 Ambientes

| Ambiente | Branch | Deploy | URL |
|----------|--------|--------|-----|
| Dev | `develop` | Automático | https://dev.app.example.com |
| Staging | `main` | Manual | https://staging.app.example.com |
| Production | `main` (tag) | Manual | https://app.example.com |

## 🚀 Deploy Automático (CI/CD)

### Pré-requisitos

Configure os seguintes secrets no GitHub:

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
SLACK_WEBHOOK_URL (opcional)
```

### Processo

1. **Push para `develop`** → Deploy automático para Dev
2. **Merge para `main`** → Deploy manual para Staging/Prod
3. **Tag `v*`** → Deploy para Production

### Workflow

```yaml
# .github/workflows/deploy.yml é executado automaticamente
```

## 🔧 Deploy Manual

### 1. Preparação

```bash
# Configurar AWS CLI
aws configure

# Verificar credenciais
aws sts get-caller-identity
```

### 2. Build da Imagem Docker

```bash
# Build local
cd app
docker build -t template-app:v1.0.0 .

# Login no ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

# Tag e push
docker tag template-app:v1.0.0 <account-id>.dkr.ecr.us-east-1.amazonaws.com/template-app:v1.0.0
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/template-app:v1.0.0
```

### 3. Deploy da Infraestrutura

```bash
cd infra

# Inicializar Terraform
terraform init

# Selecionar workspace (ambiente)
terraform workspace select dev
# ou: terraform workspace new dev

# Planejar mudanças
terraform plan -var-file="environments/dev.tfvars" -out=tfplan

# Aplicar mudanças
terraform apply tfplan
```

### 4. Atualizar Aplicação no ECS

```bash
# Obter cluster e service name
CLUSTER_NAME=$(terraform output -raw ecs_cluster_name)
SERVICE_NAME=$(terraform output -raw ecs_service_name)

# Forçar novo deployment
aws ecs update-service \
  --cluster $CLUSTER_NAME \
  --service $SERVICE_NAME \
  --force-new-deployment \
  --region us-east-1

# Aguardar deployment
aws ecs wait services-stable \
  --cluster $CLUSTER_NAME \
  --services $SERVICE_NAME \
  --region us-east-1
```

## 🔄 Rollback

### Rollback da Aplicação

```bash
# Listar task definitions
aws ecs list-task-definitions --family template-app

# Atualizar service para versão anterior
aws ecs update-service \
  --cluster template-app-prod-cluster \
  --service template-app-prod-service \
  --task-definition template-app:5 \
  --region us-east-1
```

### Rollback da Infraestrutura

```bash
cd infra

# Ver histórico
git log --oneline

# Checkout para commit anterior
git checkout <commit-hash>

# Aplicar configuração anterior
terraform plan -var-file="environments/prod.tfvars"
terraform apply -var-file="environments/prod.tfvars"

# Voltar para main
git checkout main
```

## 🔍 Verificação do Deploy

### Health Checks

```bash
# ALB endpoint
ALB_DNS=$(terraform output -raw alb_dns_name)

# Health check
curl http://$ALB_DNS/api/health

# Info
curl http://$ALB_DNS/api/info

# Swagger
open http://$ALB_DNS/swagger-ui.html
```

### Logs

```bash
# CloudWatch Logs
aws logs tail /aws/ecs/template-app-prod --follow

# ECS Service Events
aws ecs describe-services \
  --cluster template-app-prod-cluster \
  --services template-app-prod-service \
  --query 'services[0].events[0:5]'
```

### Métricas

```bash
# CPU Utilization
aws cloudwatch get-metric-statistics \
  --namespace AWS/ECS \
  --metric-name CPUUtilization \
  --dimensions Name=ServiceName,Value=template-app-prod-service \
  --start-time 2024-01-01T00:00:00Z \
  --end-time 2024-01-01T23:59:59Z \
  --period 3600 \
  --statistics Average
```

## 📊 Monitoring

### CloudWatch Dashboards

Acesse: https://console.aws.amazon.com/cloudwatch/

Métricas importantes:
- ECS CPU/Memory utilization
- ALB request count
- ALB target response time
- RDS connections
- Redis hit rate

### Alarmes

Configure alarmes para:
- CPU > 80%
- Memory > 80%
- ALB 5xx errors > 10
- RDS connections > 80%
- ECS service unhealthy

## 🔐 Segurança

### Secrets Management

```bash
# Criar secret
aws secretsmanager create-secret \
  --name template-app/prod/db-password \
  --secret-string "secure-password"

# Atualizar secret
aws secretsmanager update-secret \
  --secret-id template-app/prod/db-password \
  --secret-string "new-secure-password"
```

### Rotação de Credenciais

1. Atualizar secrets no AWS Secrets Manager
2. Force new deployment no ECS
3. Verificar health checks

## 🚨 Troubleshooting

### Deploy Falhou

```bash
# Ver eventos do service
aws ecs describe-services \
  --cluster <cluster-name> \
  --services <service-name>

# Ver logs de tasks falhadas
aws ecs describe-tasks \
  --cluster <cluster-name> \
  --tasks <task-id>
```

### Task não inicia

1. Verificar logs no CloudWatch
2. Verificar security groups
3. Verificar IAM roles
4. Verificar task definition

### Problemas de conectividade

1. Verificar security groups
2. Verificar route tables
3. Verificar NAT gateway
4. Testar conectividade do bastion

## 📝 Checklist de Deploy

### Pré-Deploy

- [ ] Code review aprovado
- [ ] Testes passando
- [ ] Migrations testadas
- [ ] Documentação atualizada
- [ ] Changelog atualizado
- [ ] Backup do banco criado

### Deploy

- [ ] Terraform plan revisado
- [ ] Deploy executado
- [ ] Health checks passando
- [ ] Smoke tests executados
- [ ] Logs verificados

### Pós-Deploy

- [ ] Métricas normais
- [ ] Alertas configurados
- [ ] Documentação de release
- [ ] Time notificado
- [ ] Rollback plan pronto

## 🎯 Blue/Green Deploy

Para deploy sem downtime:

```bash
# 1. Criar nova task definition
aws ecs register-task-definition --cli-input-json file://task-def.json

# 2. Atualizar service com nova task definition
aws ecs update-service \
  --cluster <cluster> \
  --service <service> \
  --task-definition <new-task-def> \
  --desired-count 4

# 3. Aguardar tasks novas ficarem healthy
# 4. Reduzir desired count para 2
# 5. Verificar que tasks antigas foram drenadas
```

## 📞 Contatos

- **DevOps Team**: devops@example.com
- **On-Call**: +55 11 99999-9999
- **Slack**: #platform-alerts

## 📚 Referências

- [AWS ECS Best Practices](https://docs.aws.amazon.com/AmazonECS/latest/bestpracticesguide/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Spring Boot Production Ready](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)
