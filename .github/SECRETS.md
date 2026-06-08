# OCALM CI/CD — Secrets nécessaires

## GitHub Repository Secrets à configurer :

### Codecov
- `CODECOV_TOKEN` — Token pour upload coverage (https://codecov.io)

### Staging
- `STAGING_HOST` — IP/hostname du serveur staging
- `STAGING_USER` — User SSH (ex: deploy)
- `STAGING_SSH_KEY` — Clé privée SSH

### Production
- `PROD_HOST` — IP/hostname du serveur production
- `PROD_USER` — User SSH
- `PROD_SSH_KEY` — Clé privée SSH

### Notifications (optionnel)
- `SLACK_WEBHOOK_URL` — Webhook Slack pour notifications deploy

## GitHub Environments à créer :

### staging
- Pas de protection rules (auto-deploy)

### production
- ✅ Required reviewers (1 approbation minimum)
- ⏱️ Wait timer: 5 minutes (optionnel)
- 🔒 Branch protection: main only

## Commandes pour générer les clés SSH :

```bash
# Générer une paire de clés pour le déploiement
ssh-keygen -t ed25519 -C "ocalm-deploy" -f ~/.ssh/ocalm_deploy

# Ajouter la clé publique sur le serveur
ssh-copy-id -i ~/.ssh/ocalm_deploy.pub deploy@your-server

# Copier la clé privée dans GitHub Secrets
cat ~/.ssh/ocalm_deploy
```

## Structure sur le serveur :

```bash
# Sur staging/production
sudo mkdir -p /opt/ocalm
sudo chown deploy:deploy /opt/ocalm

# Copier le docker-compose.yml
scp backend/docker-compose.yml deploy@server:/opt/ocalm/

# Premier lancement
cd /opt/ocalm && docker compose up -d
```
