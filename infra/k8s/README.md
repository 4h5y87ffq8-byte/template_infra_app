# Kubernetes Manifests

Este diretório contém os manifestos Kubernetes para deploy da aplicação template-infra-app.

## Estrutura

- `namespace.yaml` - Namespace para isolar recursos da aplicação
- `deployment.yaml` - Deployment da aplicação Java Spring Boot
- `service.yaml` - Service para expor a aplicação internamente
- `configmap.yaml` - ConfigMap com configurações da aplicação
- `secret.yaml` - Secret com credenciais (deve ser gerenciado externamente em produção)
- `ingress.yaml` - Ingress com AWS ALB para expor a aplicação externamente
- `hpa.yaml` - HorizontalPodAutoscaler para escalonamento automático

## Deploy

### Aplicar todos os manifestos:

```bash
kubectl apply -f infra/k8s/
```

### Aplicar em ordem específica:

```bash
# 1. Criar namespace
kubectl apply -f infra/k8s/namespace.yaml

# 2. Criar ConfigMap e Secrets
kubectl apply -f infra/k8s/configmap.yaml
kubectl apply -f infra/k8s/secret.yaml

# 3. Criar Deployment e Service
kubectl apply -f infra/k8s/deployment.yaml
kubectl apply -f infra/k8s/service.yaml

# 4. Criar Ingress
kubectl apply -f infra/k8s/ingress.yaml

# 5. Criar HPA
kubectl apply -f infra/k8s/hpa.yaml
```

## Verificar Deploy

```bash
# Verificar pods
kubectl get pods -n template-infra-app-namespace

# Verificar services
kubectl get svc -n template-infra-app-namespace

# Verificar logs
kubectl logs -f deployment/template-infra-app -n template-infra-app-namespace

# Verificar HPA
kubectl get hpa -n template-infra-app-namespace
```

## Configurações Importantes

### Imagem Docker

Atualizar a imagem no `deployment.yaml`:
```yaml
image: <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/template_infra_app:latest
```

### Secrets

**IMPORTANTE**: O arquivo `secret.yaml` contém valores de exemplo. Em produção, use AWS Secrets Manager ou External Secrets Operator.

### Ingress

O Ingress está configurado para AWS ALB. Certifique-se de ter o AWS Load Balancer Controller instalado no cluster EKS.

## Ambientes

Para diferentes ambientes (dev, cer, prd), você pode:
1. Criar diretórios separados: `k8s/dev/`, `k8s/cer/`, `k8s/prd/`
2. Usar Kustomize para overlays
3. Usar Helm para parametrização
