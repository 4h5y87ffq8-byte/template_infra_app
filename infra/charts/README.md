# Helm Charts

Este diretório contém os Helm Charts para deploy da aplicação template-infra-app em Kubernetes/EKS.

## Estrutura

```
charts/
└── template-infra-app/
    ├── Chart.yaml              # Metadados do chart
    ├── values.yaml             # Valores padrão
    ├── values-dev.yaml         # Valores para ambiente DEV
    ├── values-prd.yaml         # Valores para ambiente PRD
    ├── .helmignore            # Arquivos a ignorar
    └── templates/
        ├── _helpers.tpl       # Funções helper
        ├── deployment.yaml    # Template do Deployment
        ├── service.yaml       # Template do Service
        ├── ingress.yaml       # Template do Ingress
        ├── configmap.yaml     # Template do ConfigMap
        ├── secret.yaml        # Template do Secret
        ├── hpa.yaml          # Template do HPA
        ├── serviceaccount.yaml # Template do ServiceAccount
        └── NOTES.txt         # Notas pós-instalação
```

## Pré-requisitos

1. **Helm 3.x** instalado
2. **kubectl** configurado para o cluster EKS
3. **AWS Load Balancer Controller** instalado no cluster (para Ingress)

## Instalação

### Instalar em DEV

```bash
helm install template-infra-app ./infra/charts/template-infra-app \
  --namespace template-infra-app-dev \
  --create-namespace \
  --values ./infra/charts/template-infra-app/values-dev.yaml
```

### Instalar em PRD

```bash
helm install template-infra-app ./infra/charts/template-infra-app \
  --namespace template-infra-app-prd \
  --create-namespace \
  --values ./infra/charts/template-infra-app/values-prd.yaml
```

### Instalar com valores personalizados inline

```bash
helm install template-infra-app ./infra/charts/template-infra-app \
  --namespace template-infra-app-dev \
  --create-namespace \
  --set image.tag=v1.2.3 \
  --set replicaCount=3
```

## Atualização

```bash
# Atualizar usando arquivo de valores
helm upgrade template-infra-app ./infra/charts/template-infra-app \
  --namespace template-infra-app-dev \
  --values ./infra/charts/template-infra-app/values-dev.yaml

# Atualizar apenas a imagem
helm upgrade template-infra-app ./infra/charts/template-infra-app \
  --namespace template-infra-app-dev \
  --reuse-values \
  --set image.tag=v1.2.4
```

## Validação e Debug

### Validar o chart

```bash
helm lint ./infra/charts/template-infra-app
```

### Ver os manifestos gerados (dry-run)

```bash
helm install template-infra-app ./infra/charts/template-infra-app \
  --namespace template-infra-app-dev \
  --values ./infra/charts/template-infra-app/values-dev.yaml \
  --dry-run --debug
```

### Ver valores computados

```bash
helm get values template-infra-app --namespace template-infra-app-dev
```

### Ver todos os valores (incluindo defaults)

```bash
helm get values template-infra-app --namespace template-infra-app-dev --all
```

## Desinstalação

```bash
helm uninstall template-infra-app --namespace template-infra-app-dev
```

## Configurações Importantes

### Imagem Docker

Configurar no `values.yaml` ou arquivos de valores específicos:

```yaml
image:
  repository: <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/template_infra_app
  tag: "latest"
```

### Secrets

**IMPORTANTE**: Os valores de secret em `values.yaml` são apenas exemplos. Para produção:

1. **Use AWS Secrets Manager com External Secrets Operator**:
   ```yaml
   secret:
     enabled: false  # Desabilitar secret do Helm
   ```

2. **Use valores criptografados com helm-secrets**:
   ```bash
   helm secrets install template-infra-app ./charts/template-infra-app \
     --values secrets.yaml
   ```

3. **Use sealed-secrets** para secrets criptografados no Git

### Autoscaling

Configurar HPA em `values.yaml`:

```yaml
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
  targetMemoryUtilizationPercentage: 80
```

### Recursos

Ajustar requests e limits:

```yaml
resources:
  limits:
    cpu: 500m
    memory: 1Gi
  requests:
    cpu: 250m
    memory: 512Mi
```

## Ambientes

O chart suporta múltiplos ambientes através de arquivos de valores:

- `values.yaml` - Valores padrão/base
- `values-dev.yaml` - Configurações para DEV
- `values-prd.yaml` - Configurações para PRD

Crie `values-cer.yaml` conforme necessário.

## Versionamento

O chart segue [Semantic Versioning](https://semver.org/):

- **version**: versão do chart (template)
- **appVersion**: versão da aplicação

Atualizar em `Chart.yaml`:

```yaml
version: 0.2.0      # Versão do chart
appVersion: "1.1.0" # Versão da aplicação
```

## Empacotamento

Para criar um pacote do chart:

```bash
helm package ./infra/charts/template-infra-app
```

Isso gera: `template-infra-app-0.1.0.tgz`

## Repositório de Charts

Para publicar em um repositório Helm:

```bash
# Empacotar
helm package ./infra/charts/template-infra-app

# Gerar index
helm repo index .

# Upload para S3/ChartMuseum/etc
```

## Troubleshooting

### Ver status da instalação

```bash
helm status template-infra-app --namespace template-infra-app-dev
```

### Ver histórico de releases

```bash
helm history template-infra-app --namespace template-infra-app-dev
```

### Rollback

```bash
helm rollback template-infra-app 1 --namespace template-infra-app-dev
```

### Ver logs dos pods

```bash
kubectl logs -n template-infra-app-dev -l app.kubernetes.io/name=template-infra-app --tail=100 -f
```
