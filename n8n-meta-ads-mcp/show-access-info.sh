#!/bin/bash

# Load environment variables
set -a
source .env 2>/dev/null || true
set +a

echo "🌟 ACCESS INFORMATION"
echo "================================================"

# Get server IP
SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || echo "Unable to detect")

echo "🖥️  Server Information:"
echo "   Server IP: $SERVER_IP"
if [ -n "$N8N_HOST" ]; then
    echo "   Configured Domain: $N8N_HOST"
fi
echo ""

echo "🌐 Access URLs:"

# If domain is configured
if [ -n "$N8N_HOST" ] && [ "$N8N_HOST" != "localhost" ]; then
    echo "   🔗 Production URL: https://$N8N_HOST"
    echo "      (Make sure DNS points to $SERVER_IP)"
fi

# Direct IP access options
echo "   🔗 Direct IP Access: http://$SERVER_IP:5678"
echo "      (Add port 5678 to docker-compose.yml n8n service if not already done)"

# If localhost/development
if [ "$N8N_HOST" = "localhost" ] || [ -z "$N8N_HOST" ]; then
    echo "   🔗 Local Access: http://localhost:5678"
fi

echo ""
echo "🔑 Login Information:"
if [ -n "$N8N_BASIC_AUTH_USER" ]; then
    echo "   Username: $N8N_BASIC_AUTH_USER"
    echo "   Password: $N8N_BASIC_AUTH_PASSWORD"
else
    echo "   No basic auth configured"
fi

echo ""
echo "🛠️  Development Tools:"
echo "   📊 Meta Ads MCP Health: http://$SERVER_IP:3001/health"
echo "   📊 Meta Ads MCP Status: http://$SERVER_IP:3001/status"

echo ""
echo "🔧 Useful Commands:"
echo "   📋 Check logs: docker-compose logs -f"
echo "   📋 Check status: docker-compose ps"
echo "   🔄 Restart: docker-compose restart"
echo "   🛑 Stop: docker-compose down"

echo ""
echo "🚨 Firewall Setup (if accessing externally):"
echo "   sudo ufw allow 80"
echo "   sudo ufw allow 443"
echo "   sudo ufw allow 5678  # For direct access"

echo ""
echo "================================================"