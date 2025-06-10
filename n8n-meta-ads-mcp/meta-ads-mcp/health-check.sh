#!/bin/bash

# Health check script for Meta Ads MCP server
# Returns 0 if healthy, 1 if unhealthy

HEALTH_URL="http://localhost:3001/health"
TIMEOUT=5

# Check if the health endpoint responds
if curl -f -s --max-time $TIMEOUT "$HEALTH_URL" > /dev/null 2>&1; then
    echo "✅ Meta Ads MCP server is healthy"
    exit 0
else
    echo "❌ Meta Ads MCP server health check failed"
    exit 1
fi