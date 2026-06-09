# 🚀 Deployment Steps - Visual Guide

## Phase 1: Preparation ⚙️

```
┌─────────────────────────────────────────────────────────────────┐
│                   PREPARATION PHASE                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Step 1: Install Prerequisites                                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ ☐ Install Docker (version 20.10+)                       │   │
│  │ ☐ Install Docker Compose (version 2.0+)                │   │
│  │ ☐ Verify: docker --version                              │   │
│  │ ☐ Verify: docker compose version                        │   │
│  │ ☐ Verify: docker run hello-world                        │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
│  Step 2: Get API Keys                                           │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ ☐ Get Groq API Key                                      │   │
│  │   → https://console.groq.com                            │   │
│  │   → Copy: gsk_xxxxxxxxxxxxxxx                           │   │
│  │                                                          │   │
│  │ ☐ Get HuggingFace Token                                 │   │
│  │   → https://huggingface.co/settings/tokens              │   │
│  │   → Copy: hf_xxxxxxxxxxxxxxx                            │   │
│  │                                                          │   │
│  │ ☐ (Optional) Get Cloudinary Keys                        │   │
│  │   → https://cloudinary.com                              │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
│  Step 3: Prepare Project Files                                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ ☐ Extract vihara-final-v6.zip                           │   │
│  │ ☐ cd vihara-gems-sound-fixed/                           │   │
│  │ ☐ Copy Docker files to project root:                    │   │
│  │   ├─ Dockerfile.backend                                 │   │
│  │   ├─ Dockerfile.frontend                                │   │
│  │   ├─ docker-compose.yml                                 │   │
│  │   ├─ nginx.conf                                         │   │
│  │   ├─ deploy.sh                                          │   │
│  │   └─ .env.example                                       │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Phase 2: Configuration 🔧

```
┌─────────────────────────────────────────────────────────────────┐
│                    CONFIGURATION PHASE                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Step 1: Create Environment File                                │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ $ cp .env.example .env                                  │   │
│  │                                                          │   │
│  │ File created: .env                                      │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
│  Step 2: Edit .env with Your Values                             │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ $ nano .env                                             │   │
│  │                                                          │   │
│  │ Required Changes:                                       │   │
│  │ ┌────────────────────────────────────────────────────┐  │   │
│  │ │ GROQ_API_KEY=gsk_YOUR_GROQ_KEY                    │  │   │
│  │ │ HUGGINGFACE_API_TOKEN=hf_YOUR_HF_TOKEN            │  │   │
│  │ │ DB_PASSWORD=your_secure_db_password               │  │   │
│  │ │ REDIS_PASSWORD=your_secure_redis_password         │  │   │
│  │ │ SECRET_KEY=your_super_secret_key                  │  │   │
│  │ │ QDRANT_API_KEY=your_qdrant_key                    │  │   │
│  │ └────────────────────────────────────────────────────┘  │   │
│  │                                                          │   │
│  │ Optional:                                               │   │
│  │ ├─ CLOUDINARY_CLOUD_NAME                               │   │
│  │ ├─ CLOUDINARY_API_KEY                                  │   │
│  │ └─ CLOUDINARY_API_SECRET                               │   │
│  │                                                          │   │
│  │ Save and Exit (Ctrl+X, then Y, then Enter)             │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
│  Step 3: Verify Configuration                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ $ cat .env | grep GROQ_API_KEY                         │   │
│  │ GROQ_API_KEY=gsk_...                                   │   │
│  │                                                          │   │
│  │ $ cat .env | grep HUGGINGFACE                          │   │
│  │ HUGGINGFACE_API_TOKEN=hf_...                           │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Phase 3: Build 🏗️

