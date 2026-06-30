# ============================================================
# Production Dockerfile for n8n on Render
# Uses official n8n image - no credentials baked in
# ============================================================
FROM n8nio/n8n:latest

# Switch to root to set up the environment, then drop back to node user
USER root

# Install CA certs so SSL connections to Neon PostgreSQL work cleanly
RUN apk add --no-cache ca-certificates tzdata

# Create the n8n data directory and set correct ownership
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node/.n8n

# Drop back to the unprivileged node user
USER node

# n8n listens on this port by default.
# Render injects PORT at runtime - mapped via N8N_PORT env var.
EXPOSE 5678

# All sensitive env vars are injected by Render at deploy time.
CMD ["n8n", "start"]
