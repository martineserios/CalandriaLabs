FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Install system dependencies and Docker CLI
RUN apk add --no-cache \
    git \
    curl \
    nodejs \
    npm \
    netcat-openbsd \
    docker-cli

# Create docker group and add node user to it
RUN addgroup -g 983 docker || true
RUN addgroup node docker

# Install MCP community package globally
RUN npm install -g n8n-nodes-mcp

# Copy our custom scripts
COPY wait-for-services.sh /wait-for-services.sh
COPY new-entrypoint.sh /new-entrypoint.sh

# Make scripts executable
RUN chmod +x /wait-for-services.sh /new-entrypoint.sh

# Set proper permissions
RUN mkdir -p /home/node/.n8n/nodes && \
    chown -R node:node /home/node/.n8n

# Switch back to node user
USER node

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

EXPOSE 5678

# Use our custom entrypoint
ENTRYPOINT ["/new-entrypoint.sh"]