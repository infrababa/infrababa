# Docker Development Setup Guide
## NextGen Farmers Hub ERPNext Development

**Platform**: macOS (also works on Linux/Windows)
**Approach**: Docker containerized development
**Benefit**: Zero installation on host machine - everything runs in containers

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Project Structure](#project-structure)
4. [Docker Setup](#docker-setup)
5. [Development Workflow](#development-workflow)
6. [CLI Agent Instructions](#cli-agent-instructions)
7. [Testing](#testing)
8. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### What You Need on Your Mac

**Only 3 things:**

1. **Docker Desktop** (free)
   - Download: https://www.docker.com/products/docker-desktop
   - Install and start Docker Desktop
   - Verify: `docker --version` (should show v20+)

2. **Git** (probably already installed)
   - Verify: `git --version`
   - If not: `brew install git`

3. **VS Code** (optional but recommended)
   - Download: https://code.visualstudio.com
   - Install "Remote - Containers" extension

**That's it!** No Python, no Node.js, no MariaDB, no Redis needed on your Mac.

---

## Quick Start

### 30-Second Setup

```bash
# 1. Clone the setup repository
git clone https://github.com/yourusername/nextgen-farmers-hub.git
cd nextgen-farmers-hub

# 2. Start everything with Docker Compose
docker-compose up -d

# 3. Wait for initialization (first time: ~5 minutes)
docker-compose logs -f backend

# 4. Access ERPNext
# Open: http://localhost:8000
# Login: Administrator / admin

# 5. Start developing!
```

---

## Project Structure

```
nextgen-farmers-hub/
├── docker-compose.yml              ← Docker orchestration
├── Dockerfile.dev                  ← Custom app dev image
├── .devcontainer/                  ← VS Code container config
│   └── devcontainer.json
├── apps/
│   └── nextgen_farmers/            ← Your custom app code
│       ├── nextgen_farmers/
│       │   ├── doctype/
│       │   ├── api/
│       │   └── ...
│       ├── public/
│       ├── templates/
│       └── ...
├── sites/                          ← Site data (mounted volume)
├── docs/                           ← Your specifications
│   ├── PRODUCT_REQUIREMENTS_DOCUMENT.md
│   ├── CLI_AGENT_IMPLEMENTATION_GUIDE.md
│   └── ...
├── scripts/
│   ├── init-site.sh               ← Site initialization script
│   └── install-app.sh             ← App installation script
├── .gitignore
└── README.md
```

**What gets versioned:**
- ✅ `apps/nextgen_farmers/` - Your custom code
- ✅ `docker-compose.yml` - Container configuration
- ✅ `Dockerfile.dev` - Development image
- ✅ `scripts/` - Helper scripts
- ✅ `docs/` - Documentation
- ❌ `sites/` - Ignored (local data)
- ❌ Node modules, Python cache, etc.

---

## Docker Setup

### docker-compose.yml

Create this file in your project root:

```yaml
version: '3.8'

services:
  # MariaDB Database
  mariadb:
    image: mariadb:10.6
    container_name: nextgen-mariadb
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: nextgen_db
      MYSQL_USER: nextgen_user
      MYSQL_PASSWORD: nextgen_pass
    volumes:
      - mariadb-data:/var/lib/mysql
    networks:
      - nextgen-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis Cache
  redis:
    image: redis:7-alpine
    container_name: nextgen-redis
    networks:
      - nextgen-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Frappe/ERPNext Backend
  backend:
    image: frappe/erpnext:v15.20.1
    container_name: nextgen-backend
    depends_on:
      mariadb:
        condition: service_healthy
      redis:
        condition: service_healthy
    environment:
      - FRAPPE_SITE_NAME=nextgenfarmers.local
      - DB_HOST=mariadb
      - DB_PORT=3306
      - REDIS_CACHE=redis:6379/0
      - REDIS_QUEUE=redis:6379/1
      - REDIS_SOCKETIO=redis:6379/2
    volumes:
      - ./apps/nextgen_farmers:/home/frappe/frappe-bench/apps/nextgen_farmers
      - sites-data:/home/frappe/frappe-bench/sites
      - ./scripts:/scripts
    working_dir: /home/frappe/frappe-bench
    ports:
      - "8000:8000"    # Web interface
      - "9000:9000"    # Socketio
    networks:
      - nextgen-network
    command: >
      bash -c "
        if [ ! -f /home/frappe/frappe-bench/sites/nextgenfarmers.local/site_config.json ]; then
          echo 'First run: Initializing site...';
          bench new-site nextgenfarmers.local
            --db-root-password rootpassword
            --admin-password admin
            --no-mariadb-socket;
          bench --site nextgenfarmers.local install-app erpnext;
          bench --site nextgenfarmers.local install-app agriculture;
          if [ -d /home/frappe/frappe-bench/apps/nextgen_farmers ]; then
            bench --site nextgenfarmers.local install-app nextgen_farmers;
          fi;
        fi;
        bench start;
      "

  # Frappe Scheduler (Background jobs)
  scheduler:
    image: frappe/erpnext:v15.20.1
    container_name: nextgen-scheduler
    depends_on:
      - backend
    environment:
      - FRAPPE_SITE_NAME=nextgenfarmers.local
      - DB_HOST=mariadb
      - REDIS_CACHE=redis:6379/0
      - REDIS_QUEUE=redis:6379/1
    volumes:
      - ./apps/nextgen_farmers:/home/frappe/frappe-bench/apps/nextgen_farmers
      - sites-data:/home/frappe/frappe-bench/sites
    working_dir: /home/frappe/frappe-bench
    networks:
      - nextgen-network
    command: bench schedule

  # Frappe Worker (Queue processing)
  worker:
    image: frappe/erpnext:v15.20.1
    container_name: nextgen-worker
    depends_on:
      - backend
    environment:
      - FRAPPE_SITE_NAME=nextgenfarmers.local
      - DB_HOST=mariadb
      - REDIS_CACHE=redis:6379/0
      - REDIS_QUEUE=redis:6379/1
    volumes:
      - ./apps/nextgen_farmers:/home/frappe/frappe-bench/apps/nextgen_farmers
      - sites-data:/home/frappe/frappe-bench/sites
    working_dir: /home/frappe/frappe-bench
    networks:
      - nextgen-network
    command: bench worker --queue default,short,long

volumes:
  mariadb-data:
  sites-data:

networks:
  nextgen-network:
    driver: bridge
```

### Dockerfile.dev (for custom development)

```dockerfile
FROM frappe/erpnext:v15.20.1

# Set working directory
WORKDIR /home/frappe/frappe-bench

# Install additional Python packages if needed
RUN pip install --no-cache-dir \
    requests \
    cryptography

# Copy custom app
COPY --chown=frappe:frappe ./apps/nextgen_farmers ./apps/nextgen_farmers

# Install custom app
RUN cd apps/nextgen_farmers && \
    pip install -e .

# Expose ports
EXPOSE 8000 9000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:8000 || exit 1

# Default command
CMD ["bench", "start"]
```

### .gitignore

```gitignore
# Docker volumes
sites/*
!sites/.gitkeep

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/

# Node
node_modules/
npm-debug.log

# Frappe
*.egg-info/
.DS_Store
*.swp
*.swo
.vscode/settings.json

# Logs
*.log

# Database
*.sql
*.db
*.sqlite3

# Environment
.env
.env.local

# OS
.DS_Store
Thumbs.db
```

---

## Development Workflow

### Starting Development

```bash
# 1. Start all containers
docker-compose up -d

# 2. Check status
docker-compose ps

# Should see:
# nextgen-mariadb    running
# nextgen-redis      running
# nextgen-backend    running
# nextgen-scheduler  running
# nextgen-worker     running

# 3. Watch logs (optional)
docker-compose logs -f backend

# 4. Access ERPNext
open http://localhost:8000
# Login: Administrator / admin
```

### Working with Your Custom App

#### Create the App (First Time)

```bash
# Enter the backend container
docker exec -it nextgen-backend bash

# Inside container: Create custom app
cd /home/frappe/frappe-bench
bench new-app nextgen_farmers

# Answer prompts:
# - App Title: NextGen Farmers Hub
# - App Description: Cooperative management system
# - App Publisher: NextGen Farmers Hub
# - App Email: admin@nextgenfarmershub.com
# - App License: MIT

# Install on site
bench --site nextgenfarmers.local install-app nextgen_farmers

# Exit container
exit
```

The app will be created in `./apps/nextgen_farmers` on your Mac (via volume mount).

#### Develop on Your Mac

```bash
# Edit code on your Mac using VS Code or any editor
code apps/nextgen_farmers

# Your changes are instantly reflected in the container!
# No need to copy files or rebuild
```

#### Apply Changes

```bash
# After creating new DocTypes or making changes:

# Enter container
docker exec -it nextgen-backend bash

# Migrate database
bench --site nextgenfarmers.local migrate

# Clear cache
bench --site nextgenfarmers.local clear-cache

# Rebuild assets (if JS/CSS changed)
bench build --app nextgen_farmers

# Exit
exit

# OR run all from outside container:
docker exec -it nextgen-backend bench --site nextgenfarmers.local migrate
docker exec -it nextgen-backend bench --site nextgenfarmers.local clear-cache
```

### Useful Docker Commands

```bash
# View logs
docker-compose logs -f backend       # Backend logs
docker-compose logs -f mariadb       # Database logs
docker-compose logs -f worker        # Background worker logs

# Restart services
docker-compose restart backend       # Restart backend only
docker-compose restart               # Restart all

# Stop everything
docker-compose down

# Stop and remove volumes (DANGER: deletes database)
docker-compose down -v

# Execute commands in container
docker exec -it nextgen-backend bash
docker exec -it nextgen-backend bench --version
docker exec -it nextgen-backend bench console

# Check resource usage
docker stats
```

### Database Access

```bash
# Connect to MariaDB
docker exec -it nextgen-mariadb mysql -u root -prootpassword

# Inside MySQL:
USE nextgen_db;
SHOW TABLES;
SELECT * FROM `tabMember` LIMIT 10;
```

### Redis Access

```bash
# Connect to Redis
docker exec -it nextgen-redis redis-cli

# Inside Redis:
KEYS *
GET cache_key_name
```

---

## CLI Agent Instructions

### For Claude CLI (Running on Your Mac)

Claude CLI should execute commands **from your Mac**, interacting with Docker containers:

#### Setup Phase

```bash
# Claude CLI executes on your Mac:

# 1. Initialize project structure
mkdir nextgen-farmers-hub
cd nextgen-farmers-hub

# 2. Create docker-compose.yml
# (Content from above)

# 3. Start containers
docker-compose up -d

# 4. Wait for initialization
sleep 60

# 5. Create custom app inside container
docker exec -it nextgen-backend bash -c "
  cd /home/frappe/frappe-bench &&
  bench new-app nextgen_farmers
"

# 6. Initialize Git for custom app
cd apps/nextgen_farmers
git init
git add .
git commit -m 'Initial commit: NextGen Farmers Hub custom app'
```

#### Development Phase

```bash
# TASK-003: Create Member DocType

# Claude CLI executes:

# 1. Create DocType files on Mac
mkdir -p apps/nextgen_farmers/nextgen_farmers/nextgen_farmers/doctype/member
cd apps/nextgen_farmers/nextgen_farmers/nextgen_farmers/doctype/member

# 2. Create member.json (write file on Mac)
cat > member.json << 'EOF'
{
  "doctype": "DocType",
  "name": "Member",
  ...
}
EOF

# 3. Create member.py (write file on Mac)
cat > member.py << 'EOF'
from frappe.model.document import Document

class Member(Document):
    def validate(self):
        ...
EOF

# 4. Migrate database (execute in container)
docker exec -it nextgen-backend bench --site nextgenfarmers.local migrate

# 5. Clear cache (execute in container)
docker exec -it nextgen-backend bench --site nextgenfarmers.local clear-cache

# 6. Test (execute in container)
docker exec -it nextgen-backend bench --site nextgenfarmers.local console << 'PYTHON'
member = frappe.get_doc({
    "doctype": "Member",
    "member_name": "Test Farmer"
})
member.insert()
print(f"Created: {member.name}")
PYTHON

# 7. Commit (on Mac)
git add .
git commit -m "feat: Add Member DocType"
git push origin main
```

#### Testing Phase

```bash
# Run unit tests in container
docker exec -it nextgen-backend bench --site nextgenfarmers.local run-tests \
  --app nextgen_farmers \
  --doctype Member

# Run specific test
docker exec -it nextgen-backend bench --site nextgenfarmers.local run-tests \
  --app nextgen_farmers \
  --test nextgen_farmers.nextgen_farmers.doctype.member.test_member
```

---

## VS Code DevContainer (Optional but Awesome)

### .devcontainer/devcontainer.json

```json
{
  "name": "NextGen Farmers Hub Development",
  "dockerComposeFile": "../docker-compose.yml",
  "service": "backend",
  "workspaceFolder": "/home/frappe/frappe-bench/apps/nextgen_farmers",

  "customizations": {
    "vscode": {
      "extensions": [
        "ms-python.python",
        "ms-python.vscode-pylance",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint",
        "frappe.frappe-snippets"
      ],
      "settings": {
        "python.defaultInterpreterPath": "/home/frappe/frappe-bench/env/bin/python",
        "python.linting.enabled": true,
        "python.linting.pylintEnabled": true,
        "python.formatting.provider": "black",
        "editor.formatOnSave": true
      }
    }
  },

  "forwardPorts": [8000, 9000],

  "postCreateCommand": "bench --version",

  "remoteUser": "frappe"
}
```

### Using DevContainer

1. Open VS Code
2. Install "Remote - Containers" extension
3. Open project folder
4. Click "Reopen in Container" (bottom-right notification)
5. VS Code runs **inside** the container
6. Terminal = inside container (run bench commands directly)
7. Full IntelliSense for Frappe/ERPNext code

**Benefits:**
- Auto-completion works perfectly
- Debugging works
- Git integration
- No "docker exec" needed

---

## Helper Scripts

### scripts/init-site.sh

```bash
#!/bin/bash
# Initialize ERPNext site

set -e

SITE_NAME=${1:-nextgenfarmers.local}
ADMIN_PASSWORD=${2:-admin}

echo "Initializing site: $SITE_NAME"

bench new-site $SITE_NAME \
  --db-root-password rootpassword \
  --admin-password $ADMIN_PASSWORD \
  --no-mariadb-socket

echo "Installing ERPNext..."
bench --site $SITE_NAME install-app erpnext

echo "Installing Agriculture..."
bench --site $SITE_NAME install-app agriculture

if [ -d "apps/nextgen_farmers" ]; then
  echo "Installing NextGen Farmers..."
  bench --site $SITE_NAME install-app nextgen_farmers
fi

echo "Site initialized successfully!"
```

### scripts/install-app.sh

```bash
#!/bin/bash
# Install custom app on site

set -e

SITE_NAME=${1:-nextgenfarmers.local}

cd /home/frappe/frappe-bench

if [ ! -d "apps/nextgen_farmers" ]; then
  echo "Creating nextgen_farmers app..."
  bench new-app nextgen_farmers
fi

echo "Installing app on site..."
bench --site $SITE_NAME install-app nextgen_farmers

echo "Migrating database..."
bench --site $SITE_NAME migrate

echo "Building assets..."
bench build --app nextgen_farmers

echo "Custom app installed successfully!"
```

### scripts/create-doctype.sh

```bash
#!/bin/bash
# Helper to create new DocType

DOCTYPE_NAME=$1

if [ -z "$DOCTYPE_NAME" ]; then
  echo "Usage: ./scripts/create-doctype.sh 'DocType Name'"
  exit 1
fi

docker exec -it nextgen-backend bash -c "
  cd /home/frappe/frappe-bench &&
  bench --site nextgenfarmers.local console << 'PYTHON'
from frappe.core.doctype.doctype.doctype import DocType

doctype = frappe.get_doc({
    'doctype': 'DocType',
    'module': 'NextGen Farmers',
    'name': '$DOCTYPE_NAME',
    'custom': 0,
    'fields': []
})
doctype.insert()
print(f'Created DocType: {doctype.name}')
PYTHON
"

echo "DocType '$DOCTYPE_NAME' created!"
echo "Edit files at: apps/nextgen_farmers/nextgen_farmers/nextgen_farmers/doctype/$(echo $DOCTYPE_NAME | tr '[:upper:]' '[:lower:]' | tr ' ' '_')/"
```

Make scripts executable:
```bash
chmod +x scripts/*.sh
```

---

## Testing

### Unit Tests in Docker

```bash
# Run all tests for your app
docker exec -it nextgen-backend \
  bench --site nextgenfarmers.local run-tests --app nextgen_farmers

# Run specific DocType tests
docker exec -it nextgen-backend \
  bench --site nextgenfarmers.local run-tests \
  --app nextgen_farmers \
  --doctype Member

# Run with coverage
docker exec -it nextgen-backend \
  bench --site nextgenfarmers.local run-tests \
  --app nextgen_farmers \
  --coverage

# Run specific test file
docker exec -it nextgen-backend \
  bench --site nextgenfarmers.local run-tests \
  --app nextgen_farmers \
  --test nextgen_farmers.nextgen_farmers.doctype.member.test_member.TestMember.test_phone_validation
```

### Manual Testing

```bash
# Open interactive Python console in container
docker exec -it nextgen-backend bench --site nextgenfarmers.local console

# Inside console:
>>> member = frappe.get_doc("Member", "MEM-00001")
>>> member.member_name
>>> member.total_shares
```

### Integration Testing with Paystack

```bash
# Set test mode in container
docker exec -it nextgen-backend bench --site nextgenfarmers.local console << 'PYTHON'
settings = frappe.get_single("Paystack Settings")
settings.test_mode = 1
settings.public_key = "pk_test_xxxxx"
settings.secret_key = "sk_test_xxxxx"
settings.save()
print("Paystack test mode enabled")
PYTHON
```

---

## Troubleshooting

### Container Won't Start

```bash
# Check Docker is running
docker ps

# Check logs
docker-compose logs backend

# Restart services
docker-compose restart

# Nuclear option: rebuild
docker-compose down -v
docker-compose up -d --build
```

### Database Connection Issues

```bash
# Check MariaDB is healthy
docker exec -it nextgen-mariadb mysqladmin ping

# Check connection from backend
docker exec -it nextgen-backend bash
mysql -h mariadb -u nextgen_user -pnextgen_pass nextgen_db
```

### Site Not Loading

```bash
# Check bench is running
docker exec -it nextgen-backend bench --version

# Check site exists
docker exec -it nextgen-backend ls -la sites/

# Rebuild site
docker exec -it nextgen-backend bench --site nextgenfarmers.local rebuild
```

### Permission Issues

```bash
# Fix permissions in container
docker exec -it nextgen-backend bash -c "
  cd /home/frappe/frappe-bench &&
  chown -R frappe:frappe apps/nextgen_farmers sites/
"

# On Mac, fix local permissions
sudo chown -R $(whoami):staff apps/
```

### Port Already in Use

```bash
# Find what's using port 8000
lsof -i :8000

# Kill it or change port in docker-compose.yml
# Change: "8001:8000" instead of "8000:8000"
```

### Clear Everything and Start Fresh

```bash
# DANGER: This deletes all data!

# Stop and remove everything
docker-compose down -v

# Remove images (optional)
docker-compose down -v --rmi all

# Start fresh
docker-compose up -d
```

---

## Performance Tips

### Speed Up Rebuilds

```dockerfile
# Add .dockerignore
**/__pycache__
**/*.pyc
**/.git
**/node_modules
**/sites
*.log
```

### Use Named Volumes for Better Performance

Already configured in docker-compose.yml:
- `mariadb-data` - Database
- `sites-data` - Site files

### Mac-Specific Optimization

```yaml
# In docker-compose.yml, add to volumes:
volumes:
  - ./apps/nextgen_farmers:/home/frappe/frappe-bench/apps/nextgen_farmers:cached

# :cached = better performance on macOS
```

---

## Production Deployment

### Build Production Image

```bash
# Create Dockerfile.prod
FROM frappe/erpnext:v15.20.1

COPY --chown=frappe:frappe ./apps/nextgen_farmers /home/frappe/frappe-bench/apps/nextgen_farmers

RUN cd /home/frappe/frappe-bench && \
    bench --site all install-app nextgen_farmers

# Build
docker build -f Dockerfile.prod -t nextgen-farmers-hub:v1.0 .

# Push to registry
docker tag nextgen-farmers-hub:v1.0 registry.example.com/nextgen-farmers-hub:v1.0
docker push registry.example.com/nextgen-farmers-hub:v1.0
```

### Deploy to Production

Use Docker Swarm, Kubernetes, or managed services like:
- AWS ECS/Fargate
- Google Cloud Run
- DigitalOcean App Platform
- Render.com
- Railway.app

---

## Summary

### What You Have Now

✅ **Clean Mac** - No Python, Node, MariaDB pollution
✅ **Isolated Environment** - Everything in Docker
✅ **Hot Reload** - Edit on Mac, see changes instantly
✅ **Version Control** - Only your custom app code
✅ **Easy Testing** - Run tests in container
✅ **Team Friendly** - Anyone can run `docker-compose up`
✅ **Production Ready** - Same setup works on server

### Development Workflow

```bash
# 1. Start (once per session)
docker-compose up -d

# 2. Code on Mac
code apps/nextgen_farmers

# 3. Apply changes
docker exec -it nextgen-backend bench --site nextgenfarmers.local migrate

# 4. Test
docker exec -it nextgen-backend bench --site nextgenfarmers.local run-tests

# 5. Commit
git add . && git commit -m "feat: ..." && git push

# 6. Stop (end of day)
docker-compose down
```

### Next Steps

1. Copy docker-compose.yml to your project
2. Run `docker-compose up -d`
3. Wait for initialization
4. Access http://localhost:8000
5. Start coding!

---

**Ready to develop without installing anything on your Mac!** 🚀
