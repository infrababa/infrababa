#!/bin/bash
# Run tests for NextGen Farmers custom app

set -e

SITE_NAME=${1:-nextgenfarmers.local}
TEST_FILTER=${2:-}

echo "================================================"
echo "Running Tests for NextGen Farmers Hub"
echo "================================================"
echo "Site: $SITE_NAME"
echo ""

if [ -z "$TEST_FILTER" ]; then
  echo "Running all tests for nextgen_farmers app..."
  bench --site $SITE_NAME run-tests --app nextgen_farmers --coverage
else
  echo "Running filtered tests: $TEST_FILTER"
  bench --site $SITE_NAME run-tests --app nextgen_farmers --test "$TEST_FILTER"
fi

echo ""
echo "================================================"
echo "✅ Tests completed!"
echo "================================================"
