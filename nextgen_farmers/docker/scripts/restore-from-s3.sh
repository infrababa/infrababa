#!/bin/bash
###############################################################################
# NextGen Farmers Hub - S3 Restore Script
# Restores database and site files from AWS S3
###############################################################################

set -e

# Configuration
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(dirname $(dirname $SCRIPT_DIR))"
RESTORE_DIR="${RESTORE_DIR:-$HOME/restore}"
S3_BUCKET="${S3_BUCKET:-nextgen-farmers-backups}"

# Load environment variables
if [ -f "$PROJECT_DIR/.env" ]; then
    export $(cat "$PROJECT_DIR/.env" | grep -v '^#' | xargs)
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create restore directory
mkdir -p $RESTORE_DIR

log_warn "=========================================="
log_warn "NextGen Farmers Hub - Restore from S3"
log_warn "=========================================="
log_warn "This will restore data from S3 backup"
log_warn "Current data will be REPLACED!"
log_warn ""

read -p "Are you sure you want to continue? (type 'yes' to confirm): " -r
if [[ ! $REPLY == "yes" ]]; then
    log_info "Restore cancelled"
    exit 0
fi

# List available backups
log_info "Listing available backups in S3..."
echo ""
echo "Database backups:"
aws s3 ls s3://$S3_BUCKET/database/ | tail -10
echo ""
echo "Sites backups:"
aws s3 ls s3://$S3_BUCKET/sites/ | tail -10
echo ""

# Prompt for backup file
read -p "Enter database backup filename (e.g., nextgen_db_20250106_120000.sql.gz): " DB_FILE
read -p "Enter sites backup filename (e.g., nextgen_sites_20250106_120000.tar.gz): " SITES_FILE

# Download backups from S3
log_info "Downloading database backup from S3..."
aws s3 cp s3://$S3_BUCKET/database/$DB_FILE $RESTORE_DIR/

log_info "Downloading sites backup from S3..."
aws s3 cp s3://$S3_BUCKET/sites/$SITES_FILE $RESTORE_DIR/

# Stop services
log_warn "Stopping services..."
cd $PROJECT_DIR
docker-compose stop erpnext-backend erpnext-worker-default erpnext-worker-short erpnext-worker-long erpnext-scheduler

# Restore database
log_info "Restoring database..."
gunzip < $RESTORE_DIR/$DB_FILE | docker-compose exec -T mariadb mysql -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE}

if [ $? -eq 0 ]; then
    log_info "Database restored successfully"
else
    log_error "Database restore failed!"
    exit 1
fi

# Restore sites
log_info "Restoring site files..."
docker-compose exec -T erpnext-backend bash -c "cd /home/frappe/frappe-bench && rm -rf sites/*"
docker-compose exec -T erpnext-backend tar xzf - -C /home/frappe/frappe-bench < $RESTORE_DIR/$SITES_FILE

if [ $? -eq 0 ]; then
    log_info "Sites restored successfully"
else
    log_error "Sites restore failed!"
    exit 1
fi

# Start services
log_info "Starting services..."
docker-compose start erpnext-backend erpnext-worker-default erpnext-worker-short erpnext-worker-long erpnext-scheduler

# Wait for services to be ready
log_info "Waiting for services to be ready..."
sleep 10

# Clear cache
log_info "Clearing cache..."
docker-compose exec erpnext-backend bench --site ${SITE_NAME:-nextgenfarmershub.com} clear-cache

log_info "=========================================="
log_info "Restore completed successfully!"
log_info "=========================================="
log_info "Database: $DB_FILE"
log_info "Sites: $SITES_FILE"
log_info ""
log_info "Please verify the application is working correctly."

exit 0
