# ============================================================
# Production Dockerfile for n8n on Render
# Uses the official n8n image - no credentials baked in.
# The official image ships with a custom minimal base that has
# NO package manager (no apk, no apt-get). All SSL certs and
# timezone data are already bundled inside the image.
# ============================================================
FROM n8nio/n8n:latest

# Switch to root only to fix directory ownership
USER root

# Ensure the n8n user-data directory exists with correct ownership.
# No package installs needed - the official image has everything built in.
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node/.n8n

# Drop back to the unprivileged node user
USER node

# n8n listens on 5678 by default.
# Render injects PORT at runtime - mapped via N8N_PORT env var.
EXPOSE 5678

# All sensitive env vars are injected by Render at deploy time.
CMD ["n8n", "start"]
