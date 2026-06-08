# 🔒 OCALM — Fais tes affaires... Au Calme.

> Plateforme de tiers de confiance pour sécuriser les transactions entre particuliers en Afrique de l'Ouest via Mobile Money.

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android-green)
![Backend](https://img.shields.io/badge/backend-NestJS%20Microservices-red)
![Database](https://img.shields.io/badge/database-PostgreSQL%2015-blue)

---

## 📋 Table des matières

- [Présentation](#-présentation)
- [Comment ça marche](#-comment-ça-marche)
- [Architecture](#-architecture)
- [Stack technique](#-stack-technique)
- [Installation](#-installation)
- [Lancement](#-lancement)
- [Structure du projet](#-structure-du-projet)
- [API Endpoints](#-api-endpoints)
- [Grille tarifaire](#-grille-tarifaire)
- [Sécurité](#-sécurité)
- [Déploiement](#-déploiement)
- [Roadmap](#-roadmap)

---

## 🎯 Présentation

**OCALM** est une application mobile qui sécurise les transactions entre particuliers (acheteurs, vendeurs, livreurs) en Côte d'Ivoire et en Afrique de l'Ouest.

**Le problème** : Sur Facebook Marketplace, WhatsApp et les réseaux sociaux, les transactions entre inconnus sont risquées. L'acheteur a peur de payer sans recevoir, le vendeur a peur de livrer sans être payé.

**La solution** : OCALM agit comme un tiers de confiance numérique. L'argent est bloqué en **séquestre** jusqu'à confirmation de réception par l'acheteur. Tout le monde est protégé.

### Utilisateurs cibles
- **Acheteurs** : particuliers qui achètent sur Marketplace/WhatsApp
- **Vendeurs** : particuliers et petits commerçants
- **Livreurs** : coursiers indépendants

---

## 🔄 Comment ça marche — Protocole SHIELD

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   ACHETEUR   │     │    OCALM     │     │   VENDEUR    │
└──────┬───────┘     └──────┬───────┘     └──────┬───────┘
       │                    │                    │
       │  1. Paie via Wave  │                    │
       │───────────────────>│                    │
       │                    │                    │
       │                    │  2. Notifie:       │
       │                    │  "Fonds sécurisés" │
       │                    │───────────────────>│
       │                    │                    │
       │                    │  3. Vendeur livre  │
       │                    │<───────────────────│
       │                    │                    │
       │  4. Livreur livre  │                    │
       │<───────────────────│                    │
       │                    │                    │
       │  5. Scan QR/OTP    │                    │
       │───────────────────>│                    │
       │                    │                    │
       │                    │  6. Paiement auto  │
       │                    │───────────────────>│
       │                    │                    │
       │  ✅ Terminé !       │  ✅ Tout le monde   │
       │                    │     est payé       │
```

### Les 5 étapes :
1. **L'acheteur paie** via Wave → L'argent est bloqué en séquestre OCALM
2. **Le vendeur est notifié** → "Fonds sécurisés, vous pouvez livrer"
3. **Le livreur récupère** le colis (scan QR de départ)
4. **Le livreur livre** à l'acheteur
5. **L'acheteur valide** (scan QR ou code OTP) → Paiements automatiques vendeur + livreur

---

## 🏗 Architecture

```
                    ┌─────────────────┐
                    │   App Flutter   │
                    │  (iOS/Android)  │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │  API Gateway    │
                    │  (Nginx :3000)  │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
┌───────▼───────┐   ┌───────▼───────┐   ┌───────▼───────┐
│ Auth Service  │   │Escrow Service │   │Wallet Service │
│   (:3001)     │   │   (:3003)     │   │   (:3002)     │
└───────────────┘   └───────────────┘   └───────────────┘
        │                    │                    │
┌───────▼───────┐   ┌───────▼───────┐   ┌───────▼───────┐
│Delivery Svc   │   │ Dispute Svc   │   │Notification   │
│   (:3004)     │   │   (:3005)     │   │   (:3006)     │
└───────────────┘   └───────────────┘   └───────────────┘
        │                    │                    │
        └────────────────────┼────────────────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
      ┌───────▼──┐   ┌──────▼───┐   ┌─────▼────┐
      │PostgreSQL│   │  Redis   │   │ RabbitMQ │
      │   :5432  │   │  :6379   │   │  :5672   │
      └──────────┘   └──────────┘   └──────────┘
```

---

## 🛠 Stack technique

| Couche | Technologie | Usage |
|--------|-------------|-------|
| **Mobile** | Flutter 3.x (Dart) | App iOS & Android |
| **State** | Riverpod | Gestion d'état réactive |
| **Navigation** | GoRouter | Routing déclaratif |
| **Backend** | NestJS (TypeScript) | 6 microservices |
| **Database** | PostgreSQL 15 | Données principales |
| **Cache** | Redis 7 | Sessions, OTP, rate limiting |
| **Queue** | RabbitMQ 3 | Communication inter-services |
| **Stockage** | MinIO | Photos preuves litiges |
| **Paiement** | Wave API | Mobile Money (Phase 1) |
| **Gateway** | Nginx | Routing, rate limiting |
| **Container** | Docker Compose | Orchestration locale |

---

## 📦 Installation

### Prérequis

- **Flutter** >= 3.2.0 ([installer](https://docs.flutter.dev/get-started/install))
- **Node.js** >= 18.x ([installer](https://nodejs.org))
- **Docker** & Docker Compose ([installer](https://docs.docker.com/get-docker/))
- **Git**

### 1. Cloner le projet

```bash
git clone https://github.com/votre-org/ocalm.git
cd ocalm
```

### 2. Backend — Installer les dépendances

```bash
cd backend
npm install

# Installer les dépendances de chaque service
cd services/auth-service && npm install && cd ../..
cd services/wallet-service && npm install && cd ../..
cd services/escrow-service && npm install && cd ../..
cd services/delivery-service && npm install && cd ../..
cd services/dispute-service && npm install && cd ../..
cd services/notification-service && npm install && cd ../..
```

### 3. Frontend — Installer les dépendances

```bash
cd mobile
flutter pub get
```

---

## 🚀 Lancement

### Backend (Docker)

```bash
cd backend

# Lancer tous les services + infra
docker-compose up -d

# Vérifier que tout tourne
docker-compose ps

# Voir les logs
docker-compose logs -f
```

**Services disponibles :**
| Service | URL |
|---------|-----|
| API Gateway | http://localhost:3000 |
| Auth Service | http://localhost:3001 |
| Wallet Service | http://localhost:3002 |
| Escrow Service | http://localhost:3003 |
| Delivery Service | http://localhost:3004 |
| Dispute Service | http://localhost:3005 |
| Notification Service | http://localhost:3006 |
| RabbitMQ Management | http://localhost:15672 |
| MinIO Console | http://localhost:9001 |

### Frontend (Flutter)

```bash
cd mobile

# Lancer sur un émulateur/device connecté
flutter run

# Lancer en mode web (pour le dashboard admin)
flutter run -d chrome
```

---

## 📁 Structure du projet

```
ocalm/
├── mobile/                          # App Flutter
│   ├── lib/
│   │   ├── main.dart               # Entry point
│   │   ├── core/
│   │   │   ├── router.dart          # Navigation GoRouter
│   │   │   ├── theme/               # Couleurs + Design system
│   │   │   └── constants/           # Grille tarifaire + enums
│   │   ├── features/
│   │   │   ├── auth/screens/        # Splash, Onboarding, Login OTP, Rôle
│   │   │   ├── acheteur/screens/    # Home, Nouvelle tx, Détail, Scan QR
│   │   │   ├── vendeur/screens/     # Home ventes, Détail vente
│   │   │   ├── livreur/screens/     # Courses, Toggle dispo, Scan
│   │   │   └── admin/screens/       # Dashboard KPI, Litiges, Users
│   │   └── services/               # API, Auth, Transaction, Wallet, Delivery, Notif
│   └── pubspec.yaml
│
├── backend/                         # Microservices NestJS
│   ├── docker-compose.yml           # Infra complète
│   ├── gateway/nginx.conf           # API Gateway config
│   ├── database/init.sql            # Schema PostgreSQL (10 tables)
│   └── services/
│       ├── auth-service/            # Login OTP, JWT, refresh
│       ├── wallet-service/          # Wave API, webhooks, payouts
│       ├── escrow-service/          # Séquestre, validation QR/OTP
│       ├── delivery-service/        # QR codes, tracking, courses
│       ├── dispute-service/         # Litiges, médiation, preuves
│       └── notification-service/    # Push FCM, SMS, templates
│
└── README.md
```

---

## 🔌 API Endpoints

### Auth Service (`/api/v1/auth/`)

| Méthode | Route | Description |
|---------|-------|-------------|
| POST | `/send-otp` | Envoie un OTP par SMS |
| POST | `/verify-otp` | Vérifie l'OTP, retourne JWT |
| POST | `/refresh` | Rafraîchit le token |
| POST | `/role` | Définit le rôle utilisateur |

### Escrow Service (`/api/v1/transactions/`)

| Méthode | Route | Description |
|---------|-------|-------------|
| POST | `/create` | Crée une transaction séquestre |
| GET | `/:id` | Détails d'une transaction |
| POST | `/:id/lock` | Confirme le blocage des fonds |
| POST | `/:id/validate` | Valide la réception (QR/OTP) |
| POST | `/:id/dispute` | Ouvre un litige |
| POST | `/:id/refund` | Rembourse l'acheteur |

### Wallet Service (`/api/v1/wallet/`)

| Méthode | Route | Description |
|---------|-------|-------------|
| POST | `/pay` | Initie un paiement Wave |
| GET | `/status/:id` | Vérifie le statut |
| POST | `/webhooks/wave` | Webhook Wave (HMAC) |
| POST | `/payout` | Paiement sortant |

### Delivery Service (`/api/v1/delivery/`)

| Méthode | Route | Description |
|---------|-------|-------------|
| POST | `/assign` | Assigne un livreur |
| GET | `/available` | Courses disponibles |
| POST | `/:id/scan-departure` | Scan QR départ |
| POST | `/:id/scan-arrival` | Scan QR arrivée |
| POST | `/:id/position` | Update position GPS |

### Dispute Service (`/api/v1/disputes/`)

| Méthode | Route | Description |
|---------|-------|-------------|
| POST | `/open` | Ouvre un litige |
| GET | `/:id` | Détails du litige |
| POST | `/:id/message` | Envoie un message médiation |
| POST | `/:id/resolve` | Résout le litige |
| POST | `/:id/evidence` | Ajoute une preuve |

---

## 💰 Grille tarifaire

| Montant de la transaction | Frais OCALM |
|---------------------------|-------------|
| 0 — 10 000 FCFA | 100 FCFA |
| 10 001 — 30 000 FCFA | 300 FCFA |
| 30 001 — 100 000 FCFA | 500 FCFA |
| 100 001 — 500 000 FCFA | 1 000 FCFA |
| Plus de 500 000 FCFA | 2 500 FCFA |

**Qui paie quoi ?**
- 🛒 **Acheteur** : Article + Frais OCALM + Frais livraison (si applicable)
- 🏪 **Vendeur** : GRATUIT (0 FCFA)
- 🚚 **Livreur** : Payé ~1 200 à 2 000 FCFA par course

---

## 🔐 Sécurité

### Authentification
- Connexion par **téléphone + OTP** (pas de mot de passe)
- Tokens **JWT** avec expiration courte (7 jours) + refresh (30 jours)
- Rate limiting : max 3 OTP / 15 min, blocage après 5 tentatives

### Paiements
- Vérification webhook **HMAC-SHA256** (pas de faux SMS/notifications)
- Clés d'**idempotence** (pas de double débit)
- Paiement uniquement via API opérateur officielle (Wave)

### Transactions
- Double validation : **QR code** + **OTP secours** (6 chiffres)
- QR codes dynamiques (UUID unique par transaction)
- Fonds gelés immédiatement en cas de litige

### Anti-fraude (4 niveaux)
1. Vérification téléphone par OTP
2. Vérification identité livreur (CNI + selfie)
3. Webhook signé HMAC pour confirmation paiement
4. Audit trail immuable (toutes les actions loguées)

### Infrastructure
- Rate limiting par IP et par téléphone (Nginx + Redis)
- Headers de sécurité (X-Content-Type-Options, X-Frame-Options)
- Base de données avec connexions pool (min 2, max 10)

---

## 🌍 Déploiement

### Production (recommandé)

```bash
# 1. Serveur Linux (Ubuntu 22.04+) avec Docker
ssh user@votre-serveur

# 2. Cloner et configurer
git clone https://github.com/votre-org/ocalm.git
cd ocalm/backend

# 3. Créer le fichier .env de production
cp .env.example .env.production
# Éditer avec les vrais secrets: JWT_SECRET, WAVE_API_KEY, etc.

# 4. Lancer en production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# 5. Configurer SSL (Certbot/Let's Encrypt)
# 6. Configurer le nom de domaine: api.ocalm.ci
```

### Variables d'environnement requises

```env
# Auth
JWT_SECRET=<générer avec: openssl rand -hex 64>
OTP_EXPIRY_MINUTES=5

# Database
DATABASE_URL=postgresql://user:password@host:5432/ocalm

# Redis
REDIS_URL=redis://:password@host:6379

# Wave API (obtenir sur https://developers.wave.com)
WAVE_API_KEY=<votre_clé_wave>
WAVE_API_SECRET=<votre_secret_wave>
WAVE_WEBHOOK_SECRET=<secret_webhook>

# Firebase (notifications push)
FCM_SERVICE_ACCOUNT=<chemin_vers_service_account.json>

# SMS Provider
SMS_API_KEY=<clé_fournisseur_sms>
```

### Build Flutter (APK / iOS)

```bash
cd mobile

# APK Android
flutter build apk --release

# App Bundle (Play Store)
flutter build appbundle --release

# iOS (nécessite macOS + Xcode)
flutter build ios --release
```

---

## 🗺 Roadmap

### ✅ Phase 1 — MVP (Actuel)
- [x] Module Acheteur complet
- [x] Module Vendeur complet
- [x] Module Livreur complet
- [x] Module Admin (Dashboard + Litiges + Users)
- [x] Backend 6 microservices
- [x] Intégration Wave (sandbox)
- [x] QR codes + OTP
- [x] Système de litiges

### 🔜 Phase 2 — Lancement
- [ ] Intégration Wave API production
- [ ] SMS OTP réel (fournisseur local)
- [ ] Push notifications Firebase
- [ ] Vérification identité livreur (CNI + selfie)
- [ ] Tests E2E complets
- [ ] Déploiement serveur production
- [ ] Publication Play Store

### 📅 Phase 3 — Croissance
- [ ] Orange Money, MTN MoMo, Moov Money
- [ ] Tracking GPS temps réel livreur
- [ ] Chat intégré acheteur/vendeur
- [ ] Système de notation/avis
- [ ] Programme fidélité
- [ ] Extension à d'autres pays UEMOA (Sénégal, Burkina, Mali)

### 🚀 Phase 4 — Scale
- [ ] API marchands (intégration e-commerce)
- [ ] Abonnement vendeur Pro
- [ ] Assurance colis
- [ ] Intelligence artificielle anti-fraude
- [ ] Partenariats transporteurs

---

## 👥 Équipe

**OCALM** est développé pour résoudre un vrai problème du quotidien en Afrique de l'Ouest : la confiance dans les transactions entre inconnus.

---

## 📄 Licence

Propriétaire — Tous droits réservés © 2025 OCALM

---

> *"Fais tes affaires... Au Calme."* 🔒
