FROM caddy:2-alpine

# Install additional tools
RUN apk add --no-cache curl

# Copy Caddyfile configuration
COPY Caddyfile /etc/caddy/Caddyfile

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:2019/metrics || exit 1

EXPOSE 80 443 2019

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]