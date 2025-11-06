#!/bin/bash
###############################################################################
# NextGen Farmers Hub - Health Check Script
# Checks the health of all services and sends alerts if issues are detected
###############################################################################

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(dirname $(dirname $SCRIPT_DIR))"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

HEALTHY=0
UNHEALTHY=0

check_service() {
    SERVICE_NAME=$1

    if docker-compose ps $SERVICE_NAME | grep -q "Up"; then
        echo -e "${GREEN}✓${NC} $SERVICE_NAME is running"
        ((HEALTHY++))
        return 0
    else
        echo -e "${RED}✗${NC} $SERVICE_NAME is NOT running"
        ((UNHEALTHY++))
        return 1
    fi
}

check_url() {
    URL=$1
    NAME=$2

    if curl -f -s -o /dev/null $URL; then
        echo -e "${GREEN}✓${NC} $NAME is accessible"
        ((HEALTHY++))
        return 0
    else
        echo -e "${RED}✗${NC} $NAME is NOT accessible"
        ((UNHEALTHY++))
        return 1
    fi
}

check_disk_space() {
    USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

    if [ $USAGE -lt 80 ]; then
        echo -e "${GREEN}✓${NC} Disk usage: ${USAGE}%"
        ((HEALTHY++))
    elif [ $USAGE -lt 90 ]; then
        echo -e "${YELLOW}⚠${NC} Disk usage: ${USAGE}% (Warning)"
        ((UNHEALTHY++))
    else
        echo -e "${RED}✗${NC} Disk usage: ${USAGE}% (Critical)"
        ((UNHEALTHY++))
    fi
}

check_memory() {
    USAGE=$(free | awk 'NR==2 {printf "%.0f", $3/$2 * 100.0}')

    if [ $USAGE -lt 80 ]; then
        echo -e "${GREEN}✓${NC} Memory usage: ${USAGE}%"
        ((HEALTHY++))
    elif [ $USAGE -lt 90 ]; then
        echo -e "${YELLOW}⚠${NC} Memory usage: ${USAGE}% (Warning)"
        ((UNHEALTHY++))
    else
        echo -e "${RED}✗${NC} Memory usage: ${USAGE}% (Critical)"
        ((UNHEALTHY++))
    fi
}

cd $PROJECT_DIR

echo "=========================================="
echo "NextGen Farmers Hub - Health Check"
echo "=========================================="
echo "Date: $(date)"
echo ""

echo "Checking Docker services..."
check_service "mariadb"
check_service "redis-cache"
check_service "redis-queue"
check_service "erpnext-backend"
check_service "nginx"
check_service "erpnext-scheduler"
check_service "erpnext-worker-default"

echo ""
echo "Checking application endpoints..."
check_url "http://localhost/api/method/ping" "Application API"

echo ""
echo "Checking system resources..."
check_disk_space
check_memory

echo ""
echo "=========================================="
echo "Summary"
echo "=========================================="
echo -e "Healthy checks: ${GREEN}$HEALTHY${NC}"
echo -e "Unhealthy checks: ${RED}$UNHEALTHY${NC}"

if [ $UNHEALTHY -gt 0 ]; then
    echo -e "\n${RED}Some checks failed!${NC}"
    exit 1
else
    echo -e "\n${GREEN}All checks passed!${NC}"
    exit 0
fi
