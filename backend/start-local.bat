@echo off
echo.
echo  ╔══════════════════════════════════════════╗
echo  ║       OCALM - Demarrage Local            ║
echo  ║       "Fais tes affaires... Au Calme."   ║
echo  ╚══════════════════════════════════════════╝
echo.

:: Vérifier Docker
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERREUR] Docker n'est pas installe ou pas dans le PATH.
    echo Installe Docker Desktop: https://docker.com/products/docker-desktop
    pause
    exit /b 1
)

:: Vérifier que Docker tourne
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERREUR] Docker Desktop n'est pas lance. Demarre-le d'abord.
    pause
    exit /b 1
)

echo [1/4] Arret des containers existants...
docker compose down --remove-orphans 2>nul

echo.
echo [2/4] Construction des images...
docker compose build --parallel

echo.
echo [3/4] Demarrage des services...
docker compose up -d

echo.
echo [4/4] Attente que les services soient prets...
timeout /t 15 /nobreak >nul

echo.
echo ══════════════════════════════════════════════
echo  Services OCALM demarres :
echo.
echo  API Gateway     : http://localhost:3000
echo  Auth Service    : http://localhost:3001
echo  Wallet Service  : http://localhost:3002
echo  Escrow Service  : http://localhost:3003
echo  Delivery Service: http://localhost:3004
echo  Dispute Service : http://localhost:3005
echo  Notification    : http://localhost:3006
echo.
echo  PostgreSQL      : localhost:5432
echo  Redis           : localhost:6379
echo  RabbitMQ UI     : http://localhost:15672 (ocalm/ocalm_rabbit_2025)
echo  MinIO Console   : http://localhost:9001 (ocalm_minio/ocalm_minio_2025)
echo ══════════════════════════════════════════════
echo.
echo Pour voir les logs : docker compose logs -f
echo Pour arreter      : docker compose down
echo.
pause
