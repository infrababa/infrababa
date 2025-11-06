# NextGen Farmers Hub - AWS Deployment Guide

Complete guide for deploying NextGen Farmers Hub ERPNext system on AWS using Docker Compose.

## Table of Contents

1. [AWS Architecture Overview](#aws-architecture-overview)
2. [Prerequisites](#prerequisites)
3. [Deployment Options](#deployment-options)
4. [Option 1: EC2 with Docker Compose (Recommended)](#option-1-ec2-with-docker-compose)
5. [Option 2: ECS with Fargate](#option-2-ecs-with-fargate)
6. [Option 3: Lightsail Containers](#option-3-lightsail-containers)
7. [Database Options](#database-options)
8. [Storage and Backups](#storage-and-backups)
9. [SSL Certificate Setup](#ssl-certificate-setup)
10. [Monitoring and Logging](#monitoring-and-logging)
11. [Cost Optimization](#cost-optimization)
12. [Troubleshooting](#troubleshooting)

## AWS Architecture Overview

### Recommended Production Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         AWS Cloud                            │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              Route 53 (DNS)                            │ │
│  └────────────────────┬───────────────────────────────────┘ │
│                       │                                      │
│  ┌────────────────────▼───────────────────────────────────┐ │
│  │      CloudFront CDN (Optional)                         │ │
│  └────────────────────┬───────────────────────────────────┘ │
│                       │                                      │
│  ┌────────────────────▼───────────────────────────────────┐ │
│  │      Application Load Balancer                         │ │
│  └────────────────────┬───────────────────────────────────┘ │
│                       │                                      │
│  ┌────────────────────▼───────────────────────────────────┐ │
│  │              EC2 Instance                              │ │
│  │         (Docker Compose Stack)                         │ │
│  │  ┌──────────────────────────────────────────────────┐  │ │
│  │  │  Nginx │ ERPNext │ Workers │ Scheduler │ SocketIO│  │ │
│  │  └──────────────────────────────────────────────────┘  │ │
│  └────────────────────┬───────────────────────────────────┘ │
│                       │                                      │
│  ┌────────────────────▼───────────────────────────────────┐ │
│  │         RDS MariaDB (Optional)                         │ │
│  │         ElastiCache Redis (Optional)                   │ │
│  └────────────────────────────────────────────────────────┘ │
│                       │                                      │
│  ┌────────────────────▼───────────────────────────────────┐ │
│  │         S3 (Backups & Static Assets)                   │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Prerequisites

### AWS Account Requirements

1. AWS Account with appropriate permissions
2. IAM user with following permissions:
   - EC2 (full access)
   - VPC (full access)
   - S3 (full access)
   - RDS (optional - if using managed database)
   - ElastiCache (optional)
   - Route 53 (for DNS)
   - CloudWatch (for monitoring)

### Local Requirements

1. AWS CLI installed and configured
2. Docker and Docker Compose installed locally (for testing)
3. SSH key pair for EC2 access

### Domain Setup

1. Domain name registered (e.g., nextgenfarmershub.com)
2. Domain pointed to Route 53 or external DNS

## Deployment Options

## Option 1: EC2 with Docker Compose (Recommended)

### Best for:
- Full control over infrastructure
- Cost-effective for small to medium deployments
- Easy to manage and troubleshoot

### Instance Recommendations

#### Development/Testing
- **Instance Type**: t3.medium
- **vCPUs**: 2
- **Memory**: 4 GB
- **Storage**: 30 GB GP3
- **Cost**: ~$30/month

#### Production (Small - up to 100 users)
- **Instance Type**: t3.large
- **vCPUs**: 2
- **Memory**: 8 GB
- **Storage**: 50 GB GP3
- **Cost**: ~$60/month

#### Production (Medium - 100-500 users)
- **Instance Type**: t3.xlarge
- **vCPUs**: 4
- **Memory**: 16 GB
- **Storage**: 100 GB GP3
- **Cost**: ~$120/month

#### Production (Large - 500+ users)
- **Instance Type**: t3.2xlarge or m5.2xlarge
- **vCPUs**: 8
- **Memory**: 32 GB
- **Storage**: 200 GB GP3
- **Cost**: ~$240-300/month

### Step-by-Step Deployment

#### 1. Launch EC2 Instance

**Using AWS Console:**

1. Navigate to EC2 Dashboard
2. Click "Launch Instance"
3. Configure:
   - **Name**: nextgen-farmers-erp
   - **AMI**: Ubuntu Server 22.04 LTS
   - **Instance Type**: t3.large (or as per requirements)
   - **Key Pair**: Create or select existing
   - **Network Settings**:
     - VPC: Default or custom
     - Auto-assign public IP: Enable
     - Security Group: Create new (see below)
   - **Storage**: 50 GB GP3
   - **Advanced Details**:
     - User Data: (optional - see bootstrap script below)

4. Click "Launch Instance"

**Security Group Configuration:**

| Type            | Protocol | Port Range | Source          | Description              |
|-----------------|----------|------------|-----------------|--------------------------|
| SSH             | TCP      | 22         | Your IP         | SSH access               |
| HTTP            | TCP      | 80         | 0.0.0.0/0       | Web traffic              |
| HTTPS           | TCP      | 443        | 0.0.0.0/0       | Secure web traffic       |
| Custom TCP      | TCP      | 9000       | Security Group  | SocketIO (internal only) |

**Using AWS CLI:**

```bash
# Create security group
aws ec2 create-security-group \
  --group-name nextgen-farmers-sg \
  --description "NextGen Farmers Hub Security Group" \
  --vpc-id vpc-xxxxxx

# Add inbound rules
aws ec2 authorize-security-group-ingress \
  --group-id sg-xxxxxx \
  --ip-permissions \
    IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges='[{CidrIp=YOUR_IP/32}]' \
    IpProtocol=tcp,FromPort=80,ToPort=80,IpRanges='[{CidrIp=0.0.0.0/0}]' \
    IpProtocol=tcp,FromPort=443,ToPort=443,IpRanges='[{CidrIp=0.0.0.0/0}]'

# Launch instance
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --instance-type t3.large \
  --key-name your-key-pair \
  --security-group-ids sg-xxxxxx \
  --block-device-mappings 'DeviceName=/dev/sda1,Ebs={VolumeSize=50,VolumeType=gp3}' \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=nextgen-farmers-erp}]'
```

#### 2. Connect to EC2 Instance

```bash
# Get instance public IP from AWS console
ssh -i your-key.pem ubuntu@<instance-public-ip>
```

#### 3. Install Docker and Docker Compose

Use the provided bootstrap script:

```bash
# Download and run bootstrap script
curl -O https://raw.githubusercontent.com/your-repo/nextgen_farmers/main/docker/scripts/aws-bootstrap.sh
chmod +x aws-bootstrap.sh
sudo ./aws-bootstrap.sh
```

Or manually:

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version

# Log out and back in for group changes to take effect
exit
```

#### 4. Deploy Application

```bash
# SSH back into instance
ssh -i your-key.pem ubuntu@<instance-public-ip>

# Create application directory
mkdir -p ~/nextgen_farmers
cd ~/nextgen_farmers

# Clone repository
git clone https://github.com/your-org/nextgen_farmers.git .

# Copy and configure environment file
cp .env.example .env
nano .env

# Update the following in .env:
# - MYSQL_ROOT_PASSWORD
# - MYSQL_PASSWORD
# - ADMIN_PASSWORD
# - SITE_NAME (your domain)
# - LETSENCRYPT_EMAIL
```

**Important .env configurations:**

```bash
# Database
MYSQL_ROOT_PASSWORD=YourStrongRootPassword123!
MYSQL_DATABASE=nextgen_db
MYSQL_USER=nextgen_user
MYSQL_PASSWORD=YourStrongPassword123!

# Site
SITE_NAME=nextgenfarmershub.com
ADMIN_PASSWORD=YourAdminPassword123!

# Email (configure later)
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_LOGIN=noreply@nextgenfarmershub.com
MAIL_PASSWORD=your_app_specific_password

# Let's Encrypt
LETSENCRYPT_EMAIL=admin@nextgenfarmershub.com
```

#### 5. Start Services

```bash
# Pull images
docker-compose pull

# Start services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

#### 6. Verify Installation

```bash
# Check if all services are running
docker-compose ps

# Expected output:
# nextgen_backend        running
# nextgen_mariadb        running
# nextgen_redis_cache    running
# nextgen_redis_queue    running
# nextgen_nginx          running
# nextgen_scheduler      running
# nextgen_worker_*       running
# nextgen_socketio       running

# Check application logs
docker-compose logs erpnext-backend

# Wait for site creation (first time only - takes 5-10 minutes)
docker-compose logs -f erpnext-backend | grep "Site created"
```

#### 7. Access Application

```bash
# Get EC2 public IP
curl http://169.254.169.254/latest/meta-data/public-ipv4

# Access via browser
http://<ec2-public-ip>

# Default credentials:
# Username: Administrator
# Password: (the ADMIN_PASSWORD from .env)
```

#### 8. Setup SSL Certificate (Let's Encrypt)

```bash
# First, ensure your domain points to EC2 public IP
# Check DNS propagation
nslookup nextgenfarmershub.com

# Update nginx config to use your domain
nano docker/nginx/conf.d/nextgen.conf
# Change server_name to your actual domain

# Restart nginx
docker-compose restart nginx

# Get SSL certificate
docker-compose run --rm certbot certonly \
  --webroot \
  --webroot-path=/var/www/certbot \
  -d nextgenfarmershub.com \
  -d www.nextgenfarmershub.com \
  --email admin@nextgenfarmershub.com \
  --agree-tos \
  --no-eff-email

# Update nginx config to enable HTTPS (uncomment HTTPS section)
nano docker/nginx/conf.d/nextgen.conf

# Restart nginx
docker-compose restart nginx

# Access via HTTPS
https://nextgenfarmershub.com
```

#### 9. Initial Configuration

After successful deployment:

1. **Login as Administrator**
   - URL: https://nextgenfarmershub.com
   - Username: Administrator
   - Password: (from .env ADMIN_PASSWORD)

2. **Complete Setup Wizard**
   - Company: NextGen Farmers Hub
   - Country: Ghana
   - Currency: GHS
   - Timezone: Africa/Accra

3. **Configure Email**
   - Go to: Settings > Email Domain
   - Setup SMTP settings

4. **Setup Roles**
   - Create roles: Cooperative Manager, Farm Manager, Cooperative Member

5. **Import Initial Data**
   - Import membership tiers
   - Import farm locations
   - Import member list

## Option 2: ECS with Fargate

### Best for:
- Fully managed container orchestration
- Auto-scaling requirements
- High availability needs

### Coming Soon
Detailed ECS deployment guide will be added in next update.

## Option 3: Lightsail Containers

### Best for:
- Simple deployment
- Predictable pricing
- Small deployments

### Quick Steps

1. **Create Lightsail Container Service**
```bash
aws lightsail create-container-service \
  --service-name nextgen-farmers \
  --power medium \
  --scale 1
```

2. **Push Docker Image**
```bash
# Build and push (instructions TBD)
```

## Database Options

### Option A: Containerized MariaDB (Default)

**Pros:**
- Simple setup
- No additional cost
- Included in docker-compose.yml

**Cons:**
- Manual backup management
- Limited to single instance
- Requires proper volume backup strategy

**Backup Strategy:**
- Automated daily backups via backup container
- Store backups on S3

### Option B: Amazon RDS for MariaDB

**Pros:**
- Fully managed
- Automated backups
- Multi-AZ for high availability
- Easy scaling

**Cons:**
- Additional cost (~$30-100/month)
- Slight latency increase

**Setup:**

```bash
# Create RDS instance
aws rds create-db-instance \
  --db-instance-identifier nextgen-farmers-db \
  --db-instance-class db.t3.medium \
  --engine mariadb \
  --engine-version 10.6 \
  --master-username admin \
  --master-user-password YourStrongPassword \
  --allocated-storage 50 \
  --storage-type gp3 \
  --vpc-security-group-ids sg-xxxxxx \
  --backup-retention-period 7 \
  --preferred-backup-window "02:00-03:00" \
  --multi-az

# Update .env file
DB_HOST=nextgen-farmers-db.xxxxxx.us-east-1.rds.amazonaws.com
DB_PORT=3306

# Update docker-compose.yml to remove mariadb service
# Comment out mariadb service section
```

## Storage and Backups

### S3 Backup Strategy

#### 1. Create S3 Bucket

```bash
# Create backup bucket
aws s3 mb s3://nextgen-farmers-backups

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket nextgen-farmers-backups \
  --versioning-configuration Status=Enabled

# Setup lifecycle policy (retain 30 days, then move to Glacier)
aws s3api put-bucket-lifecycle-configuration \
  --bucket nextgen-farmers-backups \
  --lifecycle-configuration file://s3-lifecycle.json
```

#### 2. Configure Automated Backups to S3

Create script: `docker/scripts/backup-to-s3.sh`

```bash
#!/bin/bash
# Backup database and files to S3

BACKUP_DIR="/home/ubuntu/backups"
S3_BUCKET="s3://nextgen-farmers-backups"
DATE=$(date +%Y%m%d_%H%M%S)

# Create backup using docker-compose
cd /home/ubuntu/nextgen_farmers
docker-compose exec -T mariadb mysqldump -u root -p${MYSQL_ROOT_PASSWORD} nextgen_db | gzip > ${BACKUP_DIR}/db_${DATE}.sql.gz

# Backup site files
docker-compose exec -T erpnext-backend tar czf - /home/frappe/frappe-bench/sites > ${BACKUP_DIR}/sites_${DATE}.tar.gz

# Upload to S3
aws s3 cp ${BACKUP_DIR}/db_${DATE}.sql.gz ${S3_BUCKET}/database/
aws s3 cp ${BACKUP_DIR}/sites_${DATE}.tar.gz ${S3_BUCKET}/sites/

# Cleanup local backups older than 3 days
find ${BACKUP_DIR} -name "*.gz" -mtime +3 -delete

echo "Backup completed: ${DATE}"
```

#### 3. Setup Cron Job

```bash
# Make script executable
chmod +x docker/scripts/backup-to-s3.sh

# Add to crontab
crontab -e

# Add this line for daily backup at 2 AM
0 2 * * * /home/ubuntu/nextgen_farmers/docker/scripts/backup-to-s3.sh >> /var/log/backup.log 2>&1
```

## SSL Certificate Setup

### Method 1: Let's Encrypt (Free)

Already covered in EC2 deployment steps above.

### Method 2: AWS Certificate Manager (ACM)

**Best for: Using with Application Load Balancer**

```bash
# Request certificate
aws acm request-certificate \
  --domain-name nextgenfarmershub.com \
  --subject-alternative-names www.nextgenfarmershub.com \
  --validation-method DNS

# Add CNAME records to Route 53 for validation
# Certificate will be issued automatically
```

## Monitoring and Logging

### CloudWatch Integration

#### 1. Install CloudWatch Agent

```bash
# Download and install CloudWatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i amazon-cloudwatch-agent.deb

# Configure agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

#### 2. Monitor Docker Logs

Create CloudWatch log group:

```bash
aws logs create-log-group --log-group-name /nextgen-farmers/docker
```

Update docker-compose.yml to add logging:

```yaml
logging:
  driver: awslogs
  options:
    awslogs-region: us-east-1
    awslogs-group: /nextgen-farmers/docker
    awslogs-stream: erpnext-backend
```

### Enable Monitoring Stack (Prometheus + Grafana)

```bash
# Start monitoring services
docker-compose --profile monitoring up -d

# Access Grafana
http://<ec2-ip>:3000
# Username: admin
# Password: (from GRAFANA_PASSWORD in .env)
```

## Cost Optimization

### Tips to Reduce AWS Costs

1. **Use Reserved Instances**
   - Save up to 75% with 1 or 3-year commitment
   - Recommended for production

2. **Right-size Your Instance**
   - Start with t3.medium
   - Monitor CPU/Memory usage
   - Scale up only when needed

3. **Use GP3 instead of GP2**
   - GP3 is 20% cheaper
   - Better performance baseline

4. **Enable S3 Lifecycle Policies**
   - Move old backups to Glacier
   - Delete backups older than 90 days

5. **Use Spot Instances for Dev/Test**
   - Up to 90% cost savings
   - Not recommended for production

6. **Setup CloudWatch Alarms**
   - Alert on unexpected resource usage
   - Prevent surprise bills

### Monthly Cost Estimate

**Small Deployment (100 users):**
- EC2 t3.large (1 year RI): $35/month
- EBS 50GB GP3: $4/month
- S3 backups (100GB): $2.30/month
- Data transfer: $5/month
- **Total: ~$46/month**

**Medium Deployment (500 users):**
- EC2 t3.xlarge (1 year RI): $70/month
- EBS 100GB GP3: $8/month
- RDS db.t3.medium: $40/month
- S3 backups: $5/month
- Data transfer: $10/month
- **Total: ~$133/month**

## Maintenance

### Regular Tasks

**Daily:**
- Monitor CloudWatch metrics
- Check application logs
- Verify backup completion

**Weekly:**
- Review security alerts
- Check disk usage
- Update packages

**Monthly:**
- Review AWS costs
- Update Docker images
- Test disaster recovery

### Update Procedure

```bash
# Pull latest code
cd ~/nextgen_farmers
git pull

# Rebuild containers
docker-compose build

# Restart services (zero-downtime)
docker-compose up -d

# Run migrations
docker-compose exec erpnext-backend bench --site nextgenfarmershub.com migrate

# Clear cache
docker-compose exec erpnext-backend bench --site nextgenfarmershub.com clear-cache
```

## Troubleshooting

### Common Issues

**1. Services won't start**
```bash
# Check logs
docker-compose logs

# Check disk space
df -h

# Check memory
free -m
```

**2. Database connection errors**
```bash
# Verify database is running
docker-compose ps mariadb

# Check database logs
docker-compose logs mariadb

# Test connection
docker-compose exec mariadb mysql -u root -p
```

**3. High memory usage**
```bash
# Check container stats
docker stats

# Restart specific service
docker-compose restart erpnext-backend
```

**4. SSL certificate issues**
```bash
# Renew certificate manually
docker-compose run --rm certbot renew

# Check certificate status
docker-compose exec nginx nginx -t
```

## Support

For AWS deployment issues:
- **Email**: devops@nextgenfarmershub.com
- **AWS Support**: Check your AWS support plan
- **Community**: Frappe Forum

## Security Best Practices

1. **Enable AWS GuardDuty** for threat detection
2. **Use AWS Systems Manager** for secure SSH access
3. **Enable VPC Flow Logs** for network monitoring
4. **Use AWS Secrets Manager** for sensitive credentials
5. **Regular security updates**: `sudo apt update && sudo apt upgrade`
6. **Enable MFA** for AWS root account
7. **Use IAM roles** instead of access keys where possible
8. **Regular security audits** using AWS Security Hub

---

**Next Steps:**
1. Review [INSTALLATION.md](./INSTALLATION.md) for application configuration
2. Review [DEPLOYMENT.md](./DEPLOYMENT.md) for general deployment best practices
3. Setup monitoring and alerts
4. Configure automated backups to S3
5. Test disaster recovery procedures

**Deployment Checklist:**
- [ ] EC2 instance launched and configured
- [ ] Security groups properly configured
- [ ] Docker and Docker Compose installed
- [ ] Application deployed and running
- [ ] SSL certificate configured
- [ ] Backups configured and tested
- [ ] Monitoring enabled
- [ ] DNS configured
- [ ] Initial data imported
- [ ] User training completed
