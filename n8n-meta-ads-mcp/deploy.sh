#!/bin/bash

set -e

echo "🚀 Starting n8n + Meta Ads MCP Deployment..."
echo "================================================"

# Check if .env exists
if [ ! -f .env ]; then
    echo "❌ .env file not found!"
    echo "Please copy .env.example to .env and configure your settings"
    exit 1
fi

# Load environment variables
set -a
source .env
set +a

# Make scripts executable
echo "📝 Making scripts executable..."
chmod +x n8n/wait-for-services.sh
chmod +x n8n/new-entrypoint.sh
chmod +x meta-ads-mcp/start-mcp.sh
chmod +x meta-ads-mcp/health-check.sh
chmod +x show-access-info.sh

# Build and start services
echo "🏗️  Building and starting services..."
docker-compose build --no-cache
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 5

# Check if containers are running
echo "🔍 Checking container status..."
if ! docker-compose ps | grep -q "Up"; then
    echo "❌ Some containers failed to start!"
    echo "📋 Container status:"
    docker-compose ps
    echo "📋 Logs:"
    docker-compose logs --tail=20
    exit 1
fi

# Wait for n8n to be ready
echo "⏳ Waiting for n8n to be ready..."
timeout=60
count=0
while [ $count -lt $timeout ]; do
    if curl -s -f http://localhost:5678/healthz > /dev/null 2>&1; then
        break
    fi
    sleep 2
    count=$((count + 2))
    echo "Waiting... ($count/$timeout seconds)"
done

# Check if n8n is ready
if ! curl -s -f http://localhost:5678/healthz > /dev/null 2>&1; then
    echo "⚠️  n8n might not be fully ready yet, but deployment completed"
    echo "📋 Check logs if you have issues:"
    echo "   docker-compose logs n8n"
fi

echo ""
echo "✅ Deployment completed!"
echo "================================================"

# Show access information
./show-access-info.sh