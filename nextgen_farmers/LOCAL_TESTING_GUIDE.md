# Local Testing Guide - Linux/Mac

Complete guide to test NextGen Farmers Hub ERPNext on your local Linux or Mac machine.

## Prerequisites Check

### 1. Check if Docker is Installed

```bash
# Check Docker version
docker --version

# Should show: Docker version 20.10+ or higher
```

**If Docker is NOT installed:**

#### On Linux (Ubuntu/Debian):
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add your user to docker group (avoid using sudo)
sudo usermod -aG docker $USER

# Log out and back in for group changes to take effect
# Or run: newgrp docker
```

#### On Mac:
```bash
# Install Docker Desktop for Mac
# Download from: https://www.docker.com/products/docker-desktop

# Or using Homebrew:
brew install --cask docker

# Start Docker Desktop from Applications
```

### 2. Check Docker Compose

```bash
# Check Docker Compose version
docker-compose --version

# Should show: Docker Compose version 2.0+ or higher
```

**If Docker Compose is NOT installed:**

#### On Linux:
```bash
# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify
docker-compose --version
```

#### On Mac:
Docker Compose is included with Docker Desktop - no separate installation needed.

### 3. Check System Resources

```bash
# Check available RAM
free -h  # Linux
vm_stat  # Mac

# Check available disk space
df -h

# Minimum requirements:
# - 4GB RAM available
# - 10GB disk space available
# - Docker has access to these resources
```

**For Docker Desktop (Mac/Windows):**
- Open Docker Desktop → Settings → Resources
- Allocate at least:
  - **Memory**: 4GB (8GB recommended)
  - **CPUs**: 2 cores minimum
  - **Disk**: 20GB

## Quick Start (5 Minutes)

### Step 1: Clone the Repository

```bash
# Navigate to your projects directory
cd ~/projects  # or wherever you keep your code

# Clone the repository
git clone https://github.com/infrababa/infrababa.git
cd infrababa/nextgen_farmers

# Verify you're in the right directory
ls -la
# You should see: docker-compose.yml, .env.example, etc.
```

### Step 2: Configure Environment

```bash
# Copy the example environment file
cp .env.example .env

# Edit the environment file
nano .env  # or use vim, code, etc.
```

**Update these values in `.env`:**

```bash
# REQUIRED: Change these passwords
MYSQL_ROOT_PASSWORD=YourStrongPassword123!
MYSQL_PASSWORD=YourStrongPassword123!
ADMIN_PASSWORD=Admin123!

# REQUIRED: Set site name for local testing
SITE_NAME=localhost

# Optional: Leave these as default for local testing
MYSQL_DATABASE=nextgen_db
MYSQL_USER=nextgen_user
AUTO_MIGRATE=1
```

**Save and exit** (Ctrl+X, then Y, then Enter for nano)

### Step 3: Start the Services

```bash
# Pull the required Docker images (first time only - may take 5-10 minutes)
docker-compose pull

# Start all services in background mode
docker-compose up -d

# You should see output like:
# Creating nextgen_mariadb ... done
# Creating nextgen_redis_cache ... done
# Creating nextgen_backend ... done
# etc.
```

### Step 4: Monitor the Installation

The first-time setup takes **5-10 minutes** as it creates the database, installs apps, and initializes the site.

```bash
# Watch the logs (this will stream live logs)
docker-compose logs -f erpnext-backend

# Look for these key messages:
# "Site localhost created successfully" ✅
# "Installing erpnext..." ✅
# "Installing nextgen_farmers..." ✅
# "Scheduler is enabled" ✅
```

**Press Ctrl+C to stop watching logs** (services keep running in background)

### Step 5: Verify All Services Are Running

```bash
# Check service status
docker-compose ps

# All services should show "Up" status:
# nextgen_backend        Up
# nextgen_mariadb        Up (healthy)
# nextgen_redis_cache    Up (healthy)
# nextgen_redis_queue    Up (healthy)
# nextgen_nginx          Up
# nextgen_scheduler      Up
# nextgen_worker_default Up
# nextgen_worker_short   Up
# nextgen_worker_long    Up
# nextgen_socketio       Up
```

### Step 6: Access the Application

Open your browser and go to:

```
http://localhost
```

**Login Credentials:**
- **Username**: `Administrator`
- **Password**: (the `ADMIN_PASSWORD` you set in `.env`, default: `Admin123!`)

## Post-Installation Setup

### 1. Complete the Setup Wizard

After first login, you'll see the ERPNext setup wizard:

1. **Select Your Language**: English
2. **Select Your Country**: Ghana
3. **Setup Your Organization**:
   - Company Name: `NextGen Farmers Hub`
   - Company Abbreviation: `NGF`
4. **Select Your Domain**: Agriculture
5. **Select Currency**: GHS (Ghana Cedi)
6. **Setup Tax**: (Skip for now or add Ghana VAT)
7. **Add Users**: (Skip for now, add later)

Click **Complete Setup**

### 2. Verify NextGen Farmers App Installation

```bash
# Check if the app is installed
docker-compose exec erpnext-backend bench --site localhost list-apps

