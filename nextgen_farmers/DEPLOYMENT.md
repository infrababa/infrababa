# NextGen Farmers Hub - Deployment Guide

This guide covers deploying the NextGen Farmers Hub ERPNext customization to production.

## Deployment Options

### Option 1: Cloud Hosting (Recommended)

#### A. Frappe Cloud (Easiest)
1. Sign up at https://frappecloud.com
2. Create a new site
3. Install ERPNext
4. Upload nextgen_farmers app
5. Install the app on your site

#### B. AWS/DigitalOcean/Linode

**Server Specifications (Minimum):**
- 2 vCPUs
- 4GB RAM
- 50GB SSD Storage
- Ubuntu 22.04 LTS

**Server Specifications (Recommended for 500+ members):**
- 4 vCPUs
- 8GB RAM
- 100GB SSD Storage
- Ubuntu 22.04 LTS

### Option 2: On-Premise Hosting

For on-premise deployment at NextGen Farmers Hub office in Accra.

## Production Deployment Steps

### 1. Server Setup

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y git python3-dev python3-pip redis-server \
    mariadb-server nginx supervisor curl

# Install Node.js
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs

# Install yarn
sudo npm install -g yarn

# Install wkhtmltopdf (for PDF generation)
sudo apt install -y wkhtmltopdf
```

### 2. Install Frappe Bench

```bash
# Install frappe-bench
sudo pip3 install frappe-bench

# Create bench directory
cd /home/frappe
bench init frappe-bench --frappe-branch version-14

# Navigate to bench directory
cd frappe-bench

# Create a new site
bench new-site nextgenfarmershub.com \
    --db-name nextgen_db \
    --admin-password <strong-password>

# Use the site
bench use nextgenfarmershub.com
```

### 3. Install ERPNext and Agriculture

```bash
# Get ERPNext
bench get-app erpnext --branch version-14
bench --site nextgenfarmershub.com install-app erpnext

# Get Agriculture app (optional)
bench get-app agriculture
bench --site nextgenfarmershub.com install-app agriculture
```

### 4. Install NextGen Farmers App

```bash
# Get the app from GitHub
bench get-app https://github.com/nextgenfarmershub/nextgen_farmers.git

# Install on site
bench --site nextgenfarmershub.com install-app nextgen_farmers

# Run migrations
bench --site nextgenfarmershub.com migrate

# Build assets
bench build --app nextgen_farmers
```

### 5. Configure Production Settings

```bash
# Enable production mode
bench --site nextgenfarmershub.com enable-scheduler
bench --site nextgenfarmershub.com set-config maintenance_mode 0
bench --site nextgenfarmershub.com set-config developer_mode 0

# Setup production config
bench setup production frappe
```

### 6. Configure Nginx and SSL

```bash
# Setup nginx
sudo bench setup nginx

# Install certbot for SSL
sudo apt install -y certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d nextgenfarmershub.com -d www.nextgenfarmershub.com

# Auto-renewal
sudo certbot renew --dry-run
```

### 7. Setup Supervisor

```bash
# Generate supervisor config
bench setup supervisor

# Reload supervisor
sudo supervisorctl reread
sudo supervisorctl update

# Start all processes
sudo supervisorctl start all
```

### 8. Configure Database

```bash
# Optimize MariaDB for production
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
```

Add these settings:
```ini
[mysqld]
innodb_buffer_pool_size = 2G
innodb_log_file_size = 512M
innodb_flush_method = O_DIRECT
max_connections = 200
query_cache_size = 256M
query_cache_type = 1
```

Restart MariaDB:
```bash
sudo systemctl restart mariadb
```

### 9. Configure Redis

```bash
# Edit Redis config
sudo nano /etc/redis/redis.conf
```

Update:
```
maxmemory 512mb
maxmemory-policy allkeys-lru
```

Restart Redis:
```bash
sudo systemctl restart redis
```

### 10. Setup Automated Backups

```bash
# Create backup script
nano /home/frappe/backup.sh
```

Add:
```bash
#!/bin/bash
cd /home/frappe/frappe-bench
bench --site nextgenfarmershub.com backup \
    --with-files \
    --backup-path /home/frappe/backups

# Keep only last 7 days of backups
find /home/frappe/backups -name "*.sql.gz" -mtime +7 -delete
find /home/frappe/backups -name "*-files.tar" -mtime +7 -delete
```

Make executable:
```bash
chmod +x /home/frappe/backup.sh
```

Add to crontab:
```bash
crontab -e
```

Add this line for daily backup at 2 AM:
```
0 2 * * * /home/frappe/backup.sh
```

### 11. Configure Email

```bash
# Set default email account
bench --site nextgenfarmershub.com set-config \
    mail_server "smtp.gmail.com"
bench --site nextgenfarmershub.com set-config \
    mail_port 587
bench --site nextgenfarmershub.com set-config \
    mail_use_tls 1
bench --site nextgenfarmershub.com set-config \
    mail_login "noreply@nextgenfarmershub.com"
bench --site nextgenfarmershub.com set-config \
    mail_password "<email-password>"
