# ⚡ Quick Start - 5 Minutes

Get NextGen Farmers Hub running on your machine in 5 minutes!

## Prerequisites

✅ Docker installed
✅ Docker Compose installed
✅ 4GB RAM available
✅ 10GB disk space

**Don't have Docker?** See [LOCAL_TESTING_GUIDE.md](./LOCAL_TESTING_GUIDE.md#prerequisites-check)

## Step 1: Clone & Setup (1 minute)

```bash
# Clone repository
git clone https://github.com/infrababa/infrababa.git
cd infrababa/nextgen_farmers

# Configure environment
cp .env.example .env
nano .env  # Change passwords, set SITE_NAME=localhost
```

**Quick .env setup:**
```bash
MYSQL_ROOT_PASSWORD=YourPassword123!
MYSQL_PASSWORD=YourPassword123!
ADMIN_PASSWORD=Admin123!
SITE_NAME=localhost
```

## Step 2: Deploy (1 minute)

```bash
# Pull images (first time: 5-10 min, subsequent: instant)
docker-compose pull

# Start all services
docker-compose up -d
```

## Step 3: Wait for Setup (5-10 minutes)

```bash
# Watch installation progress
docker-compose logs -f erpnext-backend

# Look for: "Site localhost created successfully" ✅
```

**Press Ctrl+C when done** (services keep running)

## Step 4: Access Application

🌐 **Open browser**: http://localhost

🔐 **Login**:
- Username: `Administrator`
- Password: `Admin123!` (or your ADMIN_PASSWORD)

## Step 5: Complete Setup Wizard

1. Language: **English**
2. Country: **Ghana**
3. Company: **NextGen Farmers Hub**
4. Currency: **GHS**
5. Click **Complete Setup**

## ✅ You're Done!

Navigate to **NextGen Farmers Hub** workspace (grid menu, top right)

---

## Essential Commands

```bash
# Check status
docker-compose ps

# View logs
docker-compose logs -f

# Stop services (keeps data)
docker-compose stop

# Start services
docker-compose start

# Restart everything
docker-compose restart

# Clear cache
docker-compose exec erpnext-backend bench --site localhost clear-cache

# Complete cleanup (⚠️ deletes data)
docker-compose down -v
```

---

## Using Makefile (Even Easier!)

```bash
make up           # Start
make logs         # View logs
make restart      # Restart
make stop         # Stop
make health       # Health check
make help         # All commands
```

---

## Quick Tests

### Test 1: Create Member
1. Go to **Cooperative Member** → **New**
2. Fill: Member ID, Name, Mobile, Email
3. **Save**

### Test 2: Create Farm
1. Go to **Farm Location** → **New**
2. Fill: Farm Name, Total Area
3. **Save**

---

## Troubleshooting

**Services won't start?**
```bash
docker-compose logs
```

**Port conflict?**
```bash
sudo netstat -tulpn | grep -E ':(80|3306)'
```

**Database issues?**
```bash
docker-compose restart mariadb
docker-compose restart erpnext-backend
```

**Start fresh?**
```bash
docker-compose down -v
docker-compose up -d
```

---

## Need More Help?

📖 **Full Guide**: [LOCAL_TESTING_GUIDE.md](./LOCAL_TESTING_GUIDE.md)
🚀 **AWS Deploy**: [AWS_DEPLOYMENT.md](./AWS_DEPLOYMENT.md)
🐳 **Docker Guide**: [DOCKER_QUICKSTART.md](./DOCKER_QUICKSTART.md)
📚 **Features**: [README.md](./README.md)

---

**🎉 Happy Farming!** 🌾
