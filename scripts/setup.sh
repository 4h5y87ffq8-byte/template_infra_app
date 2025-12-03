#!/bin/bash

# Setup script for template_infra_app project
# This script helps initialize the project for first-time setup

set -e

echo "=========================================="
echo "Template Infrastructure + App Setup"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
echo "Checking prerequisites..."

command -v docker >/dev/null 2>&1 || { echo -e "${RED}Docker is not installed. Please install Docker first.${NC}" >&2; exit 1; }
command -v docker-compose >/dev/null 2>&1 || { echo -e "${RED}Docker Compose is not installed. Please install Docker Compose first.${NC}" >&2; exit 1; }
command -v terraform >/dev/null 2>&1 || { echo -e "${RED}Terraform is not installed. Please install Terraform first.${NC}" >&2; exit 1; }
command -v mvn >/dev/null 2>&1 || { echo -e "${RED}Maven is not installed. Please install Maven first.${NC}" >&2; exit 1; }
command -v java >/dev/null 2>&1 || { echo -e "${RED}Java is not installed. Please install Java 17+ first.${NC}" >&2; exit 1; }

echo -e "${GREEN}✓ All prerequisites are installed${NC}"
echo ""

# Check Java version
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 17 ]; then
    echo -e "${RED}Java 17 or higher is required. Current version: $JAVA_VERSION${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Java version: $JAVA_VERSION${NC}"
echo ""

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
    echo -e "${GREEN}✓ .env file created${NC}"
    echo -e "${YELLOW}⚠ Please edit .env file with your configurations${NC}"
else
    echo -e "${YELLOW}⚠ .env file already exists, skipping...${NC}"
fi
echo ""

# Initialize Terraform
echo "Initializing Terraform..."
cd infra
terraform init
echo -e "${GREEN}✓ Terraform initialized${NC}"
cd ..
echo ""

# Install Maven dependencies
echo "Downloading Maven dependencies..."
cd app
mvn dependency:resolve
echo -e "${GREEN}✓ Maven dependencies downloaded${NC}"
cd ..
echo ""

# Build the application
echo "Building the application..."
cd app
mvn clean package -DskipTests
echo -e "${GREEN}✓ Application built successfully${NC}"
cd ..
echo ""

# Install Git hooks
echo "Installing Git hooks..."
if [ -d .git ]; then
    mkdir -p .git/hooks
    if [ -d scripts/git-hooks ]; then
        cp scripts/git-hooks/* .git/hooks/ 2>/dev/null || true
        chmod +x .git/hooks/* 2>/dev/null || true
        echo -e "${GREEN}✓ Git hooks installed${NC}"
    else
        echo -e "${YELLOW}⚠ No git hooks found, skipping...${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Not a git repository, skipping git hooks...${NC}"
fi
echo ""

# Create necessary directories
echo "Creating necessary directories..."
mkdir -p logs
mkdir -p data/postgres
mkdir -p data/redis
echo -e "${GREEN}✓ Directories created${NC}"
echo ""

echo "=========================================="
echo -e "${GREEN}Setup completed successfully!${NC}"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Edit .env file with your configurations"
echo "2. Run 'make dev' to start development environment"
echo "3. Access the application at http://localhost:8080"
echo "4. Access Swagger UI at http://localhost:8080/swagger-ui.html"
echo ""
echo "For more information, check the README.md file"
echo ""
