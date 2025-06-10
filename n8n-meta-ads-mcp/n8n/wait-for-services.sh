#!/bin/sh

echo "🚀 Waiting for services to be ready..."

# Wait for Meta Ads MCP server
echo "⏳ Waiting for Meta Ads MCP server..."
while ! nc -z meta-ads-mcp 3001; do 
    echo "Meta Ads MCP server not ready, waiting..."
    sleep 2
done
echo "✅ Meta Ads MCP server is ready!"

# Wait for database if configured
if [ "$DB_TYPE" = "postgresdb" ]; then
    echo "⏳ Waiting for PostgreSQL..."
    while ! nc -z postgres 5432; do 
        echo "PostgreSQL not ready, waiting..."
        sleep 2
    done
    echo "✅ PostgreSQL is ready!"
fi

echo "🎯 All services are ready!"