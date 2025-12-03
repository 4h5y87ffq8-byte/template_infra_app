# Guia de Desenvolvimento

Este documento fornece informações detalhadas sobre como desenvolver e contribuir para este projeto.

## 📋 Tabela de Conteúdo

- [Configuração do Ambiente](#configuração-do-ambiente)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Padrões de Código](#padrões-de-código)
- [Testes](#testes)
- [Git Workflow](#git-workflow)
- [Troubleshooting](#troubleshooting)

## 🛠️ Configuração do Ambiente

### 1. Pré-requisitos

Instale as seguintes ferramentas:

- **Java 17+**: [Download](https://adoptium.net/)
- **Maven 3.8+**: [Download](https://maven.apache.org/download.cgi)
- **Docker**: [Download](https://www.docker.com/products/docker-desktop)
- **Terraform**: [Download](https://www.terraform.io/downloads)
- **AWS CLI**: [Download](https://aws.amazon.com/cli/)
- **Git**: [Download](https://git-scm.com/downloads)

### 2. Clone e Setup

```bash
# Clone o repositório
git clone <repository-url>
cd template_infra_app

# Execute o script de setup
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### 3. Configuração do IDE

#### IntelliJ IDEA

1. Importe o projeto como Maven project
2. Configure o JDK 17
3. Instale os plugins:
   - Lombok
   - Spring Boot
   - Docker

#### VS Code

Instale as extensões:
- Java Extension Pack
- Spring Boot Extension Pack
- Docker
- Terraform

## 📁 Estrutura do Projeto

```
template_infra_app/
├── app/                    # Aplicação Spring Boot
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/
│   │   │   │   └── com/example/templateapp/
│   │   │   │       ├── config/       # Configurações Spring
│   │   │   │       ├── controller/   # REST Controllers
│   │   │   │       ├── dto/          # Data Transfer Objects
│   │   │   │       ├── exception/    # Exception Handlers
│   │   │   │       ├── model/        # JPA Entities
│   │   │   │       ├── repository/   # Spring Data Repositories
│   │   │   │       └── service/      # Business Logic
│   │   │   └── resources/
│   │   │       ├── db/migration/     # Flyway Migrations
│   │   │       └── application.properties
│   │   └── test/           # Unit & Integration Tests
│   ├── Dockerfile
│   └── pom.xml
├── infra/                  # Terraform Infrastructure
│   ├── modules/            # Terraform Modules
│   ├── environments/       # Environment Configs
│   └── *.tf               # Terraform Files
├── .github/
│   └── workflows/          # CI/CD Pipelines
├── scripts/                # Utility Scripts
└── docs/                   # Documentation
```

## 📝 Padrões de Código

### Java

Seguimos o [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)

**Principais convenções:**

- **Nomenclatura:**
  - Classes: `PascalCase` (ex: `MessageService`)
  - Métodos/Variáveis: `camelCase` (ex: `getMessage`)
  - Constantes: `UPPER_SNAKE_CASE` (ex: `MAX_RETRY_COUNT`)

- **Estrutura:**
  - Máximo 120 caracteres por linha
  - Indentação: 4 espaços
  - Use Lombok para reduzir boilerplate

**Exemplo:**

```java
@Service
@RequiredArgsConstructor
@Slf4j
public class MessageService {

    private final MessageRepository messageRepository;

    @Transactional(readOnly = true)
    public List<MessageResponse> getAllMessages() {
        log.debug("Fetching all messages");
        return messageRepository.findAll()
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }
}
```

### REST API

- Use substantivos para endpoints
- Use HTTP methods corretamente:
  - `GET`: Buscar recursos
  - `POST`: Criar recursos
  - `PUT`: Atualizar recursos completos
  - `PATCH`: Atualizar parcialmente
  - `DELETE`: Remover recursos

**Exemplo:**

```
GET    /api/messages       - Lista todas as mensagens
GET    /api/messages/{id}  - Busca mensagem específica
POST   /api/messages       - Cria nova mensagem
PUT    /api/messages/{id}  - Atualiza mensagem
DELETE /api/messages/{id}  - Remove mensagem
```

### Database

- Use migrations Flyway para mudanças no schema
- Nomenclatura: `V{version}__{description}.sql`
- Sempre crie rollback scripts

**Exemplo:**

```sql
-- V1__Create_messages_table.sql
CREATE TABLE messages (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

## 🧪 Testes

### Unit Tests

```java
@SpringBootTest
class MessageServiceTest {

    @Mock
    private MessageRepository messageRepository;

    @InjectMocks
    private MessageService messageService;

    @Test
    void shouldReturnAllMessages() {
        // Arrange
        List<Message> messages = Arrays.asList(
            new Message(1L, "Title", "Content", "Author")
        );
        when(messageRepository.findAll()).thenReturn(messages);

        // Act
        List<MessageResponse> result = messageService.getAllMessages();

        // Assert
        assertThat(result).hasSize(1);
        verify(messageRepository).findAll();
    }
}
```

### Integration Tests

```java
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
@Testcontainers
class MessageControllerIntegrationTest {

    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:15");

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    void shouldCreateMessage() {
        MessageRequest request = new MessageRequest("Title", "Content", "Author");
        
        ResponseEntity<MessageResponse> response = restTemplate
            .postForEntity("/api/messages", request, MessageResponse.class);
        
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
    }
}
```

### Executar Testes

```bash
# Todos os testes
mvn test

# Apenas unit tests
mvn test -Dtest=*Test

# Apenas integration tests
mvn test -Dtest=*IT

# Com coverage
mvn clean test jacoco:report
```

## 🔄 Git Workflow

### Branch Strategy

```
main          → Produção
  ↑
develop       → Desenvolvimento
  ↑
feature/*     → Novas funcionalidades
hotfix/*      → Correções urgentes
release/*     → Preparação de releases
```

### Commit Messages

Seguimos [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Documentação
- `style`: Formatação
- `refactor`: Refatoração
- `test`: Testes
- `chore`: Manutenção

**Exemplo:**

```
feat(api): add message pagination

Implement pagination for messages endpoint with page size and number parameters.

Closes #123
```

### Pull Request

1. Crie uma branch: `git checkout -b feature/minha-feature`
2. Faça commits: `git commit -m "feat: adiciona nova funcionalidade"`
3. Push: `git push origin feature/minha-feature`
4. Crie PR no GitHub
5. Aguarde review e CI/CD passar
6. Merge após aprovação

## 🐛 Troubleshooting

### Docker não inicia

```bash
# Limpar containers
docker-compose down -v

# Rebuild
docker-compose up --build
```

### Erro de conexão com banco

```bash
# Verificar se PostgreSQL está rodando
docker ps | grep postgres

# Ver logs
docker-compose logs db
```

### Testes falhando

```bash
# Limpar e reinstalar dependências
mvn clean install -U

# Pular testes temporariamente
mvn clean package -DskipTests
```

### Terraform erro de state

```bash
# Re-inicializar
cd infra
terraform init -reconfigure
```

## 📚 Recursos

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Docker Documentation](https://docs.docker.com/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 💡 Dicas

1. Use `make` commands para tarefas comuns
2. Mantenha commits pequenos e focados
3. Escreva testes para novo código
4. Documente APIs com Swagger
5. Use logs apropriadamente (debug, info, error)
6. Nunca commite secrets ou credenciais
