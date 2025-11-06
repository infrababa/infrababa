#!/bin/bash
set -e

cd /home/frappe/frappe-bench

# Wait for MariaDB to be ready
echo "Waiting for MariaDB..."
while ! mysqladmin ping -h"${DB_HOST}" -P"${DB_PORT}" --silent; do
    echo "MariaDB is unavailable - sleeping"
    sleep 2
done

echo "MariaDB is up - executing command"

# Check if site exists, if not create it
SITE_NAME="${SITE_NAME:-nextgenfarmershub.com}"

if [ ! -d "sites/${SITE_NAME}" ]; then
    echo "Creating new site: ${SITE_NAME}"
    bench new-site ${SITE_NAME} \
        --db-host ${DB_HOST} \
        --db-port ${DB_PORT} \
        --mariadb-root-password ${MYSQL_ROOT_PASSWORD} \
        --admin-password ${ADMIN_PASSWORD:-admin} \
        --no-mariadb-socket

    echo "Installing ERPNext..."
    bench --site ${SITE_NAME} install-app erpnext

    echo "Installing Agriculture (if available)..."
    bench --site ${SITE_NAME} install-app agriculture || true

    echo "Installing NextGen Farmers..."
    bench --site ${SITE_NAME} install-app nextgen_farmers

    echo "Setting up site..."
    bench --site ${SITE_NAME} set-config developer_mode 0
    bench --site ${SITE_NAME} set-config maintenance_mode 0
fi

# Auto migrate if enabled
if [ "${AUTO_MIGRATE}" = "1" ]; then
    echo "Running migrations..."
    bench --site ${SITE_NAME} migrate || true
fi

# Set Redis configuration
if [ ! -z "${REDIS_CACHE}" ]; then
    bench --site ${SITE_NAME} set-config redis_cache "${REDIS_CACHE}"
fi

if [ ! -z "${REDIS_QUEUE}" ]; then
    bench --site ${SITE_NAME} set-config redis_queue "${REDIS_QUEUE}"
fi

if [ ! -z "${REDIS_SOCKETIO}" ]; then
    bench --site ${SITE_NAME} set-config redis_socketio "${REDIS_SOCKETIO}"
fi

# Clear cache
bench --site ${SITE_NAME} clear-cache || true

echo "Starting application..."
exec "$@"
