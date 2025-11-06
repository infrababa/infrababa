# Docker Compose Quick Start Guide

Get NextGen Farmers Hub up and running in minutes with Docker Compose!

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- 4GB+ RAM available
- 20GB+ disk space

## Quick Start (Local Development)

### 1. Clone Repository

```bash
git clone https://github.com/your-org/nextgen_farmers.git
cd nextgen_farmers
```

### 2. Configure Environment

```bash
# Copy example environment file
cp .env.example .env

# Edit configuration (use any text editor)
nano .env
```

**Minimum required changes:**
```bash
MYSQL_ROOT_PASSWORD=changeme123
MYSQL_PASSWORD=changeme123
ADMIN_PASSWORD=admin123
SITE_NAME=localhost
```

### 3. Start Services

```bash
# Pull images (first time only)
docker-compose pull

# Start all services
docker-compose up -d

# Watch logs
docker-compose logs -f
```

### 4. Wait for Installation

First-time setup takes 5-10 minutes. Monitor progress:

```bash
# Watch backend logs
docker-compose logs -f erpnext-backend

# Look for this message:
# "Site nextgenfarmershub.com created successfully"
```

### 5. Access Application

Once setup is complete:

- **URL**: http://localhost
- **Username**: Administrator
- **Password**: (the ADMIN_PASSWORD from .env)

## Common Commands

### View Status
```bash
docker-compose ps
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f erpnext-backend
```

### Stop Services
```bash
docker-compose stop
```

### Start Services
```bash
docker-compose start
```

### Restart Services
```bash
docker-compose restart
```

### Stop and Remove Everything
```bash
docker-compose down

# Remove volumes too (WARNING: deletes all data)
docker-compose down -v
```

### Execute Commands in Container
```bash
# Open shell in backend container
docker-compose exec erpnext-backend bash

# Run bench command
docker-compose exec erpnext-backend bench --site nextgenfarmershub.com migrate

# Clear cache
docker-compose exec erpnext-backend bench --site nextgenfarmershub.com clear-cache
```

## Production Deployment on AWS

See [AWS_DEPLOYMENT.md](./AWS_DEPLOYMENT.md) for complete AWS deployment guide.

### Quick AWS EC2 Deployment

```bash
# 1. SSH into your EC2 instance
ssh -i your-key.pem ubuntu@<ec2-ip>

# 2. Run bootstrap script
curl -O https://raw.githubusercontent.com/your-org/nextgen_farmers/main/docker/scripts/aws-bootstrap.sh
chmod +x aws-bootstrap.sh
./aws-bootstrap.sh

# 3. Log out and back in
exit
ssh -i your-key.pem ubuntu@<ec2-ip>

# 4. Clone and configure
cd ~
git clone https://github.com/your-org/nextgen_farmers.git
cd nextgen_farmers
cp .env.example .env
nano .env  # Update with your settings

# 5. Deploy
docker-compose up -d

# 6. Monitor
docker-compose logs -f
```

## Services Overview

| Service | Port | Description |
|---------|------|-------------|
| nginx | 80, 443 | Web server / reverse proxy |
| erpnext-backend | 8000 | Main application server |
| erpnext-socketio | 9000 | Real-time communication |
| mariadb | 3306 | Database (internal only) |
| redis-cache | 6379 | Cache server (internal only) |
| redis-queue | 6379 | Queue server (internal only) |
| erpnext-worker-* | - | Background workers |
| erpnext-scheduler | - | Scheduled tasks |

## Volume Management

### Backup Volumes

```bash
# Backup database
docker-compose exec mariadb mysqldump -u root -p${MYSQL_ROOT_PASSWORD} nextgen_db | gzip > backup.sql.gz

# Backup site files
docker-compose exec erpnext-backend tar czf - /home/frappe/frappe-bench/sites > sites_backup.tar.gz
```

### Restore Volumes

```bash
# Restore database
gunzip < backup.sql.gz | docker-compose exec -T mariadb mysql -u root -p${MYSQL_ROOT_PASSWORD} nextgen_db

# Restore sites
docker-compose exec -T erpnext-backend tar xzf - -C /home/frappe/frappe-bench < sites_backup.tar.gz
```

## Environment Variables Reference

### Required Variables

```bash
# Database
MYSQL_ROOT_PASSWORD=<strong_password>
MYSQL_PASSWORD=<strong_password>
MYSQL_DATABASE=nextgen_db
MYSQL_USER=nextgen_user

# Application
SITE_NAME=nextgenfarmershub.com
ADMIN_PASSWORD=<admin_password>
FRAPPE_VERSION=version-14
ERPNEXT_VERSION=version-14
```

