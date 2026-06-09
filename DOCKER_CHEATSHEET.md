# 🐳 Docker Commands Cheat Sheet

## Basic Docker Commands

### Container Management
```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Start a container
docker start [container_id]

# Stop a container gracefully
docker stop [container_id]

# Stop all containers
docker stop $(docker ps -q)

# Remove a container
docker rm [container_id]

# View container logs
docker logs [container_id]

# Follow logs (live stream)
docker logs -f [container_id]

# Get last 100 lines with timestamps
docker logs --tail=100 --timestamps [container_id]

# Execute command in running container
docker exec [container_id] [command]

# Get interactive shell in container
docker exec -it [container_id] bash

# Inspect container details
docker inspect [container_id]

# Rename a container
docker rename [old_name] [new_name]

# Restart a container
docker restart [container_id]
```

### Image Management
```bash
# List all images
docker images

# List images with size
docker images --size

# Search Docker Hub
docker search [image_name]

# Pull an image
docker pull [image]:[tag]

# Remove an image
docker rmi [image_id]

# Remove all unused images
docker image prune -a

# Build image from Dockerfile
docker build -t [name]:[tag] .

# Build without cache
docker build --no-cache -t [name]:[tag] .

# Tag an image
docker tag [image_id] [new_name]:[tag]
```

### Network & Ports
```bash
# List networks
docker network ls

# Inspect network
docker network inspect [network_name]

# Get container IP address
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' [container]

# Forward port from container
docker run -p 8000:8000 [image]

# Forward port range
docker run -p 8000-8010:8000-8010 [image]
```

---

## Docker Compose Commands

### Service Management
```bash
# Build all services
docker compose build

# Build specific service
docker compose build [service]

# Build without cache
docker compose build --no-cache

# Start all services in background
docker compose up -d

# Start all services in foreground (view logs)
docker compose up

# Start specific service
docker compose up -d [service]

# Stop all services
docker compose down

# Stop all services and remove volumes (⚠️ deletes data)
docker compose down -v

# Stop specific service
docker compose stop [service]

# Restart specific service
docker compose restart [service]

# View service status
docker compose ps

# View detailed status
docker compose ps --all

# Pause services
docker compose pause

# Resume paused services
docker compose unpause
```

### Container Operations
```bash
# View logs from all services
docker compose logs

# View logs from specific service
docker compose logs [service]

# Follow logs (live stream)
docker compose logs -f

# View logs from specific service live
docker compose logs -f [service]

# View last 100 lines
docker compose logs --tail=100

# Show timestamps in logs
docker compose logs --timestamps

# Execute command in service container
docker compose exec [service] [command]

# Execute command without TTY (for scripts)
docker compose exec -T [service] [command]

# Get interactive shell in service
docker compose exec [service] bash

# List running processes
docker compose exec [service] ps aux
```

### Image Management
```bash
# Pull latest images
docker compose pull

# Push images to registry
docker compose push

# View service images
docker compose images
```

### Environment & Configuration
```bash
# List services
docker compose config --services

# Validate docker-compose.yml
docker compose config

# Show what would be done (dry-run)
docker compose --dry-run up -d

# Use different compose file
docker compose -f docker-compose.prod.yml up -d

# Use multiple compose files
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Override environment variables
GROQ_API_KEY=xxx docker compose up -d
```

---

## System Management

### Cleanup
```bash
# Remove all stopped containers
docker container prune

# Remove all unused images
docker image prune

# Remove all unused volumes
docker volume prune

# Remove all unused networks
docker network prune

# Remove everything (containers, images, volumes, networks)
docker system prune

# Remove everything including all images
docker system prune -a

# Remove dangling images
docker image prune --filter "dangling=true"

# Show disk usage
docker system df

# Show detailed disk usage
docker system df -v
```

### Monitoring & Stats
```bash
# View resource usage (live)
docker stats

# View stats for specific container
docker stats [container]

# View without streaming
docker stats --no-stream

# Get container resource limits
docker inspect [container] | grep -A 10 "Memory"
```

### System Information
```bash
# Docker version
docker version

# Docker info
docker info

# View events (in real-time)
docker events

# Show Docker system info
docker system info
```

