# 🐳 Vihara AI - Complete Docker Deployment Guide

## 📋 Table of Contents
1. [Prerequisites](#prerequisites)
2. [Project Structure](#project-structure)
3. [Step-by-Step Deployment](#step-by-step-deployment)
4. [Verification & Testing](#verification--testing)
5. [Troubleshooting](#troubleshooting)
6. [Production Deployment](#production-deployment)
7. [Monitoring & Maintenance](#monitoring--maintenance)

---

## Prerequisites

### ✅ Required Software
- **Docker** (v20.10+) → [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose** (v2.0+) → [Install Compose](https://docs.docker.com/compose/install/)
- **Git** (optional, for cloning)
- **Text Editor** (VS Code, nano, vim)

### ✅ System Requirements
- **RAM**: Minimum 4GB (8GB+ recommended)
- **Disk Space**: 10GB free for containers and data
- **CPU**: 2+ cores
- **OS**: Linux, macOS, or Windows (with Docker Desktop)

### ✅ API Keys Required
Before deployment, get free API keys from:
1. **Groq AI** → https://console.groq.com (Chat/Voice)
2. **HuggingFace** → https://huggingface.co/settings/tokens (Vision/NLP)

*(Optional: Cloudinary for image storage)*

---

## Project Structure

After extracting your zip file, your directory should look like:
```
vihara-gems-sound-fixed/
├── backend/
│   ├── app/
│   ├── main.py
│   └── requirements.txt
├── frontend/
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── vite.config.ts
├── .env.example          ← Rename to .env
├── docker-compose.yml    ← Orchestration file
├── Dockerfile.backend    ← Backend container
├── Dockerfile.frontend   ← Frontend container
└── nginx.conf           ← Frontend web server config
```

---

## Step-by-Step Deployment

### STEP 1: Prepare Your Environment

#### 1.1 Navigate to Project Directory
```bash
cd vihara-gems-sound-fixed/
```

#### 1.2 Create .env File from Template
```bash
# Copy the example file
cp .env.example .env

# Edit the .env file with your actual values
nano .env
# or use your preferred editor: vim, VS Code, etc.
```

#### 1.3 Update .env File with Your Settings
Edit `.env` and replace these key variables:

```env
# Critical: Change these!
DB_PASSWORD=your_secure_database_password_here
REDIS_PASSWORD=your_secure_redis_password_here
SECRET_KEY=your_super_secret_jwt_key_here
QDRANT_API_KEY=your_qdrant_key_here

# Required: Add your API keys
GROQ_API_KEY=gsk_YOUR_GROQ_KEY_HERE
HUGGINGFACE_API_TOKEN=hf_YOUR_HF_TOKEN_HERE

# Optional but recommended
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

# Environment
ENVIRONMENT=production
```

---

### STEP 2: Verify Docker Installation

```bash
# Check Docker version
docker --version
# Output: Docker version 20.10.x, build xxxxx

# Check Docker Compose version
docker compose version
# Output: Docker Compose version v2.x.x

# Test Docker is running
docker run hello-world
# Should show: "Hello from Docker!"
```

---

### STEP 3: Build Docker Images

#### 3.1 Build All Images
```bash
# This builds both backend and frontend images
docker compose build

# You should see output like:
# [+] Building 45.2s (15/15) FINISHED
```

#### 3.2 Verify Images Were Built
```bash
docker images | grep vihara

# You should see:
# vihara-gems-sound-fixed-backend     latest    xxxxx     45 seconds ago
# vihara-gems-sound-fixed-frontend    latest    xxxxx     32 seconds ago
```

**What happens during build:**
- **Backend**: Downloads Python dependencies, copies code
- **Frontend**: Downloads Node modules, builds production bundle with Vite
- **Both**: Optimized multi-stage builds reduce final image size

---

### STEP 4: Start All Services

#### 4.1 Launch Containers (Foreground - see logs)
```bash
# Start all services and watch logs
docker compose up

# You'll see starting logs from all services
```

#### 4.2 Or Launch in Background (Recommended for production)
```bash
# Start all services in background
docker compose up -d

# Verify containers are running
docker compose ps

# You should see:
# NAME                COMMAND                  SERVICE      STATUS
# vihara-postgres     "docker-entrypoint.s…"   postgres     Up (healthy)
# vihara-redis        "redis-server --appe…"   redis        Up (healthy)
# vihara-qdrant       "/qdrant"                qdrant       Up (healthy)
# vihara-backend      "uvicorn main:app…"      backend      Up (healthy)
# vihara-frontend     "nginx -g daemon off…"   frontend     Up (healthy)
```

#### 4.3 Wait for All Services to Be Healthy (2-3 minutes)
```bash
# Watch the health status
docker compose ps --all

# All should show "healthy" in STATUS column
```

---

### STEP 5: Access Your Application

Once all services are healthy:

| Service | URL | Purpose |
|---------|-----|---------|
| **Frontend (Web App)** | http://localhost | Main application |
| **API Documentation** | http://localhost/api/docs | FastAPI Swagger UI |
| **API Health Check** | http://localhost/api/health | Backend status |
| **PostgreSQL** | localhost:5432 | Database (internal) |
| **Redis** | localhost:6379 | Cache (internal) |
| **Qdrant** | http://localhost:6333 | Vector DB (internal) |

---

### STEP 6: Verify Everything Works

#### 6.1 Check Frontend
Open in browser: `http://localhost`
- You should see the Vihara AI application loaded
- Check the browser console (F12) for any errors

#### 6.2 Check API Documentation
Open in browser: `http://localhost/api/docs`
- Interactive Swagger UI showing all API endpoints
- Try making test requests here

#### 6.3 Check Logs
```bash
# View all container logs
docker compose logs

# View specific service logs
docker compose logs backend      # Backend logs
docker compose logs frontend     # Frontend logs
docker compose logs postgres     # Database logs

# Stream logs in real-time
docker compose logs -f backend

# View logs from last 100 lines with timestamps
docker compose logs --tail=100 --timestamps
```

#### 6.4 Test API Endpoint
```bash
# Test health endpoint
curl http://localhost/api/health

# Should return: {"status": "healthy"}
```

---

## Verification & Testing

### ✅ Health Checks

```bash
# 1. Check all containers are running
docker compose ps

# 2. Check container logs for errors
docker compose logs | grep -i error

# 3. Test database connection
docker compose exec postgres psql -U vihara -d vihara_db -c "SELECT 1;"

# 4. Test Redis connection
docker compose exec redis redis-cli -a redis_secure_123 ping
# Should return: PONG

# 5. Test Qdrant
curl http://localhost:6333/health

# 6. Test API
curl http://localhost/api/health
```

### 🧪 Run Sample Requests

```bash
# 1. Get API health
curl -X GET http://localhost/api/health

# 2. Check Swagger UI (open in browser)
firefox http://localhost/api/docs
```

### 📊 Check Resource Usage
```bash
# View memory and CPU usage
docker stats

# See detailed container info
docker compose ps --all
```

---

## Troubleshooting

### ❌ Containers Won't Start

**Problem**: Containers keep exiting
```bash
# Solution: Check logs
docker compose logs backend

# Look for common errors like:
# - Port already in use
# - Database connection failed
# - API key missing
```

**Fix - Port Already in Use:**
```bash
# Find process using port 8000
lsof -i :8000
# or on Windows: netstat -ano | findstr :8000

# Kill the process or change ports in .env
FRONTEND_PORT=8080
API_PORT=8001
```

### ❌ Database Connection Failed

**Problem**: Backend can't connect to PostgreSQL
```
psycopg2.OperationalError: could not connect to server
```

**Solution:**
```bash
# Restart only database
docker compose restart postgres

# Wait 5 seconds for it to be ready
sleep 5

# Restart backend
docker compose restart backend

# Check logs
docker compose logs postgres backend
```

### ❌ Out of Memory

**Problem**: Containers getting killed randomly
```bash
# Solution: Increase Docker memory limit
# Windows/Mac: Docker Desktop Settings → Resources → Memory → increase
# Linux: docker-compose up --memory 2g

# Check memory usage
docker stats
```

### ❌ API Keys Not Working

**Problem**: AI features not working
```
GROQ_API_KEY invalid or missing
```

**Solution:**
```bash
# 1. Verify .env file exists
cat .env | grep GROQ_API_KEY

# 2. Check it was read by container
docker compose exec backend env | grep GROQ_API_KEY

# 3. Get new keys from:
# - Groq: https://console.groq.com
# - HuggingFace: https://huggingface.co/settings/tokens

# 4. Update .env
nano .env

# 5. Restart backend
docker compose restart backend
```

### ❌ Frontend Showing Blank Page

**Problem**: White/blank page when accessing http://localhost
```bash
# Solution: Check frontend logs
docker compose logs frontend

# Check browser console (F12 → Console tab)

# Rebuild frontend
docker compose build --no-cache frontend
docker compose up -d frontend
```

### ✅ Reset Everything (Nuclear Option)

```bash
# Stop all containers
docker compose down

# Remove all volumes (⚠️ DELETES DATA)
docker compose down -v

# Remove unused images
docker image prune -a

# Start fresh
docker compose up -d
```

---

## Production Deployment

### 🔒 Security Best Practices

#### 1. Strong Passwords
```bash
# Generate random secure passwords
python3 -c "import secrets; print(secrets.token_urlsafe(32))"

# Use these in .env for:
DB_PASSWORD
REDIS_PASSWORD
SECRET_KEY
QDRANT_API_KEY
```

#### 2. Update CORS Settings
```env
# In .env:
ALLOWED_ORIGINS=https://yourdomain.com,https://www.yourdomain.com
```

#### 3. Enable SSL/HTTPS
```bash
# Option 1: Use Certbot with Let's Encrypt
docker run -it --rm --name certbot \
  -v "/etc/letsencrypt:/etc/letsencrypt" \
  certbot/certbot certonly --standalone \
  -d yourdomain.com \
  -d www.yourdomain.com

# Option 2: Use Nginx with built-in SSL
# Add to nginx.conf SSL configuration
```

#### 4. Set Up Reverse Proxy (nginx on host)
```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com;
    
    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;
    
    location / {
        proxy_pass http://localhost:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 📈 Scaling for Production

#### 1. Use Production Docker Compose
```bash
# Create docker-compose.prod.yml with optimizations
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

#### 2. Configure Resource Limits
```yaml
# In docker-compose.yml:
services:
  backend:
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 2G
        reservations:
          cpus: '0.5'
          memory: 1G
```

#### 3. Database Backups
```bash
# Daily backup script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker compose exec -T postgres pg_dump -U vihara vihara_db > backup_$DATE.sql

# Restore from backup
docker compose exec postgres psql -U vihara vihara_db < backup_2024_01_15.sql
```

#### 4. Set Up Monitoring
```bash
# Install Portainer for Docker management
docker run -d -p 8000:8000 -p 9000:9000 \
  --name portainer \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce

# Access at http://localhost:9000
```

---

## Monitoring & Maintenance

### 📊 Regular Maintenance

```bash
# 1. Clean up unused images/containers (weekly)
docker system prune -a

# 2. Backup database (daily)
docker compose exec -T postgres pg_dump -U vihara vihara_db > backup.sql

# 3. Check disk usage
du -sh $(docker inspect -f '{{.GraphDriver.Data.MergedDir}}' $(docker ps -q))

# 4. View resource usage
docker stats --no-stream
```

### 🔄 Update Services

```bash
# 1. Update base images
docker compose pull

# 2. Rebuild with new images
docker compose build --no-cache

# 3. Restart services (zero-downtime with proper setup)
docker compose up -d
```

### 🚨 Monitoring with Logs

```bash
# Aggregate logs with timestamps
docker compose logs --timestamps --tail 1000 | tail -100

# Log specific errors
docker compose logs | grep -i error

# Monitor in real-time
watch -n 1 'docker compose ps'
```

### 💾 Database Management

```bash
# Access PostgreSQL CLI
docker compose exec postgres psql -U vihara -d vihara_db

# Inside PostgreSQL:
# List tables: \dt
# Show database size: SELECT pg_size_pretty(pg_database_size('vihara_db'));
# Exit: \q

# Backup with compression
docker compose exec -T postgres pg_dump -U vihara vihara_db | gzip > backup.sql.gz

# Restore from compressed backup
gunzip < backup.sql.gz | docker compose exec -T postgres psql -U vihara vihara_db
```

---

## 🎯 Quick Reference

### Common Commands

```bash
# Start services
docker compose up -d

# Stop services
docker compose down

# View status
docker compose ps

# View logs
docker compose logs -f

# Restart specific service
docker compose restart backend

# Execute command in container
docker compose exec backend bash

# View service resource usage
docker stats

# Rebuild images
docker compose build --no-cache

# Remove everything (dangerous!)
docker compose down -v
```

### Port Mapping Reference

| Container | Port | Access |
|-----------|------|--------|
| Frontend (Nginx) | 80 | http://localhost |
| Backend (FastAPI) | 8000 | http://localhost:8000 |
| PostgreSQL | 5432 | localhost:5432 |
| Redis | 6379 | localhost:6379 |
| Qdrant | 6333 | http://localhost:6333 |

---

## 📞 Support & Resources

- **Docker Docs**: https://docs.docker.com/
- **Docker Compose Docs**: https://docs.docker.com/compose/
- **FastAPI Docs**: https://fastapi.tiangolo.com/
- **Nginx Docs**: https://nginx.org/en/docs/
- **PostgreSQL Docs**: https://www.postgresql.org/docs/

---

## ✅ Deployment Checklist

- [ ] Docker and Docker Compose installed
- [ ] `.env` file created with all required values
- [ ] API keys obtained (Groq, HuggingFace)
- [ ] `docker compose build` successful
- [ ] `docker compose up -d` started all services
- [ ] `docker compose ps` shows all services as healthy
- [ ] Frontend accessible at http://localhost
- [ ] API docs accessible at http://localhost/api/docs
- [ ] Logs checked for errors: `docker compose logs`
- [ ] Database backups configured
- [ ] Monitoring set up (optional)

---

🎉 **Congratulations! Your Vihara AI is now running in Docker!**

For issues, check logs with: `docker compose logs` or specific service `docker compose logs backend`
