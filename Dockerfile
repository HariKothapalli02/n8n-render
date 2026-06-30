# ============================================================
# Production Dockerfile for n8n on Render
#
# The official n8nio/n8n image is fully self-contained:
#   - n8n binary is on PATH for the correct user
#   - .n8n data directory is pre-created
#   - ENTRYPOINT and CMD are already configured
#   - SSL certs and tzdata are already bundled
#   - Port 5678 is already exposed
#
# DO NOT add USER switches, RUN package installs, or CMD
# overrides - they all break the image's internal setup.
# All configuration is done via environment variables at runtime.
# ============================================================
FROM n8nio/n8n:latest
