# 🎉 Template de Infraestrutura + Aplicação - Resumo

Este repositório foi criado como um **template completo e profissional** para projetos que combinam:
- ✅ **Infraestrutura como Código** (Terraform)
- ✅ **Aplicação Java Spring Boot** containerizada
- ✅ **CI/CD completo** (GitHub Actions)
- ✅ **Best practices** em estrutura de repositório

---

## 📦 O que foi criado

### 1. **Estrutura de Diretórios**
```
template_infra_app/
├── app/                    # Aplicação Spring Boot 3 + Java 17
├── infra/                  # Terraform (VPC, ECS, RDS, Redis, ALB)
├── .github/workflows/      # CI/CD Pipelines
├── docs/                   # Documentação completa
├── scripts/                # Scripts utilitários
├── docker-compose.yml      # Orquestração local
├── Makefile               # Comandos make para automação
├── .gitignore             # Git ignore completo
└── README.md              # Documentação principal
```

### 2. **Aplicação Java** (`app/`)

**Framework & Tecnologias:**
- Spring Boot 3.2.0 (Java 17)
- Spring Data JPA (PostgreSQL)
- Spring Data Redis (Cache)
- Flyway (Database migrations)
- SpringDoc OpenAPI (Swagger)
- Lombok
- Actuator (Health checks & metrics)

**Estrutura do Código:**
```
app/src/main/java/com/example/templateapp/
├── TemplateApplication.java      # Main class
├── config/                        # Configurações (OpenAPI)
├── controller/                    # REST Controllers
│   ├── HealthController.java     # Health & Info endpoints
│   └── MessageController.java    # CRUD de mensagens
├── dto/                          # Request/Response DTOs
├── exception/                    # Exception handlers
├── model/                        # Entidades JPA
├── repository/                   # Spring Data Repositories
└── service/                      # Business logic
```

**Features:**
- ✅ CRUD completo de Messages
- ✅ Validação de inputs
- ✅ Cache Redis
- ✅ Documentação Swagger
- ✅ Health checks
- ✅ Prometheus metrics
- ✅ Database migrations automáticas
- ✅ Exception handling global
- ✅ Dockerfile multi-stage otimizado

**Endpoints:**
```
GET    /api/health              # Health check
GET    /api/info                # Application info
GET    /api/messages            # Lista mensagens
GET    /api/messages/{id}       # Busca mensagem
POST   /api/messages            # Cria mensagem
PUT    /api/messages/{id}       # Atualiza mensagem
DELETE /api/messages/{id}       # Remove mensagem
GET    /swagger-ui.html         # Swagger UI
GET    /actuator/health         # Actuator health
GET    /actuator/prometheus     # Prometheus metrics
```

### 3. **Infraestrutura** (`infra/`)

**Recursos AWS (Terraform):**
- ✅ **VPC** (public/private subnets, NAT gateway)
- ✅ **ECS Fargate** (cluster, task definition, service)
- ✅ **Application Load Balancer** (ALB com health checks)
- ✅ **RDS PostgreSQL** (Multi-AZ para prod)
- ✅ **ElastiCache Redis** (cache distribuído)
- ✅ **ECR** (registry de imagens Docker)
- ✅ **CloudWatch** (logs e métricas)
- ✅ **Auto Scaling** (baseado em CPU)
- ✅ **Secrets Manager** (credenciais seguras)

**Módulos Terraform:**
```
infra/
├── backend.tf              # S3 backend para state
├── provider.tf             # AWS provider
├── variables.tf            # Variáveis (todas documentadas)
├── locals.tf               # Variáveis locais
├── data.tf                 # Data sources
├── main.tf                 # Recursos principais
├── outputs.tf              # Outputs (URLs, endpoints)
└── environments/           # Configs por ambiente
    ├── dev.tfvars          # Desenvolvimento
    ├── staging.tfvars      # Homologação
    └── prod.tfvars         # Produção
```

**Ambientes Configurados:**
- **Dev**: 1 task, db.t3.micro, cache.t3.micro
- **Prod**: 3 tasks, db.t3.small, cache.t3.small, Multi-AZ

