# n8n on Render + Neon PostgreSQL

> **Production-ready** Dockerized n8n deployment for [Render](https://render.com) backed by [Neon](https://neon.tech) serverless PostgreSQL.

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy)

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Prerequisites](#prerequisites)
3. [Local Development](#local-development)
4. [Neon PostgreSQL Configuration](#neon-postgresql-configuration)
5. [Render Deployment](#render-deployment)
6. [Updating n8n](#updating-n8n)
7. [Database Backup & Restore](#database-backup--restore)
8. [Troubleshooting](#troubleshooting)
9. [Security Notes](#security-notes)

---

## Architecture Overview

```
Browser
  |
  v
Render Web Service (Docker)
  |  n8n:latest
  |  Port 5678 (mapped to Render's dynamic PORT)
  |
  v
Neon PostgreSQL (serverless)
  |  SSL required
  |  Region: ap-southeast-1
```

---

## Prerequisites

| Tool | Version | Purpose |
|------|---------|--------|
| Docker | >= 24.x | Build & run locally |
| Docker Compose | >= 2.x | Local orchestration |
| Git | >= 2.x | Version control |
| openssl | any | Generate encryption key |
| Render account | - | Cloud hosting |
| Neon account | - | Serverless PostgreSQL |
| GitHub account | - | Source repository |

---

## Local Development

### Clone & Configure

```bash
# 1. Clone the repository
git clone https://github.com/HariKothapalli02/n8n-render.git
cd n8n-render

# 2. Create your local environment file
cp .env.example .env

# 3. Generate a secure encryption key
openssl rand -hex 32
```

Open `.env` and fill in every value:

```dotenv
DB_HOST=ep-fancy-term-aoo0r92o.c-2.ap-southeast-1.aws.neon.tech
DB_PORT=5432
DB_NAME=neondb
DB_USER=neondb_owner
DB_PASSWORD=<your-neon-password>

N8N_HOST=localhost
N8N_PORT=5678
N8N_PROTOCOL=http
WEBHOOK_URL=http://localhost:5678/

N8N_ENCRYPTION_KEY=<output-from-openssl-above>
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=<choose-a-strong-password>

GENERIC_TIMEZONE=Asia/Kolkata
N8N_RUNNERS_ENABLED=true
N8N_SECURE_COOKIE=false
```

> WARNING: Never commit `.env` to Git. It is already listed in `.gitignore`.

### Docker Commands

```bash
# Build and start n8n
docker compose up --build

# Run in the background
docker compose up --build -d

# Tail logs
docker compose logs -f n8n

# Stop the service
docker compose down

# Stop and remove volume (resets local n8n data)
docker compose down -v

# Rebuild without cache
docker compose build --no-cache && docker compose up -d
```

Open your browser at **http://localhost:5678** and log in with your basic-auth credentials.

---

## Neon PostgreSQL Configuration

1. Log in to [console.neon.tech](https://console.neon.tech).
2. Under **Connection Details**, copy the connection string:
   ```
   postgresql://USER:PASSWORD@HOST/DBNAME?sslmode=require
   ```
3. Break it into individual components for Render's environment variables:

   | Render Env Var | Part of Connection String |
   |---|---|
   | `DB_POSTGRESDB_HOST` | hostname (after `@`, before `/`) |
   | `DB_POSTGRESDB_PORT` | `5432` |
   | `DB_POSTGRESDB_DATABASE` | database name (after last `/`, before `?`) |
   | `DB_POSTGRESDB_USER` | username (before `:`) |
   | `DB_POSTGRESDB_PASSWORD` | password (between `:` and `@`) |

4. Optionally enable **Neon Connection Pooling** and use the pooled hostname.

---

## Render Deployment

### Step 1 - Create Web Service

1. Log in to [dashboard.render.com](https://dashboard.render.com).
2. Click **New +** -> **Web Service**.
3. Select **Build and deploy from a Git repository**.
4. Connect GitHub and select **HariKothapalli02/n8n-render**.
5. Confirm runtime: **Docker**.
6. Dockerfile path: `./Dockerfile`.
7. Region: **Singapore**.

### Step 2 - Add Environment Variables

Navigate to **Environment** tab and add:

| Variable | Value |
|---|---|
| `DB_POSTGRESDB_HOST` | `ep-fancy-term-aoo0r92o.c-2.ap-southeast-1.aws.neon.tech` |
| `DB_POSTGRESDB_PORT` | `5432` |
| `DB_POSTGRESDB_DATABASE` | `neondb` |
| `DB_POSTGRESDB_USER` | `neondb_owner` |
| `DB_POSTGRESDB_PASSWORD` | your Neon password |
| `N8N_HOST` | `your-service-name.onrender.com` |
| `N8N_ENCRYPTION_KEY` | output of `openssl rand -hex 32` |
| `WEBHOOK_URL` | `https://your-service-name.onrender.com/` |
| `N8N_BASIC_AUTH_USER` | your chosen username |
| `N8N_BASIC_AUTH_PASSWORD` | your chosen strong password |

### Step 3 - Deploy & Verify

1. Click **Create Web Service**.
2. Wait ~2-4 minutes for the build to complete.
3. Once **Live**, open your service URL.
4. Confirm the n8n login page appears.
5. Log in and create a test workflow to verify execution.

---

## Updating n8n

```bash
# Push an empty commit to trigger auto-redeploy
git commit --allow-empty -m "chore: trigger n8n image update"
git push origin main
```

Render's `autoDeploy: true` will pick it up automatically.

---

## Database Backup & Restore

### Backup

```bash
pg_dump \
  "postgresql://neondb_owner:PASSWORD@ep-fancy-term-aoo0r92o.c-2.ap-southeast-1.aws.neon.tech/neondb?sslmode=require" \
  --no-password \
  --format=custom \
  --file=n8n_backup_$(date +%Y%m%d_%H%M%S).dump
```

Alternatively use **Neon Branching** for instant zero-cost snapshots:
- Neon Console -> your project -> **Branches** -> **New branch**.

### Restore

```bash
pg_restore \
  --dbname "postgresql://neondb_owner:PASSWORD@ep-fancy-term-aoo0r92o.c-2.ap-southeast-1.aws.neon.tech/neondb?sslmode=require" \
  --no-password \
  --clean \
  --if-exists \
  n8n_backup_YYYYMMDD_HHMMSS.dump
```

---

## Troubleshooting

### Service fails to start
- Verify all `DB_POSTGRESDB_*` variables are set in Render Dashboard.
- Check Neon IP allow-list is not blocking Render's egress IPs.

### SSL / certificate errors
- `DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED` is set to `false` to accept Neon's managed TLS cert.

### Blank page or redirect loop
- Ensure `N8N_PROTOCOL=https` and `N8N_SECURE_COOKIE=true`.
- Ensure `WEBHOOK_URL` starts with `https://` and ends with `/`.
- Verify `N8N_HOST` is the bare domain (no `https://` prefix).

### Encryption key mismatch
- **Never change `N8N_ENCRYPTION_KEY` after first deployment.**
- Store it in a password manager immediately.

### Free-tier sleep
- Use UptimeRobot to ping `/healthz` every 5 minutes.
- Upgrade to Starter or Standard plan to eliminate sleep.

### Connection pool exhausted
- Enable Neon Connection Pooling and use the pooled endpoint for `DB_POSTGRESDB_HOST`.

---

## Security Notes

- All credentials live exclusively in **Render's Environment Variables** - never in Git.
- `N8N_BASIC_AUTH_ACTIVE=true` enforces username/password on the UI.
- `N8N_SECURE_COOKIE=true` ensures session cookies are HTTPS-only.
- Neon enforces `sslmode=require` on all connections.
- Rotate `N8N_BASIC_AUTH_PASSWORD` regularly and redeploy.

---

*n8n latest - Render Docker runtime - Neon PostgreSQL (ap-southeast-1)*
