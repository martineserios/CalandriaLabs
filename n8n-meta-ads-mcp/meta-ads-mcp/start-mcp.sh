#!/bin/bash

set -e

echo "🚀 Meta Ads MCP Container Ready for STDIO Communication"

# Validate required environment variables
if [ -z "$META_APP_ID" ]; then
    echo "❌ Error: META_APP_ID environment variable is required"
    exit 1
fi

echo "📋 Meta App ID: $META_APP_ID"

# The meta-ads-mcp tool will use META_ACCESS_TOKEN from environment if available
if [ -n "$META_ACCESS_TOKEN" ]; then
    echo "🔑 Using provided access token from environment"
elif [ -n "$PIPEBOARD_API_TOKEN" ]; then
    echo "🔑 Using Pipeboard authentication"
else
    echo "🔐 Will use OAuth flow for authentication"
fi

# Start health server for monitoring
echo "🏥 Starting health check server..."
python3 /app/health-server.py &
HEALTH_PID=$!

# Function to cleanup on exit
cleanup() {
    echo "🧹 Cleaning up..."
    kill $HEALTH_PID 2>/dev/null || true
    exit 0
}

# Trap cleanup on signals
trap cleanup SIGTERM SIGINT

# Wait a moment for health server to start
sleep 2

echo "✅ Health check server is running on port 3001"
echo "🎯 Container ready for MCP STDIO communication"
echo "📞 To use: docker-compose exec meta-ads-mcp /home/mcp/.local/bin/meta-ads-mcp --app-id ${META_APP_ID}"
echo ""
echo "🔧 For n8n MCP Client configuration:"
echo "   Connection Type: MCP Client (STDIO) API"
echo "   Command: docker-compose"
echo "   Arguments: exec,-T,meta-ads-mcp,/home/mcp/.local/bin/meta-ads-mcp,--app-id,${META_APP_ID}"
echo ""

# Keep the container running by keeping the health server alive
echo "⏳ Keeping container alive... (Ctrl+C to stop)"
wait $HEALTH_PID