# You should see:
# frappe
# erpnext
# agriculture (optional)
# nextgen_farmers ✅
```

### 3. Access NextGen Farmers Hub Workspace

1. Click the **Grid Menu** (9 dots) in top right
2. Look for **"NextGen Farmers Hub"** workspace
3. Click to open

You should see modules:
- Cooperative Management
- Farm Operations
- Equipment Rental
- Marketplace
- Training Development
- Export Management

## Testing the Application

### Test 1: Create a Membership Tier

1. Go to: **NextGen Farmers Hub > Membership Tier**
2. Click **New**
3. Fill in:
   - Tier Name: `Youth Farmer`
   - Minimum Contribution: `100`
   - Registration Fee: `50`
   - Profit Share Percentage: `10`
4. Click **Save**

### Test 2: Create a Test Member

1. Go to: **NextGen Farmers Hub > Cooperative Member**
2. Click **New**
3. Fill in:
   - Member ID: `MEM-TEST-001`
   - First Name: `Kwame`
   - Last Name: `Mensah`
   - Mobile Number: `+233241234567`
   - Email: `kwame.test@example.com`
   - Membership Tier: `Youth Farmer`
   - Join Date: (Today's date)
   - Membership Status: `Active`
4. Click **Save**

### Test 3: Create a Farm Location

1. Go to: **NextGen Farmers Hub > Farm Location**
2. Click **New**
3. Fill in:
   - Farm Name: `Main Farm - Accra`
   - Farm Code: `FARM-001`
   - Total Land Area: `50`
   - Land Area Unit: `Hectares`
   - Region: `Greater Accra`
   - Farm Status: `Active`
4. Click **Save**

### Test 4: Test Equipment Rental

1. First, create an Asset:
   - Go to: **Assets > Asset**
   - Create a test tractor or equipment

2. Then create a rental:
   - Go to: **NextGen Farmers Hub > Equipment Rental**
   - Click **New**
   - Select member, equipment, dates
   - Click **Save** then **Submit**

## Common Commands

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f erpnext-backend
docker-compose logs -f mariadb
docker-compose logs -f nginx

# Last 50 lines
docker-compose logs --tail=50 erpnext-backend
```

### Restart Services

```bash
# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart erpnext-backend
```

### Stop Services

```bash
# Stop all services (data is preserved)
docker-compose stop

# Start again
docker-compose start
```

### Access Backend Shell

```bash
# Open shell in backend container
docker-compose exec erpnext-backend bash

# Now you can run bench commands:
bench --site localhost migrate
bench --site localhost clear-cache
bench --site localhost console

# Exit shell
exit
```

### Clear Cache

```bash
docker-compose exec erpnext-backend bench --site localhost clear-cache
```

### Run Migrations

```bash
docker-compose exec erpnext-backend bench --site localhost migrate
```

### Using Makefile (Shortcuts)

If you have `make` installed:

```bash
# Show all available commands
make help

# Common commands
make logs          # View logs
make restart       # Restart all services
make shell         # Open backend shell
make clear-cache   # Clear application cache
make migrate       # Run migrations
make health        # Run health check
```

## Troubleshooting

### Issue: Services won't start

```bash
# Check if ports are already in use
sudo netstat -tulpn | grep -E ':(80|443|3306|6379|8000|9000)'

# If ports are in use, stop conflicting services or change ports
# in docker-compose.yml
```

### Issue: "Cannot connect to database"

```bash
# Check if MariaDB is running and healthy
docker-compose ps mariadb

# View database logs
docker-compose logs mariadb

# Restart database
docker-compose restart mariadb

# Wait 30 seconds, then restart backend
docker-compose restart erpnext-backend
```

### Issue: "Site not found" or 404 errors

```bash
# Check if site was created
docker-compose exec erpnext-backend ls sites/

# Should show: localhost directory

# If not, check backend logs
docker-compose logs erpnext-backend | grep -i error
```

### Issue: Installation stuck or taking too long

```bash
# Check if processes are running
docker-compose exec erpnext-backend ps aux

# Check available memory
docker stats

# If stuck, restart the backend
docker-compose restart erpnext-backend
```

### Issue: "Permission denied" errors

```bash
# Fix permissions in container
docker-compose exec erpnext-backend chown -R frappe:frappe /home/frappe/frappe-bench

# Restart services
docker-compose restart
```

### Issue: Out of memory

**For Docker Desktop (Mac):**
1. Open Docker Desktop
2. Go to Settings → Resources
3. Increase Memory to 8GB
4. Click Apply & Restart