### 4. **CI/CD Pipelines** (`.github/workflows/`)

**Workflows criados:**

1. **`build.yml`** - Build & Test (em cada push)
   - ✅ Build Maven
   - ✅ Testes unitários
   - ✅ Code coverage (JaCoCo)
   - ✅ Security scan (Trivy)
   - ✅ Code lint (Checkstyle)
   - ✅ Upload artifacts

2. **`deploy.yml`** - Deploy Completo
   - ✅ Build & push Docker image para ECR
   - ✅ Deploy infraestrutura (Terraform)
   - ✅ Deploy aplicação (ECS)
   - ✅ Smoke tests
   - ✅ Notificações Slack

3. **`terraform-pr.yml`** - Terraform Plan em PRs
   - ✅ Terraform format check
   - ✅ Terraform validate
   - ✅ Terraform plan
   - ✅ Security scan (tfsec)
   - ✅ Comenta PR com plan

4. **`nightly.yml`** - Testes Noturnos
   - ✅ Integration tests
   - ✅ Performance tests (k6)
   - ✅ Dependency check (OWASP)

### 5. **Docker & Orquestração**

**`docker-compose.yml`** - Ambiente local completo:
- ✅ App (Spring Boot)
- ✅ PostgreSQL 15
- ✅ Redis 7
- ✅ Nginx (reverse proxy)
- ✅ Volumes persistentes
- ✅ Health checks
- ✅ Network isolada

**`Dockerfile`** - Multi-stage otimizado:
- ✅ Build stage (Maven)
- ✅ Runtime stage (JRE)
- ✅ Non-root user
- ✅ Health check
- ✅ JVM tuning

### 6. **Automação** (`Makefile`)

**Comandos disponíveis:**
```bash
make help              # Lista todos os comandos
make dev               # Inicia ambiente de desenvolvimento
make build             # Build da aplicação
make test              # Executa testes
make docker-build      # Build da imagem Docker
make docker-run        # Roda container localmente
make terraform-init    # Inicializa Terraform
make terraform-plan    # Plano Terraform
make terraform-apply   # Aplica Terraform
make deploy            # Deploy completo (build + infra)
make clean             # Limpa artifacts
make format            # Formata código
make lint              # Executa linters
```

### 7. **Scripts Úteis** (`scripts/`)

- **`setup.sh`**: Setup inicial do projeto
  - Verifica pré-requisitos
  - Inicializa Terraform
  - Baixa dependências Maven
  - Configura Git hooks
  - Cria estrutura de diretórios

- **`git-hooks/pre-commit`**: Hook de pre-commit
  - Valida código Maven
  - Executa testes
  - Verifica formatação

### 8. **Documentação** (`docs/`)

- **`development.md`**: Guia completo de desenvolvimento
  - Setup do ambiente
  - Padrões de código
  - Como escrever testes
  - Git workflow
  - Troubleshooting

- **`deployment.md`**: Guia de deploy
  - Deploy automático vs manual
  - Rollback procedures
  - Monitoring
  - Security
  - Checklist de deploy

### 9. **Configurações**

- **`.gitignore`**: Ignora arquivos desnecessários
  - Maven target/
  - IDE configs
  - Terraform state
  - Secrets
  - Logs

- **`.env.example`**: Template de variáveis de ambiente

- **`LICENSE`**: MIT License

---

## 🚀 Como Usar Este Template

### 1. Quick Start Local

```bash
# Clone o repositório
git clone <repo-url>
cd template_infra_app

# Execute o setup
chmod +x scripts/setup.sh
./scripts/setup.sh

# Inicie o ambiente
make dev

# Acesse:
# App: http://localhost:8080
# Swagger: http://localhost:8080/swagger-ui.html
# Health: http://localhost:8080/api/health
```

### 2. Deploy na AWS

