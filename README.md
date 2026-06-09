# 🐳 Docker Deployment - Complete Summary

## 📦 What You've Received

This Docker setup includes everything needed to deploy your Vihara AI application with:

```
✅ Multi-container orchestration
✅ Production-ready configuration
✅ Database persistence
✅ Health checks & auto-restart
✅ SSL/HTTPS ready
✅ Zero-downtime deployment support
```

---

## 📄 Files Provided

### 1. **Dockerfile.backend**
- Multi-stage build for FastAPI backend
- Optimized Python image (python:3.11-slim)
- Automatic health checks
- Size: ~150-200MB

### 2. **Dockerfile.frontend**
- Multi-stage build for React + Vite
- Nginx web server for static files
- Automatic API proxy configuration
- Size: ~40-50MB

### 3. **docker-compose.yml**
- Orchestrates all services:
  - PostgreSQL (Database)
  - Redis (Cache)
  - Qdrant (Vector DB)
  - FastAPI Backend
  - Nginx Frontend
- Volume management for persistent data
- Health checks for all services
- Environment variable configuration

### 4. **nginx.conf**
- Frontend web server configuration
- API proxy to backend
- WebSocket support
- Gzip compression
- Static file caching
- Security headers

### 5. **.env.example**
- Template for environment variables
- Complete documentation of all options
- Copy this to `.env` and fill in your values

### 6. **DEPLOYMENT_GUIDE.md**
- Comprehensive 400+ line deployment guide
- Step-by-step instructions
- Troubleshooting section
- Production deployment tips
- Monitoring and maintenance

### 7. **deploy.sh**
- Automated deployment script
- Pre-flight checks
- Interactive setup
- Automatic service verification
- Quick access links

---

## 🚀 Quick Start (3 Steps)

### Step 1: Copy Files to Project Root
```bash
# Copy all Docker files to your project directory
# (alongside your backend/ and frontend/ directories)
cp Dockerfile.backend ./
cp Dockerfile.frontend ./
cp docker-compose.yml ./
cp nginx.conf ./
cp .env.example ./
cp deploy.sh ./
chmod +x deploy.sh
```

### Step 2: Configure Environment
```bash
# Create .env from template
cp .env.example .env

# Edit .env with your values
nano .env

# Required changes:
# - GROQ_API_KEY=gsk_your_key_here
# - HUGGINGFACE_API_TOKEN=hf_your_token_here
# - Change all passwords to strong values
```

### Step 3: Deploy
```bash
# Option A: Automated (recommended)
./deploy.sh

# Option B: Manual
docker compose build
docker compose up -d
docker compose ps
```

---