**For Linux:**
```bash
# Check memory usage
free -h
docker stats

# Stop some services if needed
docker-compose stop grafana prometheus
```

### Issue: Application is slow

```bash
# Check resource usage
docker stats

# Restart workers
docker-compose restart erpnext-worker-default erpnext-worker-short erpnext-worker-long

# Clear cache
docker-compose exec erpnext-backend bench --site localhost clear-cache
```

## Clean Start (Reset Everything)

**⚠️ WARNING: This will delete all data!**

```bash
# Stop and remove all containers and volumes
docker-compose down -v

# Remove all images (optional)
docker-compose down -v --rmi all

# Start fresh
docker-compose up -d
```

## Accessing Database Directly

```bash
# Access MariaDB shell
docker-compose exec mariadb mysql -u root -p

# Enter the MYSQL_ROOT_PASSWORD from your .env file

# View databases
SHOW DATABASES;

# Use the nextgen database
USE nextgen_db;

# View tables
SHOW TABLES;

# Exit
exit;
```

## Testing with Sample Data

### Import Test Members

Create a file `test_members.csv`:

```csv
member_id,first_name,last_name,email,mobile_number,membership_tier,join_date
MEM-001,Kwame,Asante,kwame@test.com,+233241111111,Youth Farmer,2025-01-01
MEM-002,Ama,Mensah,ama@test.com,+233241111112,Youth Farmer,2025-01-01
MEM-003,Kofi,Boateng,kofi@test.com,+233241111113,Active Farmer,2025-01-01
```

Import in ERPNext:
1. Go to **Data Import Tool**
2. Select **Cooperative Member**
3. Upload CSV
4. Map fields
5. Import

## Performance Optimization for Local Testing

### 1. Reduce Workers (Save Resources)

Edit `docker-compose.yml` (for testing only):

```yaml
# Comment out some workers to save memory
# erpnext-worker-long:
#   ...

# erpnext-worker-short:
#   ...
```

Restart: `docker-compose up -d`

### 2. Disable Monitoring (Optional)

Monitoring services use extra resources. They're disabled by default in local mode.

## Development Mode

For development with live code changes:

```bash
# Create override file
cp docker-compose.override.yml.example docker-compose.override.yml

# Edit if needed
nano docker-compose.override.yml

# Restart
docker-compose up -d
```

This mounts your local code into the container for live development.

## Checking Installation Health

```bash
# Run health check script
./docker/scripts/health-check.sh

# Expected output:
# ✓ mariadb is running
# ✓ redis-cache is running
# ✓ erpnext-backend is running
# ✓ Application API is accessible
# ✓ Disk usage: X%
# ✓ Memory usage: X%
# All checks passed! ✅
```

## Stopping and Cleanup

### Stop but Keep Data
```bash
# Stop all services
docker-compose stop

# Start again later
docker-compose start
```

### Stop and Remove Containers (Keep Data)
```bash
# Down but preserve volumes
docker-compose down

# Start fresh (data preserved)
docker-compose up -d
```

### Complete Cleanup (Remove Everything)
```bash
# Remove containers, networks, and volumes
docker-compose down -v

# Remove images too
docker-compose down -v --rmi all

# Check disk space recovered
docker system df
```

## Next Steps After Testing

1. **Test all modules** thoroughly
2. **Try member registration workflow**
3. **Test equipment booking**
4. **Create sample contributions**
5. **Test profit distribution calculation**

Once comfortable with local testing:
- Deploy to AWS using [AWS_DEPLOYMENT.md](./AWS_DEPLOYMENT.md)
- Set up production database
- Configure backups
- Add SSL certificate

## Getting Help

### Check Logs First
```bash
# Always start by checking logs
docker-compose logs -f

# Look for ERROR or WARN messages
docker-compose logs | grep -i error
```

### Common Log Files
```bash
# Backend application logs
docker-compose logs erpnext-backend

# Database logs
docker-compose logs mariadb

# Nginx logs
docker-compose logs nginx

# Worker logs
docker-compose logs erpnext-worker-default
```

### Support Resources
- **Documentation**: Check README.md and other .md files
- **Frappe Forum**: https://discuss.erpnext.com/
- **Docker Docs**: https://docs.docker.com/
- **ERPNext Docs**: https://docs.erpnext.com/

## Useful Commands Cheat Sheet

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose stop

# View status
docker-compose ps

# View logs
docker-compose logs -f

# Restart
docker-compose restart

# Shell access
docker-compose exec erpnext-backend bash

# Clear cache
docker-compose exec erpnext-backend bench --site localhost clear-cache

# Run migrations
docker-compose exec erpnext-backend bench --site localhost migrate

# Complete cleanup
docker-compose down -v

# Health check
./docker/scripts/health-check.sh
```

---

**Happy Testing! 🚀**

Once everything works locally, you're ready to deploy to AWS!
