#!/bin/bash
# Install NextGen Farmers custom app

set -e

SITE_NAME=${1:-nextgenfarmers.local}

echo "================================================"
echo "Installing NextGen Farmers Custom App"
echo "================================================"
echo "Site: $SITE_NAME"
echo ""

cd /home/frappe/frappe-bench

if [ ! -d "apps/nextgen_farmers" ]; then
  echo "[1/5] Custom app not found. Creating..."
  bench new-app nextgen_farmers
else
  echo "[1/5] Custom app found."
fi

echo ""
echo "[2/5] Installing app on site..."
bench --site $SITE_NAME install-app nextgen_farmers

echo ""
echo "[3/5] Migrating database..."
bench --site $SITE_NAME migrate

echo ""
echo "[4/5] Clearing cache..."
bench --site $SITE_NAME clear-cache

echo ""
echo "[5/5] Building assets..."
bench build --app nextgen_farmers

echo ""
echo "================================================"
echo "✅ Custom app installed successfully!"
echo "================================================"
echo ""
echo "App location: apps/nextgen_farmers/"
echo "Edit files on your Mac and changes will reflect in the container."
echo ""
