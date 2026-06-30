# ============================================================
# Production Dockerfile for n8n on Render
# Uses official n8n image - no credentials baked in
# n8n latest is Debian-based (not Alpine), so we use apt-get
# ============================================================
FROM n8nio/n8n:latest

# Switch to root to install packages, then drop back to node user
USER root

# Install CA certificates and timezone data
# n8n latest image is Debian-based - use apt-get, NOT apk
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends ca-certificates tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Ensure the n8n data directory exists with correct ownership
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node/.n8n

# Drop back to the unprivileged node user
USER node

# n8n listens on this port by default.
# Render injects PORT at runtime - mapped via N8N_PORT env var.
EXPOSE 5678

# All sensitive env vars are injected by Render at deploy time.
CMD ["n8n", "start"]
