# Render Deployment Checklist

Use this checklist every time you deploy or update n8n on Render.

## First-Time Deployment

- [ ] Repository is pushed to GitHub (main branch)
- [ ] Log in to dashboard.render.com
- [ ] Click New + -> Web Service
- [ ] Connect GitHub -> select HariKothapalli02/n8n-render
- [ ] Confirm runtime: Docker
- [ ] Confirm Dockerfile path: ./Dockerfile
- [ ] Set Region: Singapore
- [ ] Add all environment variables (see README)
- [ ] Click Create Web Service
- [ ] Wait for build to finish (~2-4 min)
- [ ] Open service URL and confirm n8n login page
- [ ] Log in with N8N_BASIC_AUTH_USER / N8N_BASIC_AUTH_PASSWORD
- [ ] Create a test workflow and execute it
- [ ] Confirm execution in Executions panel

## Required Environment Variables in Render Dashboard

- [ ] DB_POSTGRESDB_HOST
- [ ] DB_POSTGRESDB_DATABASE
- [ ] DB_POSTGRESDB_USER
- [ ] DB_POSTGRESDB_PASSWORD
- [ ] N8N_HOST
- [ ] N8N_ENCRYPTION_KEY
- [ ] WEBHOOK_URL
- [ ] N8N_BASIC_AUTH_USER
- [ ] N8N_BASIC_AUTH_PASSWORD

## After Each Code Update

- [ ] git add .
- [ ] git commit -m "your message"
- [ ] git push origin main
- [ ] Monitor Render deployment logs
- [ ] Verify service health at /healthz
