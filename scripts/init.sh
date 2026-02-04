#!/bin/bash

# Exit on error
set -e

echo "🚀 Initializing local development environment..."

# Check for Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check for mkcert
if ! command -v mkcert &> /dev/null; then
    echo "⚠️ mkcert is not installed. It is recommended for local SSL certificates."
    echo "   Install it via: brew install mkcert nss (macOS) or refer to documentation."
fi

# Create .env from .env.example if it doesn't exist
if [ ! -f .env ]; then
    echo "📄 Creating .env file from .env.example..."
    cp .env.example .env
    echo "✅ .env created. Please update it with your credentials."
else
    echo "ℹ️ .env file already exists. Skipping copy."
fi

# Create certificates directory
mkdir -p certs

# Generate certificates if mkcert is available and certs don't exist
if command -v mkcert &> /dev/null; then
    if [ ! -f certs/local-cert.pem ]; then
        echo "🔐 Generating local SSL certificates..."
        mkcert -install
        mkcert -key-file certs/local-key.pem -cert-file certs/local-cert.pem localhost 127.0.0.1 ::1
        echo "✅ Certificates generated in certs/ directory."
    else
        echo "ℹ️ Certificates already exist. Skipping generation."
    fi
fi

echo "✨ Initialization complete! You can now run 'docker-compose up -d' to start the services."