```bash
# Configure AWS CLI
aws configure

# Deploy da infraestrutura
cd infra
terraform init
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars"

# Build e push da imagem
cd ../app
aws ecr get-login-password | docker login --username AWS --password-stdin <account>.dkr.ecr.us-east-1.amazonaws.com
docker build -t template-app .
docker tag template-app:latest <account>.dkr.ecr.us-east-1.amazonaws.com/template-app:latest
docker push <account>.dkr.ecr.us-east-1.amazonaws.com/template-app:latest

# Deploy via GitHub Actions (recomendado)
git push origin main
```

### 3. Personalização

Para adaptar este template ao seu projeto:

1. **Renomear o projeto**:
   - Buscar/substituir `template-app` pelo nome do seu projeto
   - Atualizar `groupId` e `artifactId` no `pom.xml`
   - Renomear pacotes Java

2. **Configurar secrets no GitHub**:
   ```
   AWS_ACCESS_KEY_ID
   AWS_SECRET_ACCESS_KEY
   SLACK_WEBHOOK_URL (opcional)
   ```

3. **Customizar infraestrutura**:
   - Editar `infra/environments/*.tfvars`
   - Ajustar sizing (CPU, memory, storage)
   - Configurar domínio personalizado

4. **Adicionar features na aplicação**:
   - Criar novos controllers, services, repositories
   - Adicionar migrations em `src/main/resources/db/migration/`
   - Atualizar testes

---

## 🎯 Features Principais

### ✅ Best Practices Implementadas

1. **Código**:
   - Clean Architecture
   - SOLID principles
   - DTOs para separação de camadas
   - Exception handling centralizado
   - Logging estruturado

2. **Banco de Dados**:
   - Migrations versionadas (Flyway)
   - Indexes otimizados
   - Connection pooling
   - Read replicas ready

3. **Segurança**:
   - Secrets no AWS Secrets Manager
   - Non-root container user
   - Security groups restritivos
   - SSL/TLS ready
   - Dependency scanning

4. **Performance**:
   - Cache Redis
   - Database query optimization
   - Docker image multi-stage
   - Auto-scaling configurado

5. **Observability**:
   - Health checks
   - Prometheus metrics
   - CloudWatch logs
   - Distributed tracing ready

6. **CI/CD**:
   - Automated testing
   - Security scanning
   - Blue/green deployment ready
   - Automated rollback

---

## 📊 Tecnologias & Versões

| Tecnologia | Versão | Uso |
|------------|--------|-----|
| Java | 17 | Runtime |
| Spring Boot | 3.2.0 | Framework |
| PostgreSQL | 15 | Database |
| Redis | 7 | Cache |
| Terraform | 1.5+ | IaC |
| Docker | 20.10+ | Containers |
| Maven | 3.8+ | Build |
| AWS ECS | Fargate | Compute |
| AWS RDS | PostgreSQL | Managed DB |
| AWS ElastiCache | Redis | Managed Cache |

---

## 📝 Próximos Passos Sugeridos

Após usar este template, considere adicionar:

1. **Autenticação & Autorização**:
   - Spring Security
   - OAuth2/OIDC
   - JWT tokens

2. **Messaging**:
   - Amazon SQS
   - Apache Kafka
   - Event-driven architecture

3. **Advanced Monitoring**:
   - Grafana dashboards
   - ELK stack
   - Distributed tracing (Zipkin/Jaeger)

4. **Testing**:
   - Contract testing (Pact)
   - Performance testing (JMeter)
   - Chaos engineering

5. **Advanced Features**:
   - Multi-region deployment
   - CDN (CloudFront)
   - WAF (Web Application Firewall)
   - Backup automation

---

## 🤝 Contribuindo

Este é um template! Sinta-se à vontade para:
- Fazer fork
- Customizar para suas necessidades
- Sugerir melhorias
- Reportar bugs

---

## 📄 Licença

MIT License - Veja [LICENSE](LICENSE) para detalhes.

---

## 👥 Contato

Time de Plataforma - [@a5x](https://github.com/a5x)

---

**Feito com ❤️ para acelerar o desenvolvimento de projetos profissionais!**
