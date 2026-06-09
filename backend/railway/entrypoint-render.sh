#!/bin/sh
set -e

echo "[entrypoint] Starting OCALM initialization..."

# Render injecte DATABASE_URL via variable d'environnement
# Run DB init via Node.js (pg is available in node_modules)
if [ -n "$DATABASE_URL" ]; then
  echo "[entrypoint] Initializing database schema via Node.js..."
  node /app/database/init-db.js || echo "[entrypoint] DB init finished (some errors may be normal if tables already exist)"
else
  echo "[entrypoint] DATABASE_URL not set — skipping DB init"
fi

echo "[entrypoint] Launching supervisord..."
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf
