#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════
# Vihara AI - Docker Quick Start Script
# ═══════════════════════════════════════════════════════════════════════════

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ───────────────────────────────────────────────────────────────────────────
# Helper Functions
# ───────────────────────────────────────────────────────────────────────────

print_header() {
    echo -e "\n${BLUE}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} $1"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════╝${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# ───────────────────────────────────────────────────────────────────────────
# Pre-flight Checks
# ───────────────────────────────────────────────────────────────────────────

print_header "VIHARA AI - Docker Quick Start"

print_info "Running pre-flight checks..."

# Check Docker installation
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed!"
    print_info "Install from: https://docs.docker.com/get-docker/"
    exit 1
fi
print_success "Docker installed ($(docker --version))"

# Check Docker Compose
if ! command -v docker compose &> /dev/null; then
    print_error "Docker Compose is not installed!"
    print_info "Install from: https://docs.docker.com/compose/install/"
    exit 1
fi
print_success "Docker Compose installed ($(docker compose version | head -n 1))"

# Check Docker daemon is running
if ! docker ps &> /dev/null; then
    print_error "Docker daemon is not running!"
    print_info "Start Docker and try again"
    exit 1
fi
print_success "Docker daemon is running"

# Check if .env exists
if [ ! -f ".env" ]; then
    print_warning ".env file not found"
    
    if [ -f ".env.example" ]; then
        print_info "Creating .env from .env.example..."
        cp .env.example .env
        print_success "Created .env file"
        
        print_info "⚠️  Please edit .env with your API keys:"
        print_info "   - GROQ_API_KEY"
        print_info "   - HUGGINGFACE_API_TOKEN"
        print_info "   - Change passwords for security"
        
        # Open editor if available
        if command -v nano &> /dev/null; then
            read -p "Edit .env now? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                nano .env
            fi
        fi
    else
        print_error ".env.example not found!"
        exit 1
    fi
fi

print_success ".env file configured"

# ───────────────────────────────────────────────────────────────────────────
# Build Phase
# ───────────────────────────────────────────────────────────────────────────

print_header "Building Docker Images"

print_info "This may take 2-5 minutes..."

if docker compose build; then
    print_success "Docker images built successfully"
else
    print_error "Failed to build Docker images!"
    print_info "Run: docker compose logs"
    exit 1
fi

# ───────────────────────────────────────────────────────────────────────────
# Start Services
# ───────────────────────────────────────────────────────────────────────────

print_header "Starting Services"

print_info "Starting all containers in background..."

if docker compose up -d; then
    print_success "Containers started"
else
    print_error "Failed to start containers!"
    print_info "Run: docker compose logs"
    exit 1
fi

# ───────────────────────────────────────────────────────────────────────────
# Health Checks
# ───────────────────────────────────────────────────────────────────────────

print_header "Waiting for Services to Be Ready"

print_info "Waiting for services to start (up to 2 minutes)..."

# Function to check if all services are healthy
wait_for_healthy() {
    local max_attempts=60  # 5 minutes (60 * 5 seconds)
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        # Count healthy services
        local healthy=$(docker compose ps | grep -c "healthy" || true)
        local total=$(docker compose ps | tail -n +2 | wc -l)
        
        if [ "$healthy" -eq "$total" ] && [ "$total" -gt 0 ]; then
            return 0
        fi
        
        echo -ne "\r  Attempt $((attempt + 1))/$max_attempts - $healthy/$total services healthy..."
        
        sleep 5
        attempt=$((attempt + 1))
    done
    
    return 1
}

if wait_for_healthy; then
    print_success "All services are healthy!\n"
else
    print_warning "Some services may still be starting..."
    print_info "Check status with: docker compose ps"
fi

# ───────────────────────────────────────────────────────────────────────────
# Summary & Next Steps
# ───────────────────────────────────────────────────────────────────────────

print_header "🎉 Deployment Complete!"

# Get current status
echo -e "${BLUE}Service Status:${NC}"
docker compose ps --no-trunc | tail -n +2 | awk '{printf "  %-20s %-40s %-15s\n", $1, $2, $5}'

echo ""
echo -e "${BLUE}Access Points:${NC}"
echo -e "  ${GREEN}Frontend (Web App)${NC}       → http://localhost"
echo -e "  ${GREEN}API Documentation${NC}       → http://localhost/api/docs"
echo -e "  ${GREEN}API Health Check${NC}       → http://localhost/api/health"
echo -e "  ${GREEN}Qdrant Vector DB${NC}       → http://localhost:6333"

echo ""
echo -e "${BLUE}Useful Commands:${NC}"
echo -e "  ${YELLOW}View logs${NC}               → docker compose logs -f"
echo -e "  ${YELLOW}Backend logs${NC}           → docker compose logs -f backend"
echo -e "  ${YELLOW}Stop services${NC}          → docker compose down"
echo -e "  ${YELLOW}Service status${NC}         → docker compose ps"

echo ""
echo -e "${BLUE}Documentation:${NC}"
echo -e "  Full guide                  → DEPLOYMENT_GUIDE.md"
echo -e "  Environment config          → .env"
echo -e "  Docker Compose config       → docker-compose.yml"

echo ""
echo -e "${GREEN}Next Steps:${NC}"
echo -e "  1. Open http://localhost in your browser"
echo -e "  2. Check http://localhost/api/docs for API endpoints"
echo -e "  3. View logs with: ${YELLOW}docker compose logs -f${NC}"
echo -e "  4. Read DEPLOYMENT_GUIDE.md for detailed instructions"

echo ""

# Optional: Open browser
if command -v xdg-open &> /dev/null; then
    read -p "Open http://localhost in browser? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        xdg-open http://localhost &
    fi
elif command -v open &> /dev/null; then
    read -p "Open http://localhost in browser? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open http://localhost &
    fi
fi

print_success "Setup complete! Happy coding! 🚀"