```
┌─────────────────────────────────────────────────────────────────┐
│                       BUILD PHASE                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Step 1: Make Deploy Script Executable                          │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ $ chmod +x deploy.sh                                    │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
│  Step 2: Option A - Automated Build (Recommended)               │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ $ ./deploy.sh                                           │   │
│  │                                                          │   │
│  │ ✓ Checks Docker installation                           │   │
│  │ ✓ Verifies .env file                                   │   │
│  │ ✓ Builds Docker images                                 │   │
│  │ ✓ Starts containers                                    │   │
│  │ ✓ Waits for services to be healthy                     │   │
│  │ ✓ Shows access URLs                                    │   │
│  │                                                          │   │
│  │ Time: 2-5 minutes                                       │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
│  Step 2: Option B - Manual Build                                │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ $ docker compose build                                  │   │
│  │                                                          │   │
│  │ [+] Building 45.2s (15/15) FINISHED                   │   │
│  │                                                          │   │
│  │ Building frontend image...                              │   │
│  │ Downloading Node modules                                │   │
│  │ Building Vite bundle                                    │   │
│  │                                                          │   │
│  │ Building backend image...                               │   │
│  │ Downloading Python packages                             │   │
│  │ Installing requirements                                 │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
│  Step 3: Verify Images Built Successfully                      │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ $ docker images | grep vihara                           │   │
│  │                                                          │   │
│  │ REPOSITORY                                  TAG         │   │
│  │ vihara-gems-sound-fixed-backend             latest      │   │
│  │ vihara-gems-sound-fixed-frontend            latest      │   │
│  │                                                          │   │
│  │ ✓ Both images present                                   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Phase 4: Deployment 🚀

```
┌─────────────────────────────────────────────────────────────────┐
│                    DEPLOYMENT PHASE                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Step 1: Start All Services                                     │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ $ docker compose up -d                                  │   │
│  │                                                          │   │
│  │ Creating vihara-postgres ... done                       │   │
│  │ Creating vihara-redis ... done                          │   │
│  │ Creating vihara-qdrant ... done                         │   │
│  │ Creating vihara-backend ... done                        │   │
│  │ Creating vihara-frontend ... done                       │   │
│  │                                                          │   │
│  │ Time: 30 seconds                                        │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
│  Step 2: Check Service Status                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ $ docker compose ps                                     │   │
│  │                                                          │   │
│  │ NAME              STATUS          PORTS                 │   │
│  │ vihara-postgres   Up (healthy)    5432/tcp              │   │
│  │ vihara-redis      Up (healthy)    6379/tcp              │   │
│  │ vihara-qdrant     Up (healthy)    6333/tcp              │   │
│  │ vihara-backend    Up (healthy)    8000/tcp              │   │
│  │ vihara-frontend   Up (healthy)    80/tcp                │   │
│  │                                                          │   │
│  │ ✓ All containers running and healthy                    │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
│  Step 3: Wait for Services to Be Ready (2-3 minutes)            │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                                                          │   │
│  │ ⏳ Waiting... (watch status with docker compose ps)     │   │
│  │                                                          │   │
│  │ What's happening:                                       │   │
│  │ ├─ PostgreSQL: Initializing database                    │   │
│  │ ├─ Redis: Starting cache service                        │   │
│  │ ├─ Qdrant: Initializing vector database                 │   │
│  │ ├─ Backend: Running database migrations                 │   │
│  │ │            Connecting to services                     │   │
│  │ │            Starting FastAPI server                    │   │
│  │ └─ Frontend: Serving Nginx on port 80                   │   │
│  │                                                          │   │
│  │ ✓ All services should show (healthy) in STATUS         │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Phase 5: Verification ✅