---

## Vihara AI Specific Commands

### Service Management
```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# View all services status
docker compose ps

# View logs
docker compose logs -f

# Restart backend
docker compose restart backend

# Restart frontend
docker compose restart frontend

# Restart database
docker compose restart postgres
```

### Access Services
```bash
# Access PostgreSQL
docker compose exec postgres psql -U vihara -d vihara_db

# Access Redis
docker compose exec redis redis-cli -a [REDIS_PASSWORD]

# Access backend shell
docker compose exec backend bash

# Access frontend shell
docker compose exec frontend bash

# Access Nginx logs
docker compose exec frontend tail -f /var/log/nginx/access.log
```

### Database Operations
```bash
# Backup database
docker compose exec -T postgres pg_dump -U vihara vihara_db > backup.sql

# Backup compressed
docker compose exec -T postgres pg_dump -U vihara vihara_db | gzip > backup.sql.gz

# Restore from backup
docker compose exec postgres psql -U vihara vihara_db < backup.sql

# Restore from compressed backup
gunzip < backup.sql.gz | docker compose exec -T postgres psql -U vihara vihara_db

# Check database size
docker compose exec postgres psql -U vihara -d vihara_db -c "SELECT pg_size_pretty(pg_database_size('vihara_db'));"

# List tables
docker compose exec postgres psql -U vihara -d vihara_db -c "\dt"
```

### API Testing
```bash
# Test health endpoint
curl http://localhost/api/health

# Test API docs
curl http://localhost/api/docs

# Get API version
curl http://localhost/api/version

# Test database connection
docker compose exec postgres psql -U vihara -d vihara_db -c "SELECT 1;"

# Test Redis
docker compose exec redis redis-cli ping
# Should respond: PONG
```

### Logs & Debugging
```bash
# All logs
docker compose logs

# Backend logs
docker compose logs backend

# Frontend logs
docker compose logs frontend

# Database logs
docker compose logs postgres

# Live logs (all services)
docker compose logs -f

# Live backend logs
docker compose logs -f backend

# Last 50 lines with timestamps
docker compose logs --tail=50 --timestamps

# Search logs for errors
docker compose logs | grep -i error

# Follow specific errors
docker compose logs -f | grep -i error
```

### Build & Deployment
```bash
# Build all images
docker compose build

# Build specific service
docker compose build backend

# Build without cache
docker compose build --no-cache

# Build and start
docker compose up -d --build

# Pull latest base images
docker compose pull

# Rebuild and restart
docker compose up -d --build
```

### Scaling
```bash
# Scale service to 3 instances (if configured)
docker compose up -d --scale backend=3

# Note: Vihara uses single instances by default
```

---

## Advanced Commands

### Network Debugging
```bash
# Inspect service network
docker compose exec [service] nslookup [service_name]

# Test connectivity
docker compose exec [service] curl http://backend:8000/health

# Check open ports
docker compose exec [service] netstat -tuln

# Check network interfaces
docker compose exec [service] ip addr show
```

### Performance Optimization
```bash
# View memory usage
docker stats --no-stream

# Limit memory for service
# (Add to docker-compose.yml):
# deploy:
#   resources:
#     limits:
#       memory: 512M

# View image layers
docker history [image]

# Inspect build cache
docker builder du
```

### Security & Scanning
```bash
# Scan image for vulnerabilities
docker scan [image]

# View image details
docker inspect [image]

# Check running processes
docker compose exec [service] ps aux

# Check file permissions
docker compose exec [service] ls -la /app
```

---

## Troubleshooting Commands

### Find Issues
```bash
# Check if port is in use
lsof -i :8000
# or
netstat -ano | findstr :8000

# Find containers by state
docker ps -a --filter "status=exited"

# Find largest images
docker images --sort size

# Find dangling volumes
docker volume ls -f dangling=true

# Check container health
docker ps --format "{{.Names}}\t{{.Status}}"
```

