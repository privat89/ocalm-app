#!/bin/sh
set -e

# Init PostgreSQL
if [ ! -d "/var/lib/postgresql/data" ]; then
    mkdir -p /var/lib/postgresql/data
    chown postgres:postgres /var/lib/postgresql/data
    su - postgres -c "initdb -D /var/lib/postgresql/data"
fi

# Start PostgreSQL temporarily to create DB
su - postgres -c "pg_ctl -D /var/lib/postgresql/data -l /var/log/postgresql.log start"
sleep 3

# Create DB and user
su - postgres -c "psql -c \"CREATE USER ocalm WITH PASSWORD 'ocalm_2025';\"" || true
su - postgres -c "psql -c \"CREATE DATABASE ocalm OWNER ocalm;\"" || true
su - postgres -c "psql -d ocalm -f /docker-entrypoint-initdb.d/init.sql" || true

# Stop temp PostgreSQL (supervisor will manage it)
su - postgres -c "pg_ctl -D /var/lib/postgresql/data stop"

# Init RabbitMQ
rabbitmq-plugins enable rabbitmq_management || true

# Build all services
for dir in /app/services/*/; do
    echo "Building $dir..."
    cd "$dir"
    npm run build || true
    cd /app
done

# Start supervisor (manages all processes)
exec "$@"
