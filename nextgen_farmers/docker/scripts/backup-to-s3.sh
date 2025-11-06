#!/bin/bash
###############################################################################
# NextGen Farmers Hub - S3 Backup Script
# Backs up database and site files to AWS S3
###############################################################################

set -e

# Configuration
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(dirname $(dirname $SCRIPT_DIR))"
BACKUP_DIR="${BACKUP_DIR:-$HOME/backups}"
S3_BUCKET="${S3_BUCKET:-nextgen-farmers-backups}"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=${RETENTION_DAYS:-7}

# Load environment variables
if [ -f "$PROJECT_DIR/.env" ]; then
    export $(cat "$PROJECT_DIR/.env" | grep -v '^#' | xargs)
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

log_info "Starting backup process..."
log_info "Date: $DATE"
log_info "Backup directory: $BACKUP_DIR"
log_info "S3 bucket: $S3_BUCKET"

# Change to project directory
cd $PROJECT_DIR

# Check if docker-compose is running
if ! docker-compose ps | grep -q "Up"; then
    log_error "Docker Compose services are not running!"
    exit 1
fi

# Backup database
log_info "Backing up database..."
DB_BACKUP_FILE="$BACKUP_DIR/nextgen_db_${DATE}.sql.gz"

if docker-compose exec -T mariadb mysqldump \
    -u root \
    -p${MYSQL_ROOT_PASSWORD} \
    --single-transaction \
    --quick \
    --lock-tables=false \
    ${MYSQL_DATABASE} | gzip > $DB_BACKUP_FILE; then

    log_info "Database backup created: $DB_BACKUP_FILE"
    DB_SIZE=$(du -h $DB_BACKUP_FILE | cut -f1)
    log_info "Database backup size: $DB_SIZE"
else
    log_error "Database backup failed!"
    exit 1
fi

# Backup site files
log_info "Backing up site files..."
SITES_BACKUP_FILE="$BACKUP_DIR/nextgen_sites_${DATE}.tar.gz"

if docker-compose exec -T erpnext-backend \
    tar czf - -C /home/frappe/frappe-bench sites \
    > $SITES_BACKUP_FILE; then

    log_info "Sites backup created: $SITES_BACKUP_FILE"
    SITES_SIZE=$(du -h $SITES_BACKUP_FILE | cut -f1)
    log_info "Sites backup size: $SITES_SIZE"
else
    log_error "Sites backup failed!"
    exit 1
fi

# Upload to S3
log_info "Uploading backups to S3..."

# Check if AWS CLI is configured
if ! aws s3 ls s3://$S3_BUCKET &> /dev/null; then
    log_error "Cannot access S3 bucket: $S3_BUCKET"
    log_warn "Backups are saved locally in: $BACKUP_DIR"
    exit 1
fi

# Upload database backup
if aws s3 cp $DB_BACKUP_FILE s3://$S3_BUCKET/database/ \
    --storage-class STANDARD_IA \
    --metadata "backup-date=$DATE"; then
    log_info "Database backup uploaded to S3"
else
    log_error "Failed to upload database backup to S3"
fi

# Upload sites backup
if aws s3 cp $SITES_BACKUP_FILE s3://$S3_BUCKET/sites/ \
    --storage-class STANDARD_IA \
    --metadata "backup-date=$DATE"; then
    log_info "Sites backup uploaded to S3"
else
    log_error "Failed to upload sites backup to S3"
fi

# Create backup manifest
MANIFEST_FILE="$BACKUP_DIR/manifest_${DATE}.json"
cat > $MANIFEST_FILE <<EOF
{
  "backup_date": "$DATE",
  "database_file": "$(basename $DB_BACKUP_FILE)",
  "database_size": "$DB_SIZE",
  "sites_file": "$(basename $SITES_BACKUP_FILE)",
  "sites_size": "$SITES_SIZE",
  "s3_bucket": "$S3_BUCKET",
  "hostname": "$(hostname)",
  "mysql_version": "$(docker-compose exec -T mariadb mysql --version)"
}
EOF

aws s3 cp $MANIFEST_FILE s3://$S3_BUCKET/manifests/ || log_warn "Failed to upload manifest"

# Cleanup old local backups
log_info "Cleaning up old local backups (older than $RETENTION_DAYS days)..."
find $BACKUP_DIR -name "nextgen_*.gz" -mtime +$RETENTION_DAYS -delete
find $BACKUP_DIR -name "manifest_*.json" -mtime +$RETENTION_DAYS -delete

LOCAL_BACKUP_COUNT=$(ls -1 $BACKUP_DIR/nextgen_*.gz 2>/dev/null | wc -l)
log_info "Local backups remaining: $LOCAL_BACKUP_COUNT"

# List recent backups in S3
log_info "Recent backups in S3:"
aws s3 ls s3://$S3_BUCKET/database/ --recursive | tail -5

log_info "Backup completed successfully!"

# Send notification (optional)
if command -v curl &> /dev/null && [ ! -z "$SLACK_WEBHOOK_URL" ]; then
    curl -X POST $SLACK_WEBHOOK_URL \
        -H 'Content-Type: application/json' \
        -d "{\"text\":\"✅ Backup completed for NextGen Farmers Hub\\nDate: $DATE\\nDatabase: $DB_SIZE\\nSites: $SITES_SIZE\"}" \
        &> /dev/null || true
fi

exit 0
