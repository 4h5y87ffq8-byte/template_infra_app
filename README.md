# Template de Infraestrutura + Aplicação

Este repositório contém um template completo para projetos que combinam infraestrutura (Terraform) e aplicação (Java/Spring Boot em container).

## 📁 Estrutura do Projeto

```
.
├── infra/              # Infraestrutura como código (Terraform)
│   ├── environments/   # Configurações por ambiente
│   ├── modules/        # Módulos reutilizáveis
│   └── scripts/        # Scripts auxiliares
├── app/                # Aplicação Java Spring Boot
│   ├── src/            # Código fonte
│   ├── Dockerfile      # Container da aplicação
│   └── pom.xml         # Dependências Maven
├── .github/            # GitHub Actions workflows
│   └── workflows/      # CI/CD pipelines
├── docs/               # Documentação adicional
├── scripts/            # Scripts auxiliares do projeto
└── docker-compose.yml  # Orquestração local
```

## 🚀 Quick Start

### Pré-requisitos

- **Terraform** >= 1.5.0
- **Java** >= 17
- **Maven** >= 3.8
- **Docker** >= 20.10
- **AWS CLI** configurado
- **Git**

### Configuração Local

1. **Clone o repositório**
   ```bash
   git clone <repository-url>
   cd template_infra_app
   ```

2. **Configure as variáveis de ambiente**
   ```bash
   cp .env.example .env
   # Edite o arquivo .env com suas configurações
   ```

3. **Inicie a aplicação localmente**
   ```bash
   make dev
   # ou
   docker-compose up
   ```

### Deploy da Infraestrutura

```bash
cd infra
terraform init
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars"
```

### Build e Deploy da Aplicação

```bash
cd app
mvn clean package
docker build -t app:latest .
docker run -p 8080:8080 app:latest
```

## 🔧 Desenvolvimento

### Rodando a aplicação localmente

```bash
make dev
```

### Executando testes

```bash
make test
```

### Build da aplicação

```bash
make build
```

### Deploy em ambiente específico

```bash
make deploy ENV=dev
```

## 📦 CI/CD

O projeto utiliza GitHub Actions para CI/CD:

- **Build**: Compilação e testes automatizados em cada push
- **Test**: Execução de testes unitários e de integração
- **Deploy**: Deploy automático para ambientes (dev/staging/prod)

## 🌍 Ambientes

- **dev**: Desenvolvimento
- **staging**: Homologação
- **prod**: Produção

## 🛠️ Tecnologias

### Infraestrutura
- Terraform (IaC)
- AWS (Cloud Provider)
- Docker (Containerização)

### Aplicação
- Java 17
- Spring Boot 3.x
- Maven
- PostgreSQL
- Redis

## 📚 Documentação

- [Guia de Infraestrutura](./docs/infrastructure.md)
- [Guia de Desenvolvimento](./docs/development.md)
- [Guia de Deploy](./docs/deployment.md)
- [Troubleshooting](./docs/troubleshooting.md)

## 🤝 Contribuindo

1. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
2. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
3. Push para a branch (`git push origin feature/AmazingFeature`)
4. Abra um Pull Request

## 📝 Convenções

### Git Commit Messages

- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `docs:` Alterações na documentação
- `style:` Formatação de código
- `refactor:` Refatoração de código
- `test:` Adição ou correção de testes
- `chore:` Manutenção geral

### Branches

- `main`: Produção
- `develop`: Desenvolvimento
- `feature/*`: Novas funcionalidades
- `hotfix/*`: Correções urgentes
- `release/*`: Preparação de releases

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👥 Contato

Time de Engenharia - [@a5x](https://github.com/a5x)


