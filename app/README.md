# Template Application

REST API desenvolvida com Spring Boot 3, PostgreSQL e Redis.

## 🚀 Tecnologias

- Java 17
- Spring Boot 3.2.0
- Spring Data JPA
- PostgreSQL
- Redis (Cache)
- Flyway (Migrations)
- Lombok
- SpringDoc OpenAPI (Swagger)
- Docker

## 📋 Pré-requisitos

- Java 17+
- Maven 3.8+
- Docker e Docker Compose
- PostgreSQL 15+ (ou use Docker)

## 🛠️ Configuração

### Variáveis de Ambiente

```bash
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/appdb
SPRING_DATASOURCE_USERNAME=appuser
SPRING_DATASOURCE_PASSWORD=apppass
SPRING_REDIS_HOST=localhost
SPRING_REDIS_PORT=6379
```

## 🏃 Executando Localmente

### Com Docker Compose (Recomendado)

```bash
# Na raiz do projeto
docker-compose up
```

A aplicação estará disponível em: http://localhost:8080

### Sem Docker

```bash
# 1. Inicie PostgreSQL e Redis
# 2. Configure as variáveis de ambiente
# 3. Execute:

mvn clean install
mvn spring-boot:run
```

## 📚 API Documentation

Após iniciar a aplicação, acesse:

- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **OpenAPI JSON**: http://localhost:8080/api-docs

## 🧪 Endpoints

### Health Check
```bash
GET /api/health
GET /api/info
```

### Messages API
```bash
# Listar todas as mensagens
GET /api/messages

# Buscar mensagem por ID
GET /api/messages/{id}

# Criar nova mensagem
POST /api/messages
Content-Type: application/json
{
  "title": "Título",
  "content": "Conteúdo da mensagem",
  "author": "Autor"
}

# Atualizar mensagem
PUT /api/messages/{id}
Content-Type: application/json
{
  "title": "Novo título",
  "content": "Novo conteúdo",
  "author": "Autor"
}

# Deletar mensagem
DELETE /api/messages/{id}
```

## 🐳 Docker

### Build da imagem

```bash
docker build -t template-app:latest .
```

### Executar container

```bash
docker run -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5432/appdb \
  -e SPRING_DATASOURCE_USERNAME=appuser \
  -e SPRING_DATASOURCE_PASSWORD=apppass \
  template-app:latest
```

## 🧪 Testes

```bash
# Executar todos os testes
mvn test

# Executar com coverage
mvn clean test jacoco:report

# Ver relatório de coverage
open target/site/jacoco/index.html
```

## 📊 Monitoring

### Actuator Endpoints

- **Health**: http://localhost:8080/actuator/health
- **Metrics**: http://localhost:8080/actuator/metrics
- **Prometheus**: http://localhost:8080/actuator/prometheus

## 🗄️ Database Migrations

As migrations são gerenciadas pelo Flyway e executadas automaticamente ao iniciar a aplicação.

Arquivos de migration: `src/main/resources/db/migration/`

```bash
# Executar migrations manualmente
mvn flyway:migrate

# Limpar database
mvn flyway:clean
```

## 🏗️ Build

```bash
# Build do projeto
mvn clean package

# Pular testes
mvn clean package -DskipTests

# O jar será gerado em: target/template-app.jar
```

## 📝 Estrutura do Projeto

```
src/
├── main/
│   ├── java/com/example/templateapp/
│   │   ├── config/          # Configurações
│   │   ├── controller/      # Controllers REST
│   │   ├── dto/             # Data Transfer Objects
│   │   ├── exception/       # Exception handlers
│   │   ├── model/           # Entidades JPA
│   │   ├── repository/      # Repositories
│   │   └── service/         # Serviços
│   └── resources/
│       ├── db/migration/    # Flyway migrations
│       └── application.properties
└── test/                    # Testes
```

## 🔧 Desenvolvimento

### Code Style

O projeto segue as convenções do Google Java Style Guide.

### Commits

Use conventional commits:
- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `docs:` Documentação
- `test:` Testes
- `refactor:` Refatoração

## 📄 Licença

MIT License