```
┌─────────────────────────────────────────────────────────────────┐
│                    VERIFICATION PHASE                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Step 1: Test Frontend                                          │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Open browser: http://localhost                          │   │
│  │                                                          │   │
│  │ ✓ You should see the Vihara AI homepage                 │   │
│  │ ✓ Check browser console (F12) for errors                │   │
│  │ ✓ Application is responsive                             │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
│  Step 2: Test API Documentation                                │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Open browser: http://localhost/api/docs                 │   │
│  │                                                          │   │
│  │ ✓ Swagger UI loads with all API endpoints               │   │
│  │ ✓ You can expand endpoints and see details              │   │
│  │ ✓ "Try it out" button works                             │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
│  Step 3: Test API Health Endpoint                               │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ $ curl http://localhost/api/health                      │   │
│  │                                                          │   │
│  │ {"status": "healthy"}                                   │   │
│  │                                                          │   │
│  │ ✓ Backend is running and responding                     │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
│  Step 4: Check Logs for Errors                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ $ docker compose logs | grep -i error                   │   │
│  │                                                          │   │
│  │ (Should return no errors or only warnings)              │   │
│  │                                                          │   │
│  │ ✓ No critical errors                                    │   │
│  │ ✓ All services initialized correctly                    │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
│  Step 5: Database Connection Test                               │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ $ docker compose exec postgres psql \\                 │   │
│  │   -U vihara -d vihara_db -c "SELECT 1;"                │   │
│  │                                                          │   │
│  │  ?column?                                                │   │
│  │ -----------                                              │   │
│  │        1                                                 │   │
│  │                                                          │   │
│  │ ✓ Database is accessible                                │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
│  Step 6: Redis Connection Test                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ $ docker compose exec redis redis-cli ping              │   │
│  │                                                          │   │
│  │ PONG                                                    │   │
│  │                                                          │   │
│  │ ✓ Cache is working                                      │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Phase 6: Usage 🎉

```
┌─────────────────────────────────────────────────────────────────┐
│                      USAGE PHASE                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Access Points                                                  │
│  ├─ 🌐 Frontend:  http://localhost                              │
│  ├─ 📚 API Docs:  http://localhost/api/docs                     │
│  ├─ 🔍 API Health: http://localhost/api/health                  │
│  └─ 🗄️  Vector DB: http://localhost:6333                       │
│                                                                   │
│  Useful Commands                                                │
│  ├─ docker compose ps              # Check status               │
│  ├─ docker compose logs -f          # View live logs             │
│  ├─ docker compose logs backend     # Backend logs only          │
│  ├─ docker compose restart backend  # Restart service            │
│  ├─ docker compose down             # Stop everything            │
│  └─ docker compose up -d            # Start everything           │
│                                                                   │
│  Next Steps                                                     │
│  ├─ ✅ Read DEPLOYMENT_GUIDE.md for advanced topics            │
│  ├─ ✅ Set up regular backups                                   │
│  ├─ ✅ Configure monitoring                                     │
│  ├─ ✅ Set up SSL/HTTPS for production                          │
│  └─ ✅ Deploy to cloud (AWS, GCP, Azure, DigitalOcean)         │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🆘 Troubleshooting Quick Fix

```
Issue                          Solution
─────────────────────────────────────────────────────────────
Container won't start         docker compose logs [service]

Port already in use            Change API_PORT, FRONTEND_PORT in .env
                               docker compose up -d

Database can't connect         docker compose restart postgres
                               Wait 30s
                               docker compose restart backend

API keys not working           Verify .env has correct keys
                               docker compose restart backend

Memory error                   Increase Docker memory
                               docker compose up -d

Reset everything              docker compose down -v
                               docker compose up -d
```

---

## 📊 Timeline Estimate

```
Task                          Duration    Cumulative
─────────────────────────────────────────────────────────
Preparation (install, get keys)   5 min      5 min
Configuration (.env setup)         3 min      8 min
Build Docker images                3 min     11 min
Start services                      1 min     12 min
Wait for healthy status            3 min     15 min
Run verification tests              2 min     17 min
────────────────────────────────────────────────────────
TOTAL FIRST DEPLOYMENT           ~15-20 min

Subsequent deployments:            2-5 min
(Just docker compose up -d)
```

---

## ✅ Final Checklist

```
BEFORE DEPLOYMENT:
☐ Docker installed (v20.10+)
☐ Docker Compose installed (v2.0+)
☐ Groq API key obtained
☐ HuggingFace token obtained
☐ .env file created and filled
☐ All files copied to project root

DURING DEPLOYMENT:
☐ ./deploy.sh ran successfully OR docker compose build succeeded
☐ docker compose ps shows 5 healthy services
☐ Frontend loads at http://localhost
☐ API docs accessible at http://localhost/api/docs

AFTER DEPLOYMENT:
☐ No errors in docker compose logs
☐ Database connection verified
☐ Redis connection verified
☐ API endpoints responding
☐ Application fully functional

PRODUCTION:
☐ .env changed to .env.prod with secure passwords
☐ ENVIRONMENT=production in .env
☐ DEBUG=False in .env
☐ SSL/HTTPS configured
☐ Backups scheduled
☐ Monitoring configured
☐ Security policies reviewed
```

---

🎉 **You're ready to deploy!** Start with Phase 1 and follow each step. 🚀
