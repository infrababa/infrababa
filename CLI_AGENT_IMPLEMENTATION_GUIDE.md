# CLI Agent Implementation Guide
## NextGen Farmers Hub ERPNext Customization

**For**: Claude CLI Agent & Gemini CLI Delegation
**Project**: NextGen Farmers Hub CRM Platform
**Version**: 1.0
**Date**: 2025-11-07

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Environment Setup](#environment-setup)
3. [Task Breakdown](#task-breakdown)
4. [Implementation Instructions](#implementation-instructions)
5. [Code Templates](#code-templates)
6. [Testing Procedures](#testing-procedures)
7. [Git Workflow](#git-workflow)
8. [Delegation Guidelines](#delegation-guidelines)

---

## Quick Start

### Prerequisites Checklist

```bash
# Check Python version (should be 3.10+)
python3 --version

# Check Node.js version (should be 16+)
node --version

# Check MariaDB/MySQL
mysql --version

# Check Redis
redis-cli ping

# Check Git
git --version
```

### Initial Setup Commands

```bash
# 1. Install Frappe Bench
pip3 install frappe-bench

# 2. Initialize bench
bench init frappe-bench --frappe-branch version-15 --python python3.10

# 3. Navigate to bench directory
cd frappe-bench

# 4. Create new site
bench new-site nextgenfarmers.local \
    --db-name nextgen_farmers \
    --db-password strongpassword \
    --admin-password admin

# 5. Get ERPNext
bench get-app erpnext --branch version-15

# 6. Get Agriculture module
bench get-app agriculture https://github.com/frappe/agriculture

# 7. Install apps on site
bench --site nextgenfarmers.local install-app erpnext
bench --site nextgenfarmers.local install-app agriculture

# 8. Start development server
bench start
```

---

## Environment Setup

### Directory Structure

Create this structure in your bench directory:

```
frappe-bench/
├── apps/
│   ├── frappe/
│   ├── erpnext/
│   ├── agriculture/
│   └── nextgen_farmers/     ← CREATE THIS
├── sites/
│   └── nextgenfarmers.local/
└── ...
```

### Create Custom App

```bash
# Navigate to frappe-bench
cd frappe-bench

# Create custom app
bench new-app nextgen_farmers

# When prompted, enter:
# - App Title: NextGen Farmers Hub
# - App Description: Cooperative management system for NextGen Farmers Hub
# - App Publisher: NextGen Farmers Hub
# - App Email: admin@nextgenfarmershub.com
# - App License: MIT

# Install app on site
bench --site nextgenfarmers.local install-app nextgen_farmers

# Set as default app
bench --site nextgenfarmers.local set-config default_app nextgen_farmers
```

---

## Task Breakdown

### Phase 1 Tasks (Foundation)

#### TASK-001: Create Custom App Structure
**Assigned to**: Claude CLI
**Priority**: Critical
**Estimated Time**: 30 minutes

**Description**: Set up the nextgen_farmers custom app with proper structure

**Steps**:
1. Run `bench new-app nextgen_farmers`
2. Create necessary directories
3. Update hooks.py with configurations
4. Commit to Git

**Acceptance Criteria**:
- [ ] App created successfully
- [ ] hooks.py configured
- [ ] Git repository initialized
- [ ] First commit made

**Code Required**:
```python
# File: apps/nextgen_farmers/nextgen_farmers/hooks.py

app_name = "nextgen_farmers"
app_title = "NextGen Farmers Hub"
app_publisher = "NextGen Farmers Hub"
app_description = "Cooperative management system"
app_email = "admin@nextgenfarmershub.com"
app_license = "MIT"
app_version = "1.0.0"

# Apps to include in website
website_route_rules = [
    {"from_route": "/member-portal", "to_route": "member_portal"},
]

# Application start
app_include_css = [
    "/assets/nextgen_farmers/css/nextgen_theme.css"
]

app_include_js = [
    "/assets/nextgen_farmers/js/member_portal.js"
]

# Desk icons
app_logo_url = '/assets/nextgen_farmers/images/logo.png'

# Home Pages
website_context = {
    "brand_html": "NextGen Farmers Hub"
}

# Boot session
boot_session = "nextgen_farmers.boot.boot_session"

# Notification
notification_config = "nextgen_farmers.notifications.get_notification_config"

# Permissions evaluated in scripted ways
permission_query_conditions = {
    "Member": "nextgen_farmers.member.get_permission_query_conditions",
}

# DocType Class
override_doctype_class = {
    "Crop Cycle": "nextgen_farmers.overrides.crop_cycle.MemberCropCycle"
}

# Scheduled Tasks
scheduler_events = {
    "daily": [
        "nextgen_farmers.tasks.daily.send_member_notifications"
    ],
    "monthly": [
        "nextgen_farmers.tasks.monthly.calculate_dividends"
    ]
}

# Paystack webhook
override_whitelisted_methods = {
    "nextgen_farmers.api.paystack.webhook": "nextgen_farmers.api.paystack.paystack_webhook"
}
```

---

#### TASK-002: Apply NextGen Branding
**Assigned to**: Gemini CLI (delegated by Claude)
**Priority**: High
**Estimated Time**: 1 hour

**Description**: Apply NextGen Farmers Hub branding (orange #f4511e, gray #32373c)

**Steps**:
1. Create CSS file with custom variables
2. Create custom theme
3. Apply to site
4. Test visual consistency

**Files to Create**:

**File 1**: `apps/nextgen_farmers/nextgen_farmers/public/css/nextgen_theme.css`

```css
/* NextGen Farmers Hub Branding */

:root,
[data-theme="light"] {
  /* Brand Colors */
  --brand-primary: #f4511e;
  --brand-secondary: #32373c;
  --brand-white: #ffffff;
  --brand-black: #000000;

  /* Orange Palette */
  --orange-50: #fff5f2;
  --orange-100: #ffe8e0;
  --orange-200: #ffd0c1;
  --orange-300: #ffb8a1;
  --orange-400: #ff9a6f;
  --orange-500: #f4511e;
  --orange-600: #dc4619;
  --orange-700: #b83b15;
  --orange-800: #942f11;
  --orange-900: #6b220c;

  /* Gray Palette */
  --gray-500: #32373c;
  --gray-600: #2d3136;
  --gray-700: #252a2e;
  --gray-400: #5f6570;

  /* Apply to Frappe Variables */
  --primary: var(--orange-500);
  --brand-color: var(--orange-500);
  --navbar-bg: var(--gray-500);
  --btn-primary: var(--orange-500);
  --link-color: var(--orange-600);
}

/* Primary Buttons */
.btn-primary {
  background-color: var(--brand-primary) !important;
  border-color: var(--brand-primary) !important;
  color: white !important;
}

.btn-primary:hover,
.btn-primary:focus {
  background-color: var(--orange-600) !important;
  border-color: var(--orange-600) !important;
}

.btn-primary:active {
  background-color: var(--orange-700) !important;
}

/* Navigation Bar */
.navbar {
  background-color: var(--brand-secondary) !important;
}

.navbar-brand,
.navbar .nav-link {
  color: white !important;
}

.navbar .nav-link:hover {
  color: var(--orange-400) !important;
}

/* Sidebar */
.desk-sidebar .sidebar-item.selected,
.desk-sidebar .sidebar-item.active {
  background-color: var(--orange-50);
  border-left: 3px solid var(--brand-primary);
  color: var(--orange-700);
}

.desk-sidebar .sidebar-item:hover {
  background-color: var(--orange-50);
}

/* Links */
a:not(.btn) {
  color: var(--orange-600);
}

a:not(.btn):hover {
  color: var(--orange-700);
}

/* Form Focus States */
input:focus,
select:focus,
textarea:focus {
  border-color: var(--brand-primary);
  box-shadow: 0 0 0 0.2rem rgba(244, 81, 30, 0.25);
}

/* Checkboxes */
input[type="checkbox"]:checked {
  background-color: var(--brand-primary);
  border-color: var(--brand-primary);
}

/* Indicators */
.indicator-pill.orange,
.indicator-dot.orange {
  background-color: var(--brand-primary);
}

/* Page Header */
.page-head {
  background-color: white;
  border-bottom: 1px solid #e2e2e2;
}

.page-title {
  color: var(--brand-secondary);
}
```

**File 2**: `apps/nextgen_farmers/nextgen_farmers/public/js/member_portal.js`

```javascript
// Member Portal JavaScript

frappe.ready(function() {
    // Add any custom JS for member portal
    console.log('NextGen Farmers Hub Portal Loaded');
});

// Share purchase amount calculation
function calculate_share_amount(share_price, quantity) {
    return share_price * quantity;
}

// Format currency
function format_currency(amount) {
    return 'KES ' + Number(amount).toLocaleString();
}
```

**Acceptance Criteria**:
- [ ] CSS file created with all brand colors
- [ ] Buttons show orange color
- [ ] Navbar shows dark gray
- [ ] Links are orange
- [ ] Visual consistency across all pages

---

### Phase 2 Tasks (Member Management)

#### TASK-003: Create Member DocType
**Assigned to**: Claude CLI
**Priority**: Critical
**Estimated Time**: 1 hour

**Description**: Create the core Member DocType for farmer registration

**Implementation**:

```bash
# Navigate to app directory
cd apps/nextgen_farmers

# Create DocType using bench
bench --site nextgenfarmers.local create-doctype \
    --app nextgen_farmers \
    --module "NextGen Farmers" \
    Member
```

**JSON Definition**:

**File**: `apps/nextgen_farmers/nextgen_farmers/nextgen_farmers/doctype/member/member.json`

```json
{
 "actions": [],
 "allow_rename": 1,
 "autoname": "format:MEM-{#####}",
 "creation": "2025-11-07 10:00:00.000000",
 "doctype": "DocType",
 "editable_grid": 1,
 "engine": "InnoDB",
 "field_order": [
  "member_details",
  "member_name",
  "id_number",
  "column_break_3",
  "phone_number",
  "email",
  "section_break_6",
  "date_of_birth",
  "gender",
  "column_break_9",
  "membership_date",
  "membership_status",
  "section_break_12",
  "member_photo",
  "farm_information",
  "total_land_hectares",
  "farm_locations",
  "financial_summary",
  "total_shares",
  "account_balance",
  "column_break_19",
  "total_investment",
  "last_transaction_date"
 ],
 "fields": [
  {
   "fieldname": "member_details",
   "fieldtype": "Section Break",
   "label": "Member Details"
  },
  {
   "fieldname": "member_name",
   "fieldtype": "Data",
   "in_list_view": 1,
   "label": "Member Name",
   "reqd": 1
  },
  {
   "fieldname": "id_number",
   "fieldtype": "Data",
   "label": "ID Number",
   "unique": 1,
   "reqd": 1
  },
  {
   "fieldname": "column_break_3",
   "fieldtype": "Column Break"
  },
  {
   "fieldname": "phone_number",
   "fieldtype": "Data",
   "label": "Phone Number",
   "unique": 1,
   "reqd": 1
  },
  {
   "fieldname": "email",
   "fieldtype": "Data",
   "label": "Email",
   "options": "Email"
  },
  {
   "fieldname": "section_break_6",
   "fieldtype": "Section Break"
  },
  {
   "fieldname": "date_of_birth",
   "fieldtype": "Date",
   "label": "Date of Birth"
  },
  {
   "fieldname": "gender",
   "fieldtype": "Select",
   "label": "Gender",
   "options": "Male\nFemale\nOther"
  },
  {
   "fieldname": "column_break_9",
   "fieldtype": "Column Break"
  },
  {
   "fieldname": "membership_date",
   "fieldtype": "Date",
   "label": "Membership Date",
   "reqd": 1,
   "default": "Today"
  },
  {
   "fieldname": "membership_status",
   "fieldtype": "Select",
   "label": "Membership Status",
   "options": "Active\nSuspended\nExited",
   "default": "Active",
   "reqd": 1
  },
  {
   "fieldname": "section_break_12",
   "fieldtype": "Section Break"
  },
  {
   "fieldname": "member_photo",
   "fieldtype": "Attach Image",
   "label": "Member Photo"
  },
  {
   "fieldname": "farm_information",
   "fieldtype": "Section Break",
   "label": "Farm Information"
  },
  {
   "fieldname": "total_land_hectares",
   "fieldtype": "Float",
   "label": "Total Land (Hectares)",
   "precision": "2"
  },
  {
   "fieldname": "farm_locations",
   "fieldtype": "Table",
   "label": "Farm Locations",
   "options": "Member Farm Location"
  },
  {
   "fieldname": "financial_summary",
   "fieldtype": "Section Break",
   "label": "Financial Summary",
   "collapsible": 1
  },
  {
   "fieldname": "total_shares",
   "fieldtype": "Int",
   "label": "Total Shares",
   "read_only": 1,
   "default": "0"
  },
  {
   "fieldname": "account_balance",
   "fieldtype": "Currency",
   "label": "Account Balance",
   "read_only": 1,
   "default": "0"
  },
  {
   "fieldname": "column_break_19",
   "fieldtype": "Column Break"
  },
  {
   "fieldname": "total_investment",
   "fieldtype": "Currency",
   "label": "Total Investment",
   "read_only": 1,
   "default": "0"
  },
  {
   "fieldname": "last_transaction_date",
   "fieldtype": "Date",
   "label": "Last Transaction Date",
   "read_only": 1
  }
 ],
 "index_web_pages_for_search": 1,
 "links": [],
 "modified": "2025-11-07 10:00:00.000000",
 "modified_by": "Administrator",
 "module": "NextGen Farmers",
 "name": "Member",
 "naming_rule": "Expression",
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
  },
  {
   "create": 1,
   "email": 1,
   "export": 1,
   "print": 1,
   "read": 1,
   "report": 1,
   "role": "Cooperative Manager",
   "share": 1,
   "write": 1
  },
  {
   "email": 1,
   "export": 1,
   "print": 1,
   "read": 1,
   "role": "Member",
   "share": 0
  }
 ],
 "sort_field": "modified",
 "sort_order": "DESC",
 "states": [],
 "track_changes": 1
}
```

**Python Controller**:

**File**: `apps/nextgen_farmers/nextgen_farmers/nextgen_farmers/doctype/member/member.py`

```python
# Copyright (c) 2025, NextGen Farmers Hub and contributors
# For license information, please see license.txt

import frappe
from frappe.model.document import Document
from frappe.utils import nowdate, flt

class Member(Document):
    def validate(self):
        """Validate member data before save"""
        self.validate_unique_id()
        self.validate_phone_number()
        self.validate_email()
        self.calculate_totals()

    def validate_unique_id(self):
        """Ensure ID number is unique"""
        if self.id_number:
            existing = frappe.db.exists(
                "Member",
                {
                    "id_number": self.id_number,
                    "name": ["!=", self.name]
                }
            )
            if existing:
                frappe.throw(f"Member with ID Number {self.id_number} already exists")

    def validate_phone_number(self):
        """Validate phone number format"""
        if self.phone_number:
            # Remove spaces and special characters
            phone = self.phone_number.replace(" ", "").replace("-", "")

            # Ensure it's numeric
            if not phone.isdigit():
                frappe.throw("Phone number must contain only digits")

            # Check length (assuming Kenyan format: 10 digits)
            if len(phone) not in [10, 12, 13]:
                frappe.throw("Invalid phone number length")

            # Format: 0712345678 or +254712345678
            if phone.startswith("0"):
                # Convert to international format
                self.phone_number = f"+254{phone[1:]}"
            elif not phone.startswith("+"):
                self.phone_number = f"+{phone}"

    def validate_email(self):
        """Validate email format"""
        if self.email:
            import re
            email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
            if not re.match(email_pattern, self.email):
                frappe.throw("Invalid email format")

    def calculate_totals(self):
        """Calculate total shares and investment"""
        # Total shares from all share purchases
        total_shares = frappe.db.sql("""
            SELECT SUM(number_of_shares)
            FROM `tabShare Purchase`
            WHERE member = %s AND payment_status = 'Paid' AND docstatus = 1
        """, self.name)

        self.total_shares = flt(total_shares[0][0] if total_shares else 0)

        # Total investment
        total_investment = frappe.db.sql("""
            SELECT SUM(total_amount)
            FROM `tabShare Purchase`
            WHERE member = %s AND payment_status = 'Paid' AND docstatus = 1
        """, self.name)

        self.total_investment = flt(total_investment[0][0] if total_investment else 0)

        # Account balance from member account ledger
        balance = frappe.db.sql("""
            SELECT SUM(credit) - SUM(debit)
            FROM `tabMember Account`
            WHERE member = %s
        """, self.name)

        self.account_balance = flt(balance[0][0] if balance else 0)

    def create_user_account(self):
        """Create user account for member portal access"""
        if self.email and not frappe.db.exists("User", self.email):
            user = frappe.get_doc({
                "doctype": "User",
                "email": self.email,
                "first_name": self.member_name.split()[0],
                "last_name": " ".join(self.member_name.split()[1:]) if len(self.member_name.split()) > 1 else "",
                "phone": self.phone_number,
                "enabled": 1,
                "send_welcome_email": 1,
                "user_type": "Website User",
                "role_profile_name": "Member Portal User"
            })
            user.insert(ignore_permissions=True)

            frappe.msgprint(f"User account created for {self.email}")

    def send_welcome_sms(self):
        """Send welcome SMS to new member"""
        message = f"""
        Welcome to NextGen Farmers Hub, {self.member_name}!
        Your Member ID is {self.name}.
        Login at: https://nextgenfarmershub.com/member-portal
        Phone: {self.phone_number}
        """

        # TODO: Integrate with SMS provider
        # send_sms(self.phone_number, message)

    @frappe.whitelist()
    def get_share_summary(self):
        """Get member's share ownership summary"""
        shares = frappe.db.sql("""
            SELECT
                share_type,
                SUM(number_of_shares) as total_shares,
                SUM(total_amount) as total_amount
            FROM `tabShare Purchase`
            WHERE member = %s AND payment_status = 'Paid' AND docstatus = 1
            GROUP BY share_type
        """, self.name, as_dict=1)

        return shares

    @frappe.whitelist()
    def get_account_statement(self, from_date=None, to_date=None):
        """Get member account statement"""
        conditions = ["member = %s"]
        values = [self.name]

        if from_date:
            conditions.append("transaction_date >= %s")
            values.append(from_date)

        if to_date:
            conditions.append("transaction_date <= %s")
            values.append(to_date)

        statement = frappe.db.sql(f"""
            SELECT
                transaction_date,
                transaction_type,
                description,
                debit,
                credit,
                balance
            FROM `tabMember Account`
            WHERE {" AND ".join(conditions)}
            ORDER BY transaction_date ASC, creation ASC
        """, tuple(values), as_dict=1)

        return statement

    @frappe.whitelist()
    def get_crop_summary(self):
        """Get member's crop cycles summary"""
        crops = frappe.db.sql("""
            SELECT
                crop,
                COUNT(*) as total_cycles,
                SUM(CASE WHEN status = 'Active' THEN 1 ELSE 0 END) as active_cycles,
                SUM(actual_yield_kg) as total_yield,
                SUM(revenue) as total_revenue
            FROM `tabMember Crop Cycle`
            WHERE member = %s
            GROUP BY crop
        """, self.name, as_dict=1)

        return crops


# API Methods for Member Portal

@frappe.whitelist(allow_guest=False)
def get_member_dashboard():
    """Get dashboard data for logged-in member"""
    user = frappe.session.user

    # Get member linked to this user
    member = frappe.db.get_value("Member", {"email": user}, "name")

    if not member:
        frappe.throw("No member account found for this user")

    member_doc = frappe.get_doc("Member", member)

    return {
        "member": member_doc.as_dict(),
        "share_summary": member_doc.get_share_summary(),
        "crop_summary": member_doc.get_crop_summary(),
        "recent_transactions": member_doc.get_account_statement()[:10]
    }


@frappe.whitelist(allow_guest=False)
def update_member_profile(member, data):
    """Update member profile information"""
    member_doc = frappe.get_doc("Member", member)

    # Check permissions
    if frappe.session.user != member_doc.email:
        frappe.throw("You can only update your own profile")

    # Allow updating only certain fields
    allowed_fields = ["phone_number", "email", "member_photo"]

    for field in allowed_fields:
        if field in data:
            member_doc.set(field, data[field])

    member_doc.save(ignore_permissions=True)

    return {"message": "Profile updated successfully"}
```

**Acceptance Criteria**:
- [ ] Member DocType created with all fields
- [ ] Auto-naming works (MEM-00001, MEM-00002, etc.)
- [ ] Validation works (unique ID, phone format)
- [ ] Calculations work (total shares, balance)
- [ ] Can create test member
- [ ] User account creation works

---

#### TASK-004: Create Child DocType for Farm Locations
**Assigned to**: Gemini CLI
**Priority**: Medium
**Estimated Time**: 30 minutes

**Description**: Create child table for member farm locations

**JSON Definition**:

**File**: `apps/nextgen_farmers/nextgen_farmers/nextgen_farmers/doctype/member_farm_location/member_farm_location.json`

```json
{
 "actions": [],
 "creation": "2025-11-07 11:00:00.000000",
 "doctype": "DocType",
 "editable_grid": 1,
 "engine": "InnoDB",
 "field_order": [
  "location_name",
  "size_hectares",
  "column_break_3",
  "gps_coordinates",
  "soil_type",
  "section_break_6",
  "water_source",
  "notes"
 ],
 "fields": [
  {
   "columns": 3,
   "fieldname": "location_name",
   "fieldtype": "Data",
   "in_list_view": 1,
   "label": "Location Name",
   "reqd": 1
  },
  {
   "columns": 2,
   "fieldname": "size_hectares",
   "fieldtype": "Float",
   "in_list_view": 1,
   "label": "Size (Hectares)",
   "precision": "2",
   "reqd": 1
  },
  {
   "fieldname": "column_break_3",
   "fieldtype": "Column Break"
  },
  {
   "columns": 2,
   "fieldname": "gps_coordinates",
   "fieldtype": "Data",
   "in_list_view": 1,
   "label": "GPS Coordinates"
  },
  {
   "columns": 2,
   "fieldname": "soil_type",
   "fieldtype": "Select",
   "in_list_view": 1,
   "label": "Soil Type",
   "options": "Clay\nLoam\nSandy\nSilt\nPeat"
  },
  {
   "fieldname": "section_break_6",
   "fieldtype": "Section Break"
  },
  {
   "fieldname": "water_source",
   "fieldtype": "Select",
   "label": "Water Source",
   "options": "Rain-fed\nBorehole\nRiver\nWell\nIrrigation System\nOther"
  },
  {
   "fieldname": "notes",
   "fieldtype": "Small Text",
   "label": "Notes"
  }
 ],
 "index_web_pages_for_search": 1,
 "istable": 1,
 "links": [],
 "modified": "2025-11-07 11:00:00.000000",
 "modified_by": "Administrator",
 "module": "NextGen Farmers",
 "name": "Member Farm Location",
 "owner": "Administrator",
 "permissions": [],
 "sort_field": "modified",
 "sort_order": "DESC",
 "states": []
}
```

**Acceptance Criteria**:
- [ ] Child DocType created
- [ ] Can add farm locations to Member
- [ ] Total land hectares calculation works

---

### Phase 3 Tasks (Share Management & Paystack)

#### TASK-005: Create Share Type DocType
**Assigned to**: Claude CLI
**Priority**: Critical
**Estimated Time**: 30 minutes

**Command**:
```bash
bench --site nextgenfarmers.local create-doctype \
    --app nextgen_farmers \
    --module "NextGen Farmers" \
    "Share Type"
```

**JSON**: See detailed JSON in separate file (to keep this guide readable)

**Python Controller**:

```python
# File: share_type.py

from frappe.model.document import Document

class ShareType(Document):
    def validate(self):
        if self.minimum_shares > self.maximum_shares:
            frappe.throw("Minimum shares cannot be greater than maximum shares")

        if self.share_price <= 0:
            frappe.throw("Share price must be greater than zero")
```

---

#### TASK-006: Create Share Purchase DocType
**Assigned to**: Claude CLI
**Priority**: Critical
**Estimated Time**: 2 hours

**Description**: Create Share Purchase DocType with Paystack integration

This is the MOST IMPORTANT task. See detailed implementation in the PRD document.

**Key Files**:
1. `share_purchase.json` - DocType definition
2. `share_purchase.py` - Python controller with Paystack methods
3. `share_purchase.js` - Client-side JavaScript for payment flow

**Paystack Methods Required**:
- `initialize_paystack_payment()`
- `verify_paystack_payment(reference)`
- `create_member_account_entry()`
- `generate_share_certificate()`
- `send_confirmation_notification()`

**Acceptance Criteria**:
- [ ] DocType created
- [ ] Payment initialization works
- [ ] Paystack redirect works
- [ ] Webhook handler works
- [ ] Payment verification works
- [ ] Share certificate generated
- [ ] SMS/Email sent

---

#### TASK-007: Create Paystack Settings DocType
**Assigned to**: Gemini CLI
**Priority**: High
**Estimated Time**: 30 minutes

**Description**: Store Paystack API credentials

```json
{
  "doctype": "DocType",
  "name": "Paystack Settings",
  "module": "NextGen Farmers",
  "issingle": 1,
  "fields": [
    {
      "fieldname": "public_key",
      "fieldtype": "Data",
      "label": "Public Key",
      "reqd": 1
    },
    {
      "fieldname": "secret_key",
      "fieldtype": "Password",
      "label": "Secret Key",
      "reqd": 1
    },
    {
      "fieldname": "webhook_secret",
      "fieldtype": "Password",
      "label": "Webhook Secret"
    },
    {
      "fieldname": "test_mode",
      "fieldtype": "Check",
      "label": "Test Mode",
      "default": 1
    },
    {
      "fieldname": "enabled",
      "fieldtype": "Check",
      "label": "Enabled",
      "default": 1
    }
  ]
}
```

---

### Complete Task List for CLI Agents

#### Claude CLI Tasks (Primary Agent)

1. ✅ **TASK-001**: Create custom app structure
2. ✅ **TASK-003**: Create Member DocType
3. ✅ **TASK-005**: Create Share Type DocType
4. ✅ **TASK-006**: Create Share Purchase DocType + Paystack
5. ⏳ **TASK-009**: Create Member Account DocType
6. ⏳ **TASK-011**: Create Dividend Declaration DocType
7. ⏳ **TASK-013**: Extend Crop Cycle for members
8. ⏳ **TASK-015**: Create Resource Allocation DocType
9. ⏳ **TASK-017**: Create Produce Collection DocType
10. ⏳ **TASK-019**: Create Member Portal pages
11. ⏳ **TASK-021**: Write unit tests
12. ⏳ **TASK-023**: Deploy to production

#### Gemini CLI Tasks (Delegated)

1. ✅ **TASK-002**: Apply NextGen branding CSS
2. ✅ **TASK-004**: Create Farm Location child DocType
3. ✅ **TASK-007**: Create Paystack Settings
4. ⏳ **TASK-008**: Create share certificate PDF template
5. ⏳ **TASK-010**: Create Member Dashboard (frontend)
6. ⏳ **TASK-012**: Create Share Register report
7. ⏳ **TASK-014**: Create agriculture dashboards
8. ⏳ **TASK-016**: SMS integration setup
9. ⏳ **TASK-018**: Email templates
10. ⏳ **TASK-020**: Documentation
11. ⏳ **TASK-022**: User training materials

---

## Git Workflow

### Branch Strategy

```
main (production)
  ├── develop (integration)
  │    ├── feature/member-management
  │    ├── feature/share-purchase
  │    ├── feature/paystack-integration
  │    ├── feature/agriculture-module
  │    └── feature/member-portal
  └── hotfix/* (emergency fixes)
```

### Git Commands for Each Task

```bash
# Start new feature
git checkout develop
git pull origin develop
git checkout -b feature/task-name

# Make changes
# ... code implementation ...

# Commit with descriptive message
git add .
git commit -m "feat: Add Member DocType with validation

- Created Member DocType with auto-naming
- Added phone number and email validation
- Implemented share and balance calculations
- Added user account creation method

Closes #TASK-003"

# Push to remote
git push -u origin feature/task-name

# Create pull request on GitHub for review
```

### Commit Message Format

```
<type>: <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting, no code change
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

**Example**:
```
feat: Implement Paystack payment integration

- Add initialize_paystack_payment method
- Add verify_paystack_payment method
- Create webhook handler
- Add payment notification system

Closes #TASK-006
```

---

## Testing Procedures

### Unit Testing

**File**: `apps/nextgen_farmers/nextgen_farmers/nextgen_farmers/doctype/member/test_member.py`

```python
import frappe
import unittest

class TestMember(unittest.TestCase):
    def setUp(self):
        """Set up test data"""
        # Create test member
        if not frappe.db.exists("Member", "MEM-TEST-001"):
            self.member = frappe.get_doc({
                "doctype": "Member",
                "member_name": "Test Farmer",
                "id_number": "12345678",
                "phone_number": "0712345678",
                "email": "test@example.com",
                "membership_date": "2025-01-01",
                "membership_status": "Active"
            })
            self.member.insert()
        else:
            self.member = frappe.get_doc("Member", "MEM-TEST-001")

    def test_phone_number_validation(self):
        """Test phone number format conversion"""
        self.assertEqual(self.member.phone_number, "+254712345678")

    def test_unique_id_validation(self):
        """Test that duplicate ID numbers are rejected"""
        duplicate = frappe.get_doc({
            "doctype": "Member",
            "member_name": "Duplicate Farmer",
            "id_number": "12345678",  # Same as test member
            "phone_number": "0723456789",
            "email": "duplicate@example.com",
            "membership_date": "2025-01-01"
        })

        with self.assertRaises(frappe.ValidationError):
            duplicate.insert()

    def test_share_calculation(self):
        """Test total shares calculation"""
        # Create test share purchase
        share_purchase = frappe.get_doc({
            "doctype": "Share Purchase",
            "member": self.member.name,
            "share_type": "Ordinary Share",
            "number_of_shares": 10,
            "share_price": 1000,
            "payment_status": "Paid"
        })
        share_purchase.insert()
        share_purchase.submit()

        # Reload member and check total
        self.member.reload()
        self.assertEqual(self.member.total_shares, 10)
        self.assertEqual(self.member.total_investment, 10000)

    def tearDown(self):
        """Clean up test data"""
        frappe.db.rollback()
```

### Manual Testing Checklist

#### Member Management
- [ ] Create new member
- [ ] Verify auto-naming (MEM-00001)
- [ ] Test phone number validation
- [ ] Test email validation
- [ ] Test duplicate ID rejection
- [ ] Upload member photo
- [ ] Add farm locations
- [ ] View member dashboard

#### Share Purchase
- [ ] Create share type
- [ ] Initiate share purchase
- [ ] Redirect to Paystack
- [ ] Complete test payment
- [ ] Verify webhook reception
- [ ] Check payment status update
- [ ] Verify share certificate generation
- [ ] Check SMS/Email notification
- [ ] View share register

---

## Delegation Guidelines

### When to Delegate to Gemini CLI

Claude CLI should delegate to Gemini CLI for:

1. **Frontend Tasks**
   - CSS/styling work
   - HTML templates
   - JavaScript (non-critical)
   - UI/UX refinements

2. **Documentation**
   - User manuals
   - Training materials
   - API documentation
   - README files

3. **Simple DocTypes**
   - Child tables
   - Settings DocTypes (no complex logic)
   - Reference data (lists, options)

4. **Testing**
   - Manual test case documentation
   - Test data creation
   - QA checklists

### Communication Protocol

**Claude to Gemini**:
```
Task: TASK-002
Title: Apply NextGen Branding
Priority: High
Estimated Time: 1 hour

Description:
Create CSS file with NextGen Farmers Hub branding colors.
Primary: #f4511e (orange)
Secondary: #32373c (dark gray)

Files to create:
1. /apps/nextgen_farmers/nextgen_farmers/public/css/nextgen_theme.css

Requirements:
- Override Frappe primary colors
- Style buttons, navbar, links
- Ensure responsive design
- Test on all major pages

Acceptance Criteria:
✓ All buttons show orange color
✓ Navbar is dark gray
✓ Links are orange
✓ Consistent across pages

When complete:
- Commit with message: "style: Apply NextGen branding colors"
- Push to branch: feature/branding
- Report back with screenshot
```

**Gemini Response**:
```
Task: TASK-002
Status: COMPLETED ✓

Files Created:
- nextgen_theme.css (150 lines)

Changes:
- Added CSS variables for brand colors
- Styled buttons (primary, secondary)
- Styled navigation bar
- Styled links and form elements
- Added focus states

Git:
Branch: feature/branding
Commit: 7a3f2e1 "style: Apply NextGen branding colors"
Pushed: Yes

Screenshot: [attached]

Notes:
- Tested on Member List, Dashboard
- Responsive on mobile
- Compatible with Frappe v15

Ready for review.
```

---

## Troubleshooting Guide

### Common Issues

#### Issue 1: Import Error
```
Error: No module named 'nextgen_farmers'
```

**Solution**:
```bash
bench --site nextgenfarmers.local install-app nextgen_farmers
bench build --app nextgen_farmers
bench restart
```

#### Issue 2: Permission Denied
```
Error: PermissionError: [Errno 13] Permission denied
```

**Solution**:
```bash
# Check file ownership
ls -la apps/nextgen_farmers

# Fix permissions
sudo chown -R $USER:$USER apps/nextgen_farmers

# Or run with correct user
bench --site nextgenfarmers.local migrate
```

#### Issue 3: DocType Not Found
```
Error: DocType Member not found
```

**Solution**:
```bash
# Migrate database
bench --site nextgenfarmers.local migrate

# Clear cache
bench --site nextgenfarmers.local clear-cache

# Rebuild
bench build
```

#### Issue 4: Paystack Webhook Not Working
```
Error: Webhook signature verification failed
```

**Solution**:
```python
# Check webhook secret in Paystack Settings
# Verify signature calculation
# Check Paystack dashboard webhook logs
# Ensure site is accessible (not localhost)
# Use ngrok for local testing:
ngrok http 8000
# Update webhook URL in Paystack dashboard
```

---

## Quick Reference

### Bench Commands

```bash
# Create DocType
bench make-doctype "DocType Name" "nextgen_farmers"

# Migrate
bench --site nextgenfarmers.local migrate

# Clear cache
bench --site nextgenfarmers.local clear-cache

# Build assets
bench build --app nextgen_farmers

# Restart
bench restart

# Enter console
bench --site nextgenfarmers.local console

# Run tests
bench --site nextgenfarmers.local run-tests --app nextgen_farmers

# Backup
bench --site nextgenfarmers.local backup

# Restore
bench --site nextgenfarmers.local restore path/to/backup
```

### Python Console Commands

```python
# In bench console
frappe.init(site='nextgenfarmers.local')
frappe.connect()

# Get document
doc = frappe.get_doc("Member", "MEM-00001")

# Create document
new_member = frappe.get_doc({
    "doctype": "Member",
    "member_name": "John Doe",
    ...
})
new_member.insert()

# SQL query
result = frappe.db.sql("SELECT * FROM `tabMember` LIMIT 10", as_dict=1)

# Clear cache
frappe.clear_cache()
```

---

## Next Steps

After completing all tasks:

1. **Code Review**
   - Create pull request
   - Request review from senior developer
   - Address feedback

2. **User Acceptance Testing**
   - Demo to stakeholders
   - Gather feedback
   - Make adjustments

3. **Production Deployment**
   - Set up production server
   - Configure domain and SSL
   - Migrate data
   - Go live

4. **Post-Launch**
   - Monitor errors
   - User training
   - Support documentation
   - Continuous improvement

---

**End of CLI Agent Implementation Guide**
