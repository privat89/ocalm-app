#!/bin/bash
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║       OCALM - Démarrage Local            ║"
echo "║       \"Fais tes affaires... Au Calme.\"   ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# Vérifier Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé."
    exit 1
fi

if ! docker info &> /dev/null 2>&1; then
    echo "❌ Docker n'est pas lancé. Démarre Docker Desktop."
    exit 1
fi

echo "🔄 [1/4] Arrêt des containers existants..."
docker compose down --remove-orphans 2>/dev/null

echo ""
echo "🔨 [2/4] Construction des images..."
docker compose build --parallel

echo ""
echo "🚀 [3/4] Démarrage des services..."
docker compose up -d

echo ""
echo "⏳ [4/4] Attente que les services soient prêts..."
sleep 15

echo ""
echo "══════════════════════════════════════════════"
echo " ✅ Services OCALM démarrés :"
echo ""
echo "  API Gateway     : http://localhost:3000"
echo "  Auth Service    : http://localhost:3001"
echo "  Wallet Service  : http://localhost:3002"
echo "  Escrow Service  : http://localhost:3003"
echo "  Delivery Service: http://localhost:3004"
echo "  Dispute Service : http://localhost:3005"
echo "  Notification    : http://localhost:3006"
echo ""
echo "  PostgreSQL      : localhost:5432"
echo "  Redis           : localhost:6379"
echo "  RabbitMQ UI     : http://localhost:15672"
echo "  MinIO Console   : http://localhost:9001"
echo "══════════════════════════════════════════════"
echo ""
echo "📋 Logs : docker compose logs -f"
echo "🛑 Stop : docker compose down"
