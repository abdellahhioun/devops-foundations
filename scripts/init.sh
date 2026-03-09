#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting DevOps Foundations Initialization...${NC}"

# 1. Check Prerequisites
echo -e "\n${YELLOW}1. Checking prerequisites...${NC}"

if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker Desktop first.${NC}"
    exit 1
fi

if ! command -v mkcert &> /dev/null; then
    echo -e "${RED}❌ mkcert is not installed.${NC}"
    echo "Please install it:"
    echo "  - macOS: brew install mkcert nss"
    echo "  - Linux: sudo apt install libnss3-tools && curl -JLO \"https://dl.filippo.io/mkcert/latest?for=linux/amd64\" && chmod +x mkcert-v* && sudo mv mkcert-v* /usr/local/bin/mkcert"
    exit 1
fi

echo -e "${GREEN}✅ All prerequisites found.${NC}"

# 2. Environment Setup
echo -e "\n${YELLOW}2. Setting up environment variables...${NC}"
if [ ! -f .env ]; then
    echo "Creating .env from .env.example..."
    cp .env.example .env
    echo -e "${GREEN}✅ .env file created.${NC}"
else
    echo -e "${GREEN}✅ .env file already exists.${NC}"
fi

# 3. SSL Certificates
echo -e "\n${YELLOW}3. Managing SSL Certificates...${NC}"
mkdir -p certs

# Install local CA
echo "Installing local CA..."
mkcert -install

# Generate certificates
echo "Generating certificates for *.localhost..."
mkcert -key-file certs/local-key.pem \
       -cert-file certs/local-cert.pem \
       "localhost" \
       "*.localhost" \
       "frontend.localhost" \
       "api.localhost" \
       "traefik.localhost" \
       "db.localhost" \
       "mail.localhost" \
       "127.0.0.1" \
       "::1"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Certificates generated in certs/ directory.${NC}"
else
    echo -e "${RED}❌ Failed to generate certificates.${NC}"
    exit 1
fi

# 4. Final Instructions
echo -e "\n${GREEN}✨ Initialization Complete! ${NC}"
echo "You can now start the stack with:"
echo -e "${YELLOW}docker-compose up -d --build${NC}"