## 📊 Service Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    User's Browser                        │
│                  http://localhost                        │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│              Nginx (Frontend Container)                  │
│            - Serves React build files                   │
│            - Proxies API calls to backend               │
│            - Compression & caching                      │
│            - Port: 80 → 443 (with SSL)                  │
└────────────┬────────────────────────┬──────────────────┘
             │                        │
             │ /api/*                 │ /
             ▼                        ▼
    ┌────────────────────┐  ┌─────────────────────┐
    │ FastAPI Backend    │  │ React Frontend      │
    │ (Port 8000)        │  │ Static Files        │
    │ - API endpoints    │  │ React Components    │
    │ - Business logic   │  │ Vite built bundle   │
    │ - Auth & security  │  └─────────────────────┘
    └────────┬──────────┬┘
             │          │
       ┌─────▼────┐  ┌──▼──────────┐
       │           │  │             │
       ▼           ▼  ▼             ▼
    ┌──────────┐ ┌───────┐ ┌──────────┐ ┌────────┐
    │PostgreSQL│ │ Redis │ │ Qdrant   │ │Files   │
    │ Database │ │ Cache │ │Vector DB │ │Storage │
    │ Port5432 │ │P6379  │ │ P6333    │ │(Cloud) │
    └──────────┘ └───────┘ └──────────┘ └────────┘
```

---

## 🔄 Service Dependencies

```
┌─────────────────────────────────────────────┐
│          Container Dependencies              │
├─────────────────────────────────────────────┤
│ Frontend                                    │
│   ├─ depends on: Backend                    │
│   └─ port: 80 (HTTP), 443 (HTTPS)          │
├─────────────────────────────────────────────┤
│ Backend                                     │
│   ├─ depends on: PostgreSQL                 │
│   ├─ depends on: Redis                      │
│   ├─ depends on: Qdrant (optional)         │
│   └─ port: 8000 (API)                      │
├─────────────────────────────────────────────┤
│ PostgreSQL                                  │
│   ├─ no dependencies                        │
│   ├─ volume: postgres_data (persistent)    │
│   └─ port: 5432 (database)                 │
├─────────────────────────────────────────────┤
│ Redis                                       │
│   ├─ no dependencies                        │
│   ├─ volume: redis_data (persistent)       │
│   └─ port: 6379 (cache)                    │
├─────────────────────────────────────────────┤
│ Qdrant                                      │
│   ├─ no dependencies                        │
│   ├─ volume: qdrant_data (persistent)      │
│   └─ port: 6333 (vector DB)                │
└─────────────────────────────────────────────┘
```

---

## 📈 Resource Requirements

| Service | Image Size | Min RAM | Min CPU |
|---------|-----------|---------|---------|
| Backend | 150-200MB | 256MB | 0.25 |
| Frontend | 40-50MB | 128MB | 0.25 |
| PostgreSQL | 150MB | 256MB | 0.5 |
| Redis | 50MB | 128MB | 0.25 |
| Qdrant | 100MB | 256MB | 0.25 |
| **Total** | ~500MB | **1GB+** | **1.5+** |

**Recommended for Production:**
- RAM: 8GB minimum
- CPU: 4 cores
- Disk: 50GB for data

---

## 🔐 Security Checklist

### Immediate (Before First Deployment)
- [ ] Change all passwords in `.env`
  - `DB_PASSWORD`
  - `REDIS_PASSWORD`
  - `SECRET_KEY`
- [ ] Add your API keys
  - `GROQ_API_KEY`
  - `HUGGINGFACE_API_TOKEN`
- [ ] Set correct `ALLOWED_ORIGINS`
- [ ] Enable health checks (already configured)

### Before Production
- [ ] Set `ENVIRONMENT=production` in `.env`
- [ ] Set `DEBUG=False` in `.env`
- [ ] Configure SSL/HTTPS
- [ ] Set up database backups
- [ ] Configure firewall rules
- [ ] Set up monitoring
- [ ] Use environment-specific `.env.prod`
- [ ] Use strong, unique passwords (20+ chars)

### Ongoing
- [ ] Regular security updates for base images
- [ ] Database backups (daily/weekly)
- [ ] Log monitoring and alerting
- [ ] Access control and auditing
- [ ] Regular security patches

---

## 📋 Environment Variables Explained

```env
# Database Configuration
DATABASE_URL=postgresql+asyncpg://user:pass@postgres:5432/dbname
# Automatically generated from DB_USER, DB_PASSWORD, DB_NAME

# Redis Cache
REDIS_URL=redis://:password@redis:6379/0
# Used for session storage and caching

# Qdrant Vector Database
QDRANT_URL=http://qdrant:6333
# Used for vector similarity search in embeddings

# AI/ML Services
GROQ_API_KEY=gsk_...  # Chat & Voice synthesis
HUGGINGFACE_API_TOKEN=hf_...  # Vision & NLP models

# Security
SECRET_KEY=your_super_secret_key_here
# Used for JWT token signing - CHANGE IN PRODUCTION!

# Application
ENVIRONMENT=production  # or development, staging
DEBUG=False  # Always False in production

# Ports
API_PORT=8000
FRONTEND_PORT=80
```

---

## 🎯 Common Tasks

### View Logs
```bash
# All services
docker compose logs

# Specific service
docker compose logs backend
docker compose logs postgres

# Stream live logs
docker compose logs -f

# Show last 100 lines with timestamps
docker compose logs --tail=100 --timestamps
```

### Restart Services
```bash
# Single service
docker compose restart backend

# All services
docker compose restart

# Rebuild and restart
docker compose up -d --build
```

### Database Operations
```bash
# Backup database
docker compose exec -T postgres pg_dump -U vihara vihara_db > backup.sql

# Restore from backup
docker compose exec postgres psql -U vihara vihara_db < backup.sql

# Access PostgreSQL CLI
docker compose exec postgres psql -U vihara -d vihara_db

# List tables
\dt
# Exit
\q
```

### Stop/Start
```bash
# Stop all services (keep data)
docker compose down

# Stop and remove all data (⚠️ careful!)
docker compose down -v

# Restart everything
docker compose restart

# Stop specific service
docker compose stop backend
```

---

## ✅ Verification Checklist

After deployment, verify:

```bash
# 1. All containers running
docker compose ps
# All should show "healthy"

# 2. Frontend accessible
curl http://localhost
# Should return HTML

# 3. API accessible
curl http://localhost/api/health
# Should return: {"status": "healthy"}

# 4. API docs
curl http://localhost/api/docs
# Should return Swagger UI HTML

# 5. Database connection
docker compose exec postgres psql -U vihara -d vihara_db -c "SELECT 1;"
# Should return: 1

# 6. Redis connection
docker compose exec redis redis-cli ping
# Should return: PONG

# 7. Check logs for errors
docker compose logs | grep -i error
# Should return no errors
```

---

## 🆘 Troubleshooting Quick Links

**Problem** | **Solution**
---|---
Containers won't start | `docker compose logs` to see errors
Port already in use | Change `API_PORT` or `FRONTEND_PORT` in `.env`
"Can't connect to database" | Wait 30 seconds for PostgreSQL to start
Blank frontend page | Check browser console (F12), view `docker compose logs frontend`
API keys not working | Verify in `.env`, restart backend: `docker compose restart backend`
Out of memory | Increase Docker memory limit in Docker Desktop settings

See **DEPLOYMENT_GUIDE.md** for detailed troubleshooting.

---

## 📞 Support Resources

- **Docker Documentation**: https://docs.docker.com/
- **FastAPI**: https://fastapi.tiangolo.com/
- **PostgreSQL**: https://www.postgresql.org/docs/
- **Redis**: https://redis.io/documentation/
- **Nginx**: https://nginx.org/en/docs/
- **Docker Compose**: https://docs.docker.com/compose/reference/

---

## 🎓 Next Steps

1. **Read DEPLOYMENT_GUIDE.md** for detailed step-by-step instructions
2. **Run deploy.sh** for automated setup
3. **Check logs** if any issues occur
4. **Open http://localhost** to access your application
5. **Read API documentation** at http://localhost/api/docs

---

## 📝 Important Notes

- **Keep `.env` secure** - Never commit to version control
- **Use `.env.prod`** for production with different values
- **Backup database regularly** - `docker compose exec -T postgres pg_dump...`
- **Monitor logs** - `docker compose logs -f` for production monitoring
- **Update base images** - `docker compose pull && docker compose up -d`
- **Use health checks** - Already configured for all services

---

## 🎉 You're Ready!

Everything is configured and ready to deploy. Follow the Quick Start steps above or run:

```bash
./deploy.sh
```

Then open http://localhost in your browser! 🚀

---

**Last Updated**: June 2024
**Docker Version**: 20.10+
**Docker Compose Version**: 2.0+
#   v i h a r a - a i  
 