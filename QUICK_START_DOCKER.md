# Quick Start Guide (Docker)
## NextGen Farmers Hub ERPNext Development

**For**: Developers on macOS, Linux, or Windows
**Time**: 10 minutes to get running

---

## Prerequisites

1. **Docker Desktop** installed and running
   - Download: https://www.docker.com/products/docker-desktop
   - Verify: `docker --version`

2. **Git** installed
   - Verify: `git --version`

**That's it!** No Python, Node.js, MariaDB, or other dependencies needed.

---

## Step 1: Clone and Start (5 minutes)

```bash
# Clone the repository
git clone https://github.com/yourusername/nextgen-farmers-hub.git
cd nextgen-farmers-hub

# Start all services
docker-compose up -d

# Watch initialization (first time takes ~5 minutes)
docker-compose logs -f backend

# Wait until you see: "Frappe bench is running"
```

## Step 2: Access ERPNext (1 minute)

```bash
# Open browser
open http://localhost:8000

# Login
# Username: Administrator
# Password: admin
```

## Step 3: Create Custom App (2 minutes)

```bash
# Enter the backend container
docker exec -it nextgen-backend bash

# Inside container: Create your custom app
bench new-app nextgen_farmers

# Answer the prompts:
# - App Title: NextGen Farmers Hub
# - App Description: Cooperative management system
# - App Publisher: NextGen Farmers Hub
# - App Email: admin@nextgenfarmershub.com
# - App License: MIT

# Install the app
bench --site nextgenfarmers.local install-app nextgen_farmers

# Exit container
exit
```

## Step 4: Start Developing (2 minutes)

```bash
# The app code is now in: apps/nextgen_farmers/
# Edit on your Mac with any editor:

code apps/nextgen_farmers    # VS Code
# or
open apps/nextgen_farmers    # Finder

# Your changes are instantly reflected in the container!
```

---

## Common Commands

### Start/Stop

```bash
# Start everything
docker-compose up -d

# Stop everything
docker-compose down

# Restart backend only
docker-compose restart backend

# View logs
docker-compose logs -f backend
```

### Development

```bash
# Apply database changes
docker exec -it nextgen-backend bench --site nextgenfarmers.local migrate

# Clear cache
docker exec -it nextgen-backend bench --site nextgenfarmers.local clear-cache

# Rebuild assets
docker exec -it nextgen-backend bench build --app nextgen_farmers

# Run tests
docker exec -it nextgen-backend bench --site nextgenfarmers.local run-tests --app nextgen_farmers

# Open Python console
docker exec -it nextgen-backend bench --site nextgenfarmers.local console
```

### Database

```bash
# Access MariaDB
docker exec -it nextgen-mariadb mysql -u root -prootpassword nextgen_db

# Backup database
docker exec nextgen-backend bench --site nextgenfarmers.local backup

# Restore from backup
docker exec nextgen-backend bench --site nextgenfarmers.local restore /path/to/backup.sql
```

---

## Troubleshooting

### Containers won't start?

```bash
# Check Docker is running
docker ps

# Check logs
docker-compose logs

# Restart everything
docker-compose restart
```

### Port 8000 already in use?

```bash
# Find what's using it
lsof -i :8000

# Kill it or change port in docker-compose.yml
# Change: "8001:8000" instead of "8000:8000"
```

### Site not loading?

```bash
# Check if site exists
docker exec -it nextgen-backend ls sites/

# Rebuild site
docker exec -it nextgen-backend bench --site nextgenfarmers.local rebuild
```

### Start completely fresh?

```bash
# WARNING: Deletes all data!
docker-compose down -v
docker-compose up -d
```

---

## Next Steps

1. ✅ Read: [PRODUCT_REQUIREMENTS_DOCUMENT.md](./PRODUCT_REQUIREMENTS_DOCUMENT.md)
2. ✅ Read: [CLI_AGENT_IMPLEMENTATION_GUIDE.md](./CLI_AGENT_IMPLEMENTATION_GUIDE.md)
3. ✅ Read: [DOCKER_DEVELOPMENT_SETUP.md](./DOCKER_DEVELOPMENT_SETUP.md)
4. 🚀 Start implementing from TASK-001

---

## For Claude CLI Agent

Give Claude CLI these instructions:

```
You are implementing NextGen Farmers Hub using Docker.

Environment:
- All services run in Docker containers
- Your custom app code is in: apps/nextgen_farmers/
- Edit files on the Mac (host machine)
- Execute bench commands in containers using: docker exec

Setup:
1. Project already has docker-compose.yml
2. Run: docker-compose up -d
3. Wait for initialization
4. Create app: docker exec -it nextgen-backend bench new-app nextgen_farmers
5. Start implementing tasks

For each task:
- Edit code files on Mac: apps/nextgen_farmers/...
- Apply changes: docker exec -it nextgen-backend bench --site nextgenfarmers.local migrate
- Test: docker exec -it nextgen-backend bench --site nextgenfarmers.local run-tests
- Commit: git add . && git commit -m "..." && git push

Read the guides and start with TASK-001.
```

---

**You're ready!** Everything runs in Docker - your Mac stays clean! 🎉
