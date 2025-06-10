
# n8n + Meta Ads MCP Deployment

## 🚀 Quick Start

### 1. Create Project Structure

```bash
mkdir n8n-meta-ads-mcp
cd n8n-meta-ads-mcp

# Create all directories
mkdir -p caddy n8n meta-ads-mcp local_files

# Create all files from the guide above
```

### 2. Configure Environment

```bash
cp .env.example .env
# Edit .env with your values:
# - Domain name
# - Meta App ID
# - Secure passwords
```

### 3. Set DNS

Point your domain/subdomain to your server IP:

- Create A record: `n8n.yourdomain.com` → `YOUR_SERVER_IP`

### 4. Deploy

```bash
# Make scripts executable
chmod +x n8n/start-n8n.sh
chmod +x meta-ads-mcp/start-mcp.sh
chmod +x meta-ads-mcp/health-check.sh

# Start all services
docker-compose up -d

# Check status
docker-compose ps
docker-compose logs -f
```

### 5. Access n8n

Visit: `https://n8n.yourdomain.com`
Login with credentials from .env file

## 📱 Meta Developer App Setup

1. Go to [Meta for Developers](https://developers.facebook.com/)
2. Create "Consumer" app
3. Add "Marketing API" product
4. Set OAuth redirect: `http://localhost:8888/callback`
5. Copy App ID to .env file

## 🔧 n8n MCP Configuration

1. In n8n: Settings → Community nodes → Install `n8n-nodes-mcp`
2. Create workflow with MCP Client node
3. Configure connection:
   - **Connection**: HTTP Streamable
   - **URL**: `http://meta-ads-mcp:3001/stream`
   - **Auth**: None (internal network)

## 🛠️ Available MCP Tools

- `mcp_meta_ads_get_ad_accounts` - List ad accounts
- `mcp_meta_ads_get_campaigns` - Campaign management
- `mcp_meta_ads_get_insights` - Performance analytics
- `mcp_meta_ads_create_campaign` - Create campaigns
- `mcp_meta_ads_upload_ad_image` - Image management
- And 15+ more tools...

## 📊 Monitoring

```bash
# Check all services
docker-compose ps

# View logs
docker-compose logs -f n8n
docker-compose logs -f meta-ads-mcp
docker-compose logs -f caddy

# Health checks
curl http://localhost:3001/health
curl http://localhost:3001/status
```

## 🔄 Maintenance

```bash
# Update services
docker-compose pull
docker-compose up -d

# Backup database
docker-compose exec postgres pg_dump -U n8n n8n > backup.sql

# Restart specific service
docker-compose restart meta-ads-mcp
```

## 🐛 Troubleshooting

### SSL Issues

- Wait 2-3 minutes for initial certificate
- Check DNS propagation: `nslookup n8n.yourdomain.com`

### MCP Connection Issues

- Verify META_APP_ID in .env
- Check MCP health: `docker-compose logs meta-ads-mcp`
- Test endpoint: `curl http://localhost:3001/health`

### n8n Community Package Issues

- Ensure `N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true`
- Restart n8n after environment changes

```

## 🎯 File Creation Script

To quickly create all files, you can use this script:

```bash
#!/bin/bash

# Create directory structure
mkdir -p n8n-meta-ads-mcp/{caddy,n8n,meta-ads-mcp,local_files}
cd n8n-meta-ads-mcp

# Create .gitkeep for local_files
touch local_files/.gitkeep

# Now copy each file content from the guide above into their respective locations
echo "Project structure created! Now copy the file contents from the guide."
echo "Make scripts executable after creating them:"
echo "chmod +x n8n/start-n8n.sh meta-ads-mcp/start-mcp.sh meta-ads-mcp/health-check.sh
```
