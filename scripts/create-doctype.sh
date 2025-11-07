#!/bin/bash
# Helper script to create new DocType

DOCTYPE_NAME=$1
SITE_NAME=${2:-nextgenfarmers.local}

if [ -z "$DOCTYPE_NAME" ]; then
  echo "Usage: ./scripts/create-doctype.sh 'DocType Name' [site_name]"
  echo ""
  echo "Example:"
  echo "  ./scripts/create-doctype.sh 'Member'"
  echo "  ./scripts/create-doctype.sh 'Share Purchase'"
  exit 1
fi

echo "================================================"
echo "Creating DocType: $DOCTYPE_NAME"
echo "================================================"
echo ""

# Convert to lowercase with underscores for directory name
DOCTYPE_DIR=$(echo "$DOCTYPE_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

echo "[1/3] Creating DocType structure..."
mkdir -p "apps/nextgen_farmers/nextgen_farmers/nextgen_farmers/doctype/$DOCTYPE_DIR"

echo "[2/3] Creating DocType files..."
cat > "apps/nextgen_farmers/nextgen_farmers/nextgen_farmers/doctype/$DOCTYPE_DIR/${DOCTYPE_DIR}.json" << EOF
{
 "actions": [],
 "creation": "$(date '+%Y-%m-%d %H:%M:%S.%6N')",
 "doctype": "DocType",
 "editable_grid": 1,
 "engine": "InnoDB",
 "field_order": [],
 "fields": [],
 "index_web_pages_for_search": 1,
 "links": [],
 "modified": "$(date '+%Y-%m-%d %H:%M:%S.%6N')",
 "modified_by": "Administrator",
 "module": "NextGen Farmers",
 "name": "$DOCTYPE_NAME",
 "owner": "Administrator",
 "permissions": [
  {
   "create": 1,
   "delete": 1,
   "email": 1,
   "export": 1,
   "print": 1,
   "read": 1,
   "report": 1,
   "role": "System Manager",
   "share": 1,
   "write": 1
  }
 ],
 "sort_field": "modified",
 "sort_order": "DESC",
 "states": []
}
EOF

cat > "apps/nextgen_farmers/nextgen_farmers/nextgen_farmers/doctype/$DOCTYPE_DIR/${DOCTYPE_DIR}.py" << EOF
# Copyright (c) 2025, NextGen Farmers Hub and contributors
# For license information, please see license.txt

import frappe
from frappe.model.document import Document


class $(echo $DOCTYPE_NAME | tr ' ' '')(Document):
    def validate(self):
        """Validate document before save"""
        pass

    def on_submit(self):
        """Actions to perform on document submit"""
        pass
EOF

cat > "apps/nextgen_farmers/nextgen_farmers/nextgen_farmers/doctype/$DOCTYPE_DIR/${DOCTYPE_DIR}.js" << EOF
// Copyright (c) 2025, NextGen Farmers Hub and contributors
// For license information, please see license.txt

frappe.ui.form.on('$DOCTYPE_NAME', {
    refresh: function(frm) {
        // Custom buttons and actions
    }
});
EOF

cat > "apps/nextgen_farmers/nextgen_farmers/nextgen_farmers/doctype/$DOCTYPE_DIR/test_${DOCTYPE_DIR}.py" << EOF
# Copyright (c) 2025, NextGen Farmers Hub and Contributors
# See license.txt

import frappe
import unittest


class Test$(echo $DOCTYPE_NAME | tr ' ' '')(unittest.TestCase):
    def setUp(self):
        """Set up test data"""
        pass

    def test_validation(self):
        """Test document validation"""
        pass
EOF

echo ""
echo "[3/3] Creating __init__.py..."
touch "apps/nextgen_farmers/nextgen_farmers/nextgen_farmers/doctype/$DOCTYPE_DIR/__init__.py"

echo ""
echo "================================================"
echo "✅ DocType created successfully!"
echo "================================================"
echo ""
echo "Files created:"
echo "  - $DOCTYPE_DIR.json"
echo "  - $DOCTYPE_DIR.py"
echo "  - $DOCTYPE_DIR.js"
echo "  - test_$DOCTYPE_DIR.py"
echo ""
echo "Location: apps/nextgen_farmers/nextgen_farmers/nextgen_farmers/doctype/$DOCTYPE_DIR/"
echo ""
echo "Next steps:"
echo "  1. Edit the JSON file to add fields"
echo "  2. Add validation logic in .py file"
echo "  3. Add client-side JS in .js file"
echo "  4. Run: docker exec -it nextgen-backend bench --site $SITE_NAME migrate"
echo ""