### Optional Variables

```bash
# Auto Migration
AUTO_MIGRATE=1

# Monitoring
GRAFANA_PASSWORD=admin

# Email (configure after installation)
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USE_TLS=1
MAIL_LOGIN=your-email@domain.com
MAIL_PASSWORD=your-password
```

## Monitoring

### Enable Monitoring Stack (Prometheus + Grafana)

```bash
# Start with monitoring profile
docker-compose --profile monitoring up -d

# Access Grafana
http://localhost:3000
# Username: admin
# Password: (GRAFANA_PASSWORD from .env)
```

### Health Check

```bash
# Run health check script
./docker/scripts/health-check.sh
```

## Troubleshooting

### Services won't start

```bash
# Check logs
docker-compose logs

# Check if ports are available
sudo netstat -tulpn | grep -E ':(80|443|3306|6379|8000|9000)'

# Restart services
docker-compose restart
```

### Database connection errors

```bash
# Check database status
docker-compose ps mariadb

# Check database logs
docker-compose logs mariadb

# Restart database
docker-compose restart mariadb
```

### Out of memory

```bash
# Check memory usage
docker stats

# Restart specific service
docker-compose restart erpnext-backend

# Increase Docker memory limit (Docker Desktop)
# Settings > Resources > Memory > Increase limit
```

### Permission errors

```bash
# Fix permissions
docker-compose exec erpnext-backend chown -R frappe:frappe /home/frappe/frappe-bench
```

### Reset Everything

```bash
# Stop and remove all containers and volumes
docker-compose down -v

# Remove all images (optional)
docker-compose down --rmi all

# Start fresh
docker-compose up -d
```

## SSL Certificate (Let's Encrypt)

### For Production Domain

```bash
# Update nginx config with your domain
nano docker/nginx/conf.d/nextgen.conf
# Change server_name to your domain

# Restart nginx
docker-compose restart nginx

# Get certificate
docker-compose run --rm certbot certonly \
  --webroot \
  --webroot-path=/var/www/certbot \
  -d yourdomain.com \
  -d www.yourdomain.com \
  --email admin@yourdomain.com \
  --agree-tos

# Update nginx config to enable HTTPS
nano docker/nginx/conf.d/nextgen.conf
# Uncomment HTTPS section

# Restart nginx
docker-compose restart nginx
```

### Auto-renewal

Certbot container automatically renews certificates every 12 hours.

## Performance Tuning

### For Production

1. **Increase Worker Processes**
```yaml
# docker-compose.yml
# Add more worker containers for heavy load
```

2. **Optimize Database**
```bash
# Adjust settings in docker/mariadb/conf.d/nextgen.cnf
# Based on your server RAM
```

3. **Enable Redis Caching**
Already enabled by default in docker-compose.yml

## Backup and Restore

### Automated S3 Backups (AWS)

```bash
# Configure AWS credentials
aws configure

# Setup cron for daily backups
crontab -e
# Add: 0 2 * * * /path/to/docker/scripts/backup-to-s3.sh
```

### Manual Backup

```bash
# Backup everything
./docker/scripts/backup-to-s3.sh
```

### Restore from S3

```bash
# Restore from backup
./docker/scripts/restore-from-s3.sh
```

## Updating

### Update Application

```bash
# Pull latest changes
git pull

# Rebuild containers
docker-compose build

# Restart services
docker-compose up -d

# Run migrations
docker-compose exec erpnext-backend bench --site nextgenfarmershub.com migrate

# Clear cache
docker-compose exec erpnext-backend bench --site nextgenfarmershub.com clear-cache
```

## Security Best Practices

1. **Change default passwords** in `.env`
2. **Use strong passwords** (20+ characters)
3. **Enable firewall** on host
4. **Keep Docker updated**
5. **Regular backups** to S3
6. **Monitor logs** for suspicious activity
7. **Use HTTPS** in production
8. **Restrict SSH** access by IP

## Support

- **Documentation**: See [README.md](./README.md), [INSTALLATION.md](./INSTALLATION.md)
- **AWS Deployment**: See [AWS_DEPLOYMENT.md](./AWS_DEPLOYMENT.md)
- **Issues**: https://github.com/your-org/nextgen_farmers/issues
- **Email**: support@nextgenfarmershub.com

## Useful Links

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Frappe Documentation](https://frappeframework.com/docs)
- [ERPNext Documentation](https://docs.erpnext.com/)

---

**Happy Farming! 🌾**
