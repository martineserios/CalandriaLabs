#!/bin/bash

echo "🧪 Testing Meta Ads MCP STDIO Communication"
echo "============================================"

# Create a proper MCP initialization sequence
# Note: notifications don't have "id" field
cat > /tmp/mcp-test.json << 'EOF'
{"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {"protocolVersion": "2024-11-05", "capabilities": {}, "clientInfo": {"name": "test-client", "version": "1.0.0"}}}
{"jsonrpc": "2.0", "method": "notifications/initialized"}
{"jsonrpc": "2.0", "id": 2, "method": "tools/list", "params": {}}
EOF

echo "📞 Sending initialization sequence to MCP server..."

# Send the initialization sequence
cat /tmp/mcp-test.json | docker-compose exec -T meta-ads-mcp /home/mcp/.local/bin/meta-ads-mcp --app-id 1242577747431998

echo ""
echo "✅ Test completed!"

# Cleanup
rm -f /tmp/mcp-test.json