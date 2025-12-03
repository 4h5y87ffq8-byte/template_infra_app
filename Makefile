.PHONY: help dev build test clean deploy docker-build docker-run terraform-init terraform-plan terraform-apply

# Variables
APP_NAME := template-app
DOCKER_IMAGE := $(APP_NAME):latest
TERRAFORM_DIR := infra
APP_DIR := app
ENV ?= dev

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

dev: ## Start development environment with docker-compose
	docker-compose up --build

build: ## Build the application
	cd $(APP_DIR) && mvn clean package -DskipTests

test: ## Run all tests
	cd $(APP_DIR) && mvn test

integration-test: ## Run integration tests
	cd $(APP_DIR) && mvn verify -P integration-tests

clean: ## Clean build artifacts
	cd $(APP_DIR) && mvn clean
	docker-compose down -v
	rm -rf target/

docker-build: ## Build Docker image
	cd $(APP_DIR) && docker build -t $(DOCKER_IMAGE) .

docker-run: ## Run Docker container locally
	docker run -p 8080:8080 --env-file .env $(DOCKER_IMAGE)

docker-push: ## Push Docker image to registry
	docker tag $(DOCKER_IMAGE) $(DOCKER_REGISTRY)/$(DOCKER_IMAGE)
	docker push $(DOCKER_REGISTRY)/$(DOCKER_IMAGE)

terraform-init: ## Initialize Terraform
	cd $(TERRAFORM_DIR) && terraform init

terraform-plan: ## Plan Terraform changes
	cd $(TERRAFORM_DIR) && terraform plan -var-file="environments/$(ENV).tfvars"

terraform-apply: ## Apply Terraform changes
	cd $(TERRAFORM_DIR) && terraform apply -var-file="environments/$(ENV).tfvars"

terraform-destroy: ## Destroy Terraform resources
	cd $(TERRAFORM_DIR) && terraform destroy -var-file="environments/$(ENV).tfvars"

deploy: build docker-build terraform-apply ## Full deployment (build + infrastructure)
	@echo "Deployment to $(ENV) completed!"

format: ## Format code
	cd $(APP_DIR) && mvn spotless:apply

lint: ## Run linters
	cd $(APP_DIR) && mvn checkstyle:check

validate: lint test ## Validate code (lint + test)

logs: ## Show application logs
	docker-compose logs -f app

db-migrate: ## Run database migrations
	cd $(APP_DIR) && mvn flyway:migrate

db-reset: ## Reset database
	cd $(APP_DIR) && mvn flyway:clean flyway:migrate

install-hooks: ## Install git hooks
	cp scripts/git-hooks/* .git/hooks/
	chmod +x .git/hooks/*

setup: install-hooks terraform-init ## Initial project setup
	@echo "Project setup completed!"
