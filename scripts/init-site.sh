#!/bin/bash
# Initialize ERPNext site for NextGen Farmers Hub

set -e

SITE_NAME=${1:-nextgenfarmers.local}
ADMIN_PASSWORD=${2:-admin}

echo "================================================"
echo "Initializing NextGen Farmers Hub Site"
echo "================================================"
echo "Site Name: $SITE_NAME"
echo "Admin Password: $ADMIN_PASSWORD"
echo ""

echo "[1/6] Creating new Frappe site..."
bench new-site $SITE_NAME \
  --db-host mariadb \
  --db-root-password rootpassword \
  --admin-password $ADMIN_PASSWORD \
  --no-mariadb-socket

echo ""
echo "[2/6] Installing ERPNext..."
bench --site $SITE_NAME install-app erpnext

echo ""
echo "[3/6] Installing Agriculture module..."
bench --site $SITE_NAME install-app agriculture

echo ""
echo "[4/6] Checking for NextGen Farmers custom app..."
if [ -d "apps/nextgen_farmers" ]; then
  echo "[5/6] Installing NextGen Farmers custom app..."
  bench --site $SITE_NAME install-app nextgen_farmers
else
  echo "[5/6] NextGen Farmers custom app not found. Skipping..."
fi

echo ""
echo "[6/6] Setting site as default..."
bench use $SITE_NAME

echo ""
echo "================================================"
echo "✅ Site initialized successfully!"
echo "================================================"
echo ""
echo "Access: http://localhost:8000"
echo "Username: Administrator"
echo "Password: $ADMIN_PASSWORD"
echo ""
echo "Next steps:"
echo "  - Create custom app: bench new-app nextgen_farmers"
echo "  - Start developing!"
echo ""
