FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create app directory and user
WORKDIR /app
RUN useradd -m -s /bin/bash mcp && \
    chown -R mcp:mcp /app

# Switch to app user
USER mcp

# Install meta-ads-mcp directly with pip
RUN pip install --user meta-ads-mcp

# Add user pip bin to PATH
ENV PATH="/home/mcp/.local/bin:$PATH"

# Copy application files
COPY --chown=mcp:mcp start-mcp.sh /app/start-mcp.sh
COPY --chown=mcp:mcp health-server.py /app/health-server.py
COPY --chown=mcp:mcp health-check.sh /app/health-check.sh

# Make scripts executable
RUN chmod +x /app/start-mcp.sh /app/health-check.sh

# Expose port
EXPOSE 3001

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /app/health-check.sh

CMD ["/app/start-mcp.sh"]