### Fix Issues
```bash
# Restart Docker daemon
systemctl restart docker

# Force restart container
docker restart -t 0 [container]

# Remove container forcefully
docker rm -f [container]

# Remove unused volumes
docker volume prune

# Rebuild everything fresh
docker compose down -v
docker compose build --no-cache
docker compose up -d
```

---

## Environment Variables in Docker Compose

### Pass Single Variable
```bash
GROQ_API_KEY=xxx docker compose up -d
```

### Pass Multiple Variables
```bash
GROQ_API_KEY=xxx HUGGINGFACE_TOKEN=yyy docker compose up -d
```

### From File
```bash
# Create .env file
cat > .env << EOF
GROQ_API_KEY=xxx
HUGGINGFACE_TOKEN=yyy
EOF

# Use it
docker compose up -d
```

### Override in compose file
```bash
environment:
  GROQ_API_KEY: ${GROQ_API_KEY}
  DB_PASSWORD: ${DB_PASSWORD}
```

---

## File Management

### Copy Files
```bash
# Copy file from container to host
docker cp [container]:[path] [host_path]
docker compose cp [service]:[path] [host_path]

# Copy file from host to container
docker cp [host_path] [container]:[path]
docker compose cp [host_path] [service]:[path]
```

### View Files
```bash
# List directory in container
docker compose exec [service] ls -la [path]

# View file contents
docker compose exec [service] cat [path]

# View logs file
docker compose exec [service] tail -f [log_path]
```

---

## Quick Reference Table

| Task | Command |
|------|---------|
| **Start** | `docker compose up -d` |
| **Stop** | `docker compose down` |
| **Status** | `docker compose ps` |
| **Logs** | `docker compose logs -f` |
| **Build** | `docker compose build` |
| **Backend Logs** | `docker compose logs -f backend` |
| **Database Backup** | `docker compose exec -T postgres pg_dump -U vihara vihara_db > backup.sql` |
| **Database Access** | `docker compose exec postgres psql -U vihara -d vihara_db` |
| **API Test** | `curl http://localhost/api/health` |
| **Restart Service** | `docker compose restart [service]` |
| **Clean Up** | `docker system prune -a` |

---

## Environment Variables Reference

### Critical Variables
```env
GROQ_API_KEY=gsk_...                    # AI Chat API
HUGGINGFACE_API_TOKEN=hf_...            # Vision API
SECRET_KEY=your_secret_key              # JWT signing
DB_PASSWORD=secure_password             # Database password
REDIS_PASSWORD=secure_password          # Cache password
```

### Optional Variables
```env
CLOUDINARY_CLOUD_NAME=...               # Image storage
CLOUDINARY_API_KEY=...
CLOUDINARY_API_SECRET=...
```

---

## Common Issues & Solutions

### Problem: Port Already in Use
```bash
# Find process using port
lsof -i :8000

# Kill process
kill -9 [PID]

# Or change port in .env
API_PORT=8001 docker compose up -d
```

### Problem: Can't Connect to Database
```bash
# Check if postgres is running
docker compose ps postgres

# View postgres logs
docker compose logs postgres

# Restart postgres
docker compose restart postgres

# Wait for it to be ready
sleep 10
docker compose restart backend
```

### Problem: Out of Memory
```bash
# Check memory usage
docker stats

# Stop containers
docker compose down

# Increase Docker memory limit (Docker Desktop)
# Settings → Resources → Increase Memory

# Restart
docker compose up -d
```

### Problem: Image Build Fails
```bash
# Clear build cache
docker compose build --no-cache

# View detailed build logs
docker compose build --verbose

# Check available disk space
df -h
```

---

## Best Practices

```bash
# ✅ DO:
docker compose up -d              # Start in background
docker compose logs -f            # Monitor logs
docker compose ps                 # Check status
docker system prune -a            # Regular cleanup
docker compose down               # Clean stop

# ❌ DON'T:
docker stop vihara-backend        # Don't use container name
docker rm -f container            # Don't force remove
docker image prune -a --force     # Without checking first
docker compose down -v            # Unless backing up first
docker pull *                     # Pull all images
```

---

**Remember**: Use `docker compose` for this project (not `docker-compose` which is deprecated).

For more help: `docker compose --help` or `docker --help`
