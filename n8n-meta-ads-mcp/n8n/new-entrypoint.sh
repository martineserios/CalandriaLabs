#!/bin/sh

echo "🏁 Starting n8n initialization..."

# Run our service wait script
/wait-for-services.sh

# Call the original n8n entrypoint with all arguments
echo "🎯 Starting n8n via original entrypoint..."
exec /docker-entrypoint.sh "$@"