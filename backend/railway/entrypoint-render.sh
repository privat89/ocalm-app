#!/bin/sh
set -e

# Init database with external PostgreSQL
echo "Initializing database..."
psql "$DATABASE_URL" -f /app/database/init.sql || echo "DB init skipped or already exists"

# Build all services
for dir in /app/services/*/; do
    echo "Building $dir..."
    cd "$dir"
    npm run build || true
    cd /app
done

# Start supervisor (manages all processes)
exec "$@"