```

### 12. Setup Mobile Money Integration

For Ghana Mobile Money (MTN, Vodafone, AirtelTigo):

```bash
# Install payment gateway app
bench get-app https://github.com/frappe/payments.git
bench --site nextgenfarmershub.com install-app payments
```

Configure payment gateways in ERPNext:
- MTN Mobile Money
- Vodafone Cash
- AirtelTigo Money

### 13. Configure SMS Notifications

For member notifications via SMS:

```bash
# Install SMS app
bench get-app https://github.com/frappe/sms.git
bench --site nextgenfarmershub.com install-app sms
```

Configure SMS provider (e.g., Hubtel for Ghana):
- API Key
- Sender ID
- SMS templates

## Security Hardening

### 1. Firewall Configuration

```bash
# Install UFW
sudo apt install -y ufw

# Configure firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
```

### 2. Fail2Ban

```bash
# Install fail2ban
sudo apt install -y fail2ban

# Configure jail
sudo nano /etc/fail2ban/jail.local
```

Add:
```ini
[nginx-limit-req]
enabled = true
filter = nginx-limit-req
action = iptables-multiport[name=ReqLimit, port="http,https", protocol=tcp]
logpath = /var/log/nginx/error.log
```

### 3. Secure MariaDB

```bash
sudo mysql_secure_installation
```

### 4. Setup Monitoring

Install monitoring tools:

```bash
# Install htop
sudo apt install -y htop

# Install Glances
sudo pip3 install glances

# Install Prometheus Node Exporter (optional)
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar xvfz node_exporter-1.3.1.linux-amd64.tar.gz
sudo mv node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter-1.3.1.linux-amd64*

# Create systemd service
sudo nano /etc/systemd/system/node_exporter.service
```

### 5. Log Rotation

```bash
sudo nano /etc/logrotate.d/frappe-bench
```

Add:
```
/home/frappe/frappe-bench/logs/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    missingok
}
```

## Performance Optimization

### 1. Enable Redis Cache

```bash
bench --site nextgenfarmershub.com set-config redis_cache "redis://localhost:6379"
bench --site nextgenfarmershub.com set-config redis_queue "redis://localhost:6379"
```

### 2. Enable Nginx Caching

Edit nginx config to add caching for static assets.

### 3. Optimize Database Queries

Run periodic optimization:
```bash
bench --site nextgenfarmershub.com mariadb
OPTIMIZE TABLE `tabCooperative Member`;
OPTIMIZE TABLE `tabMember Contribution`;
OPTIMIZE TABLE `tabEquipment Rental`;
```

## Monitoring and Maintenance

### 1. Health Check Endpoints

Monitor these URLs:
- https://nextgenfarmershub.com/api/method/ping
- https://nextgenfarmershub.com/api/method/version

### 2. Log Monitoring

```bash
# View error logs
tail -f ~/frappe-bench/logs/nextgenfarmershub.com.error.log

# View access logs
tail -f ~/frappe-bench/logs/nextgenfarmershub.com.access.log

# View worker logs
tail -f ~/frappe-bench/logs/worker.error.log
```

### 3. Database Maintenance

Weekly maintenance tasks:
```bash
# Optimize database
bench --site nextgenfarmershub.com mariadb
ANALYZE TABLE `tabCooperative Member`;
ANALYZE TABLE `tabEquipment Rental`;

# Check database size
bench --site nextgenfarmershub.com mariadb -e \
    "SELECT table_schema, SUM(data_length + index_length) / 1024 / 1024 AS 'Size (MB)' \
    FROM information_schema.tables GROUP BY table_schema;"
```

## Scaling

### Horizontal Scaling

For handling more than 1000+ concurrent users:

1. **Separate Database Server**
   - Move MariaDB to dedicated server
   - Update site_config.json with new DB host

2. **Redis Cluster**
   - Setup Redis Sentinel for high availability
   - Configure multiple Redis instances

3. **Load Balancer**
   - Setup Nginx or HAProxy load balancer
   - Deploy multiple app servers

4. **CDN for Static Assets**
   - Use CloudFlare or AWS CloudFront
   - Serve static assets from CDN

## Disaster Recovery

### Backup Strategy

1. **Database Backups**: Daily at 2 AM
2. **File Backups**: Daily at 3 AM
3. **Off-site Backups**: Weekly to AWS S3 or Google Cloud Storage

### Restore Procedure

```bash
# Stop all processes
sudo supervisorctl stop all

# Restore database
bench --site nextgenfarmershub.com restore \
    /path/to/backup/nextgenfarmershub.com-database.sql.gz

# Restore files
bench --site nextgenfarmershub.com restore \
    /path/to/backup/nextgenfarmershub.com-files.tar

# Start processes
sudo supervisorctl start all
```

## Mobile App Deployment

For the mobile app (future phase):

1. **Android App**: Deploy to Google Play Store
2. **iOS App**: Deploy to Apple App Store
3. **Configure API endpoints** to production URL

## Support Contacts

**Technical Support:**
- Email: tech@nextgenfarmershub.com
- Phone: +233 XX XXX XXXX

**Infrastructure Issues:**
- DevOps Team: devops@nextgenfarmershub.com

---

**Deployment Checklist:**
- [ ] Server provisioned and configured
- [ ] Frappe Bench installed
- [ ] ERPNext and nextgen_farmers installed
- [ ] Production mode enabled
- [ ] SSL certificate configured
- [ ] Backups configured and tested
- [ ] Monitoring setup
- [ ] Email configured and tested
- [ ] SMS gateway configured (if applicable)
- [ ] Payment gateways configured
- [ ] Security hardening completed
- [ ] Load testing performed
- [ ] Disaster recovery tested
- [ ] Documentation updated
- [ ] Team training completed
