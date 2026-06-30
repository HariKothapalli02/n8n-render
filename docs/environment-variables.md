# Environment Variables Reference

Complete reference for every environment variable used in this deployment.

## Database Variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `DB_TYPE` | Yes | `postgresdb` | Always `postgresdb` for n8n with PostgreSQL |
| `DB_POSTGRESDB_HOST` | Yes | - | Neon hostname from connection string |
| `DB_POSTGRESDB_PORT` | Yes | `5432` | PostgreSQL port |
| `DB_POSTGRESDB_DATABASE` | Yes | - | Neon database name |
| `DB_POSTGRESDB_USER` | Yes | - | Neon database user |
| `DB_POSTGRESDB_PASSWORD` | Yes | - | Neon password - set only in Render Dashboard |
| `DB_POSTGRESDB_SSL_ENABLED` | Yes | `true` | Must be true for Neon |
| `DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED` | Yes | `false` | Accept Neon managed TLS cert |

## n8n Core Variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `N8N_PORT` | Yes | `5678` | Port n8n listens on |
| `N8N_HOST` | Yes | - | Render domain e.g. `foo.onrender.com` (no https://) |
| `N8N_PROTOCOL` | Yes | `https` | https on Render, http for local dev |
| `WEBHOOK_URL` | Yes | - | Full URL e.g. `https://foo.onrender.com/` (trailing slash required) |
| `N8N_ENCRYPTION_KEY` | Yes | - | 32-byte hex key - never rotate after first deploy |
| `GENERIC_TIMEZONE` | No | `Asia/Kolkata` | Timezone for cron triggers |
| `N8N_RUNNERS_ENABLED` | No | `true` | Enable task runner architecture |

## Security Variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `N8N_BASIC_AUTH_ACTIVE` | Yes | `true` | Enable basic authentication |
| `N8N_BASIC_AUTH_USER` | Yes | - | Login username |
| `N8N_BASIC_AUTH_PASSWORD` | Yes | - | Login password - set only in Render Dashboard |
| `N8N_SECURE_COOKIE` | Yes | `true` | HTTPS-only session cookies |

## Logging Variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `N8N_LOG_LEVEL` | No | `info` | Verbosity: error, warn, info, debug |
| `N8N_LOG_OUTPUT` | No | `console` | Destination: console or file |

## Render System Variables

| Variable | Source | Description |
|---|---|---|
| `PORT` | Render auto-injected | Dynamic port assigned by Render, mapped to N8N_PORT |
