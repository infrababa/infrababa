# Task Delegation Matrix
## Claude CLI ↔ Gemini CLI

**Project**: NextGen Farmers Hub ERPNext Customization
**Version**: 1.0
**Date**: 2025-11-07

---

## Quick Start for Human Operator

### Step 1: Give this to Claude CLI

```
You are the PRIMARY AGENT for implementing NextGen Farmers Hub ERPNext customization.

Read these documents in order:
1. PRODUCT_REQUIREMENTS_DOCUMENT.md
2. CLI_AGENT_IMPLEMENTATION_GUIDE.md
3. TASK_DELEGATION_MATRIX.md (this file)
4. NEXTCRM_BRANDING_GUIDE.md

Your mission:
- Implement all PRIMARY AGENT tasks
- Delegate SECONDARY AGENT tasks to Gemini CLI
- Push all code to GitHub after each task
- Report progress after each completed task

Start with TASK-001.
```

### Step 2: Claude CLI will delegate to Gemini CLI

Claude CLI will provide Gemini CLI with specific task instructions like:

```
Execute TASK-002: Apply NextGen Branding

Follow the specifications in CLI_AGENT_IMPLEMENTATION_GUIDE.md
section "TASK-002".

When complete, report back with:
- Files created
- Git commit hash
- Screenshot (if applicable)
```

---

## Task Assignment Matrix

| Task ID | Task Name | Agent | Priority | Time | Dependencies |
|---------|-----------|-------|----------|------|--------------|
| **PHASE 1: FOUNDATION** |
| TASK-001 | Create Custom App Structure | Claude CLI | Critical | 30min | None |
| TASK-002 | Apply NextGen Branding | Gemini CLI | High | 1hr | TASK-001 |
| **PHASE 2: MEMBER MANAGEMENT** |
| TASK-003 | Create Member DocType | Claude CLI | Critical | 1hr | TASK-001 |
| TASK-004 | Create Farm Location Child | Gemini CLI | Medium | 30min | TASK-003 |
| TASK-005 | Create Share Type DocType | Claude CLI | Critical | 30min | TASK-001 |
| TASK-006 | Create Share Purchase + Paystack | Claude CLI | Critical | 2hr | TASK-003, TASK-005 |
| TASK-007 | Create Paystack Settings | Gemini CLI | High | 30min | TASK-006 |
| TASK-008 | Create Share Certificate PDF | Gemini CLI | Medium | 1hr | TASK-006 |
| TASK-009 | Create Member Account DocType | Claude CLI | Critical | 1hr | TASK-003 |
| TASK-010 | Create Member Dashboard Frontend | Gemini CLI | High | 2hr | TASK-003, TASK-009 |
| **PHASE 3: FINANCIAL MANAGEMENT** |
| TASK-011 | Create Dividend Declaration | Claude CLI | High | 1hr | TASK-005, TASK-009 |
| TASK-012 | Create Share Register Report | Gemini CLI | Medium | 1hr | TASK-005, TASK-006 |
| **PHASE 4: AGRICULTURE MODULE** |
| TASK-013 | Extend Crop Cycle for Members | Claude CLI | Critical | 1.5hr | TASK-003 |
| TASK-014 | Create Agriculture Dashboards | Gemini CLI | Medium | 2hr | TASK-013 |
| TASK-015 | Create Resource Allocation | Claude CLI | High | 1hr | TASK-003, TASK-013 |
| TASK-016 | SMS Integration Setup | Gemini CLI | Medium | 1hr | TASK-006 |
| TASK-017 | Create Produce Collection | Claude CLI | High | 1hr | TASK-013 |
| TASK-018 | Email Templates | Gemini CLI | Low | 1hr | TASK-006, TASK-011 |
| **PHASE 5: MEMBER PORTAL** |
| TASK-019 | Create Member Portal Pages | Claude CLI | High | 3hr | TASK-010 |
| TASK-020 | Documentation | Gemini CLI | Medium | 2hr | All |
| **PHASE 6: TESTING & DEPLOYMENT** |
| TASK-021 | Write Unit Tests | Claude CLI | High | 2hr | All |
| TASK-022 | User Training Materials | Gemini CLI | Medium | 2hr | All |
| TASK-023 | Deploy to Production | Claude CLI | Critical | 2hr | All |

---

## Detailed Task Specifications

### PHASE 1: FOUNDATION

#### TASK-001: Create Custom App Structure
**Agent**: Claude CLI
**Status**: 🔴 Not Started

**Objective**: Initialize nextgen_farmers custom Frappe app

**Commands**:
```bash
cd frappe-bench
bench new-app nextgen_farmers
bench --site nextgenfarmers.local install-app nextgen_farmers
```

**Files to Create/Modify**:
1. `apps/nextgen_farmers/nextgen_farmers/hooks.py` - App configuration
2. `apps/nextgen_farmers/nextgen_farmers/modules.txt` - Add "NextGen Farmers" module
3. `apps/nextgen_farmers/README.md` - Basic documentation

**Git**:
```bash
git init
git add .
git commit -m "chore: Initialize nextgen_farmers custom app"
git branch -M main
git remote add origin [GitHub URL]
git push -u origin main
```

**Acceptance Criteria**:
- [ ] App created and installed
- [ ] hooks.py configured with app metadata
- [ ] Module "NextGen Farmers" added
- [ ] Git repository initialized
- [ ] Pushed to GitHub

**Report Back**:
```
TASK-001: COMPLETED ✓
- App created: nextgen_farmers
- Module: NextGen Farmers
- Git: Pushed to main branch
- Commit: a1b2c3d "chore: Initialize nextgen_farmers custom app"
- Ready for TASK-002 (delegate to Gemini)
```

---

#### TASK-002: Apply NextGen Branding
**Agent**: Gemini CLI (delegated by Claude)
**Status**: 🔴 Not Started

**Objective**: Apply NextGen Farmers Hub branding colors

**Claude Delegation Message**:
```
TASK-002: Apply NextGen Branding
Agent: Gemini CLI
Priority: High
Estimated: 1 hour

Objective:
Create CSS file with NextGen Farmers Hub brand colors and styling.

Brand Colors:
- Primary Orange: #f4511e
- Secondary Gray: #32373c
- White: #ffffff
- Black: #000000

Files to Create:
1. apps/nextgen_farmers/nextgen_farmers/public/css/nextgen_theme.css
   (See CLI_AGENT_IMPLEMENTATION_GUIDE.md TASK-002 for complete CSS)

2. apps/nextgen_farmers/nextgen_farmers/public/js/member_portal.js
   (See guide for JavaScript template)

Requirements:
- Override Frappe --primary variable
- Style buttons (primary = orange)
- Style navbar (background = dark gray)
- Style links (color = orange)
- Add hover states
- Ensure responsive design

Testing:
- View any page (should see orange buttons)
- View navbar (should be dark gray)
- Click links (should be orange)
- Test on mobile viewport

Git:
Branch: feature/branding
Commit: "style: Apply NextGen Farmers Hub branding"
Push to GitHub

Report back when complete with:
- Files created
- Commit hash
- Screenshot of styled page
```

**Gemini Response Expected**:
```
TASK-002: COMPLETED ✓

Files Created:
✓ nextgen_theme.css (180 lines)
✓ member_portal.js (50 lines)

Changes Applied:
✓ CSS variables for brand colors
✓ Button styling (primary, secondary, hover)
✓ Navbar styling (dark gray background)
✓ Link styling (orange color)
✓ Form focus states (orange border)
✓ Responsive breakpoints

Git:
Branch: feature/branding
Commit: 7f3a9e2 "style: Apply NextGen Farmers Hub branding"
Pushed: Yes

Testing:
✓ Tested on Member List page
✓ Tested on Settings page
✓ Tested on mobile (375px width)
✓ Verified color contrast (WCAG AA compliant)

Screenshots:
[Attach: navbar-styled.png, buttons-styled.png]

Ready for merge to develop.
```

**Claude CLI Next Action**:
```
TASK-002: Verified ✓
- Reviewed Gemini's CSS code
- Tested locally
- Approved for merge

Actions:
git checkout develop
git merge feature/branding
git push origin develop

Moving to TASK-003 (Claude CLI primary task)
```

---

### PHASE 2: MEMBER MANAGEMENT

#### TASK-003: Create Member DocType
**Agent**: Claude CLI
**Status**: 🔴 Not Started

**Objective**: Create core Member DocType with validation and calculations

**Pre-requisites**: TASK-001 completed

**Steps**:

1. **Create DocType Structure**
```bash
cd apps/nextgen_farmers
bench --site nextgenfarmers.local create-doctype \
    --app nextgen_farmers \
    --module "NextGen Farmers" \
    Member
```

2. **Update JSON Definition**
- Copy JSON from CLI_AGENT_IMPLEMENTATION_GUIDE.md TASK-003
- Save to `doctype/member/member.json`

3. **Write Python Controller**
- Create `member.py` with:
  - `validate()` method
  - `validate_unique_id()` method
  - `validate_phone_number()` method
  - `validate_email()` method
  - `calculate_totals()` method
  - `create_user_account()` method
  - `get_share_summary()` API method
  - `get_account_statement()` API method
  - `get_crop_summary()` API method

4. **Write Unit Tests**
```python
# File: test_member.py
# See CLI_AGENT_IMPLEMENTATION_GUIDE.md for test code
```

5. **Migrate Database**
```bash
bench --site nextgenfarmers.local migrate
bench --site nextgenfarmers.local clear-cache
```

6. **Manual Testing**
- Create test member: "John Kamau"
- Verify auto-naming: MEM-00001
- Test phone validation: 0712345678 → +254712345678
- Test unique ID rejection
- View in desk

7. **Git Commit**
```bash
git checkout -b feature/member-doctype
git add .
git commit -m "feat: Add Member DocType with validation

- Created Member DocType with auto-naming (MEM-#####)
- Added phone number validation (Kenyan format)
- Added email validation
- Added unique ID number validation
- Implemented share and balance calculations
- Created user account creation method
- Added API methods for member portal
- Added unit tests

Closes #TASK-003"
git push -u origin feature/member-doctype
```

**Acceptance Criteria**:
- [ ] Member DocType created
- [ ] Auto-naming works (MEM-00001, MEM-00002)
- [ ] Phone validation: 0712345678 → +254712345678
- [ ] Email validation works
- [ ] Duplicate ID rejected
- [ ] Calculations work (total_shares, account_balance)
- [ ] Unit tests pass
- [ ] Pushed to GitHub

**Report Back**:
```
TASK-003: COMPLETED ✓

Member DocType Implementation:
✓ DocType created with 20+ fields
✓ Auto-naming: MEM-##### format
✓ Phone validation: Kenyan format (+254...)
✓ Email validation: regex pattern
✓ Unique ID validation
✓ Financial calculations (shares, balance, investment)
✓ API methods for portal

Testing:
✓ Created test member: MEM-00001
✓ Phone: 0712345678 → +254712345678
✓ Duplicate ID: Correctly rejected
✓ Unit tests: 4/4 passed

Git:
Branch: feature/member-doctype
Commit: 9a3f7e1 "feat: Add Member DocType with validation"
Pushed: Yes

Files:
- member.json (350 lines)
- member.py (280 lines)
- test_member.py (120 lines)

Next: TASK-004 (delegate to Gemini)
```

---

#### TASK-004: Create Farm Location Child Table
**Agent**: Gemini CLI (delegated by Claude)
**Status**: 🔴 Not Started

**Claude Delegation**:
```
TASK-004: Create Farm Location Child Table
Agent: Gemini CLI
Priority: Medium
Estimated: 30 minutes

Objective:
Create child table for Member's farm locations

Pre-requisite: TASK-003 completed

Files to Create:
1. member_farm_location/member_farm_location.json
   (See CLI_AGENT_IMPLEMENTATION_GUIDE.md for JSON)

Fields Required:
- location_name (Data, required, in_list_view)
- size_hectares (Float, required, in_list_view)
- gps_coordinates (Data, in_list_view)
- soil_type (Select: Clay/Loam/Sandy/Silt/Peat, in_list_view)
- water_source (Select: Rain-fed/Borehole/River/etc.)
- notes (Small Text)

DocType Properties:
- istable: 1
- module: "NextGen Farmers"
- editable_grid: 1

Testing:
1. Open Member MEM-00001
2. Add farm location:
   - Name: "Kamau Farm - Field A"
   - Size: 5.5 hectares
   - GPS: "-1.2921, 36.8219"
   - Soil: Loam
   - Water: Borehole
3. Save and verify

Git:
Branch: feature/member-doctype (same branch as TASK-003)
Commit: "feat: Add Member Farm Location child table"

Report back with screenshot of added location.
```

**Expected Result**:
```
TASK-004: COMPLETED ✓

DocType Created:
✓ Member Farm Location (child table)
✓ 7 fields configured
✓ In-list-view columns set

Testing:
✓ Added to Member MEM-00001
✓ Farm location saved: "Kamau Farm - Field A"
✓ Size: 5.5 hectares
✓ Grid view works

Git:
Branch: feature/member-doctype
Commit: b4f2d9a "feat: Add Member Farm Location child table"

Screenshot: [member-farm-location.png]

Ready for TASK-003 branch merge.
```

---

### PHASE 2 (Continued): SHARE MANAGEMENT

#### TASK-005: Create Share Type DocType
**Agent**: Claude CLI
**Status**: 🔴 Not Started

**Quick Spec**:
- DocType: Share Type
- Fields: share_type_name, share_price, minimum_shares, maximum_shares, description, active
- Validation: min ≤ max, price > 0
- Sample data: "Ordinary Share" @ KES 1,000 (min:1, max:1000)

**Time**: 30 minutes

---

#### TASK-006: Create Share Purchase + Paystack Integration
**Agent**: Claude CLI
**Status**: 🔴 Not Started
**Priority**: 🔥 CRITICAL

**This is the MOST IMPORTANT task.**

**Objective**: Enable members to purchase shares online via Paystack

**Components**:
1. Share Purchase DocType
2. Paystack API integration
3. Payment initialization
4. Webhook handler
5. Payment verification
6. Share certificate generation
7. Notifications (SMS/Email)

**Files to Create**:
1. `share_purchase/share_purchase.json` - DocType definition
2. `share_purchase/share_purchase.py` - Python controller
3. `share_purchase/share_purchase.js` - Client-side JavaScript
4. `api/paystack.py` - Paystack API wrapper
5. `templates/share_certificate.html` - Certificate template

**Key Methods**:
```python
class SharePurchase(Document):
    def initialize_paystack_payment(self):
        """Returns authorization_url for redirect"""

    def verify_paystack_payment(self, reference):
        """Verify payment status with Paystack"""

    def create_member_account_entry(self):
        """Record in member's account ledger"""

    def generate_share_certificate(self):
        """Generate PDF certificate"""

    def send_confirmation_notification(self):
        """Send SMS and email"""

@frappe.whitelist(allow_guest=True)
def paystack_webhook():
    """Handle Paystack callbacks"""
```

**Paystack Integration Steps**:

1. **Get Paystack Account**
   - Sign up at paystack.com
   - Get test keys (public + secret)

2. **Configure Webhook**
   - URL: https://yoursite.com/api/method/nextgen_farmers.api.paystack.webhook
   - Events: charge.success

3. **Test Flow**:
   - Create Share Purchase
   - Click "Pay with Paystack"
   - Redirect to Paystack
   - Complete test payment (card: 4084084084084081)
   - Webhook triggers
   - Status updates to "Paid"
   - Certificate generated
   - Notification sent

**Acceptance Criteria**:
- [ ] Share Purchase DocType created
- [ ] Paystack initialization works
- [ ] Redirect to Paystack works
- [ ] Test payment completes
- [ ] Webhook received
- [ ] Payment verified
- [ ] Status updated
- [ ] Certificate generated (PDF)
- [ ] SMS sent
- [ ] Email sent
- [ ] Member shares updated
- [ ] Account balance updated

**Time Estimate**: 2-3 hours

**Report Template**:
```
TASK-006: COMPLETED ✓

Share Purchase + Paystack Integration:
✓ DocType created (15 fields)
✓ Paystack API integration
✓ Payment initialization method
✓ Payment verification method
✓ Webhook handler (signature verified)
✓ Share certificate generation
✓ SMS notification
✓ Email notification

Testing:
✓ Created test share purchase: SP-00001
✓ Member: MEM-00001
✓ Shares: 10 @ KES 1,000 = KES 10,000
✓ Paystack redirect: Success
✓ Test payment: Card 4084... Success
✓ Webhook received: ✓
✓ Payment verified: ✓
✓ Status updated: Paid
✓ Certificate: CERT-SP-00001.pdf generated
✓ SMS sent to +254712345678
✓ Email sent to test@example.com
✓ Member shares: 0 → 10
✓ Member investment: KES 0 → KES 10,000

Git:
Branch: feature/paystack-integration
Commits: 5 commits
  - feat: Add Share Purchase DocType
  - feat: Add Paystack API integration
  - feat: Add payment verification
  - feat: Add certificate generation
  - feat: Add notifications
Main commit: c5f8a2b

Files:
- share_purchase.json (400 lines)
- share_purchase.py (350 lines)
- share_purchase.js (120 lines)
- paystack.py (200 lines)
- share_certificate.html (80 lines)

Screenshots:
[payment-flow.png, certificate.pdf, sms-screenshot.png]

Ready for production testing.
CRITICAL: Update webhook URL when deployed!
```

---

#### TASK-007: Create Paystack Settings
**Agent**: Gemini CLI
**Status**: 🔴 Not Started

**Quick Delegation**:
```
Create Paystack Settings single DocType
Fields: public_key, secret_key, webhook_secret, test_mode, enabled
See CLI guide for JSON
Time: 30 min
```

---

### PHASE 3: FINANCIAL MANAGEMENT

#### TASK-009: Create Member Account DocType
**Agent**: Claude CLI
**Status**: 🔴 Not Started

**Objective**: Create ledger for all member transactions

**DocType**: Member Account (like a bank statement)

**Fields**:
- member (Link: Member)
- transaction_date (Date)
- transaction_type (Select: Share Purchase, Resource Purchase, Produce Sale, Dividend, Deposit, Withdrawal)
- description (Text)
- debit (Currency)
- credit (Currency)
- balance (Currency, calculated running balance)
- reference_doctype (Data)
- reference_document (Dynamic Link)

**Features**:
- Auto-create entry when Share Purchase is submitted
- Running balance calculation
- Account statement report
- Transaction history

**Time**: 1 hour

---

#### TASK-011: Create Dividend Declaration
**Agent**: Claude CLI
**Status**: 🔴 Not Started

**Objective**: Calculate and distribute dividends to members

**DocType**: Dividend Declaration

**Fields**:
- dividend_year (Data: e.g., "2025")
- dividend_rate (Percent: e.g., 10%)
- total_dividend_pool (Currency)
- declaration_date (Date)
- payment_date (Date)
- status (Select: Draft, Declared, Paid)
- dividend_entries (Table: Member, Shares, Amount)

**Methods**:
```python
def calculate_dividends(self):
    """Auto-populate dividend entries based on share ownership"""

def process_payments(self):
    """Create Member Account entries for all dividend payments"""
```

**Time**: 1 hour

---

### PHASE 4: AGRICULTURE MODULE

#### TASK-013: Extend Crop Cycle for Members
**Agent**: Claude CLI
**Status**: 🔴 Not Started

**Objective**: Link crop cycles to members and calculate profitability

**Approach**: Extend existing Crop Cycle DocType with custom fields

**Custom Fields to Add**:
```python
custom_fields = {
    "Crop Cycle": [
        {
            "fieldname": "member",
            "fieldtype": "Link",
            "options": "Member",
            "label": "Member",
            "insert_after": "title"
        },
        {
            "fieldname": "farm_location",
            "fieldtype": "Link",
            "options": "Member Farm Location",
            "label": "Farm Location",
            "insert_after": "member"
        },
        {
            "fieldname": "expected_yield_kg",
            "fieldtype": "Float",
            "label": "Expected Yield (KG)",
            "insert_after": "harvest_date"
        },
        {
            "fieldname": "actual_yield_kg",
            "fieldtype": "Float",
            "label": "Actual Yield (KG)",
            "insert_after": "expected_yield_kg"
        },
        {
            "fieldname": "revenue",
            "fieldtype": "Currency",
            "label": "Revenue",
            "read_only": 1
        },
        {
            "fieldname": "profit",
            "fieldtype": "Currency",
            "label": "Profit",
            "read_only": 1
        }
    ]
}
```

**File**: `fixtures/custom_fields.json`

**Time**: 1.5 hours

---

#### TASK-015: Create Resource Allocation
**Agent**: Claude CLI
**Status**: 🔴 Not Started

**Objective**: Track distribution of inputs (fertilizer, seeds) to members

**DocType**: Resource Allocation

**Fields**:
- member (Link)
- allocation_date
- resource_type (Select: Fertilizer, Seed, Pesticide)
- item (Link: Item)
- quantity
- unit_price
- total_cost (calculated)
- payment_method (Select: Account Deduction, Cash, Credit)
- linked_crop_cycle (Link)
- delivery_status (Select: Pending, Delivered)

**Integration**: Auto-create Member Account debit entry

**Time**: 1 hour

---

#### TASK-017: Create Produce Collection
**Agent**: Claude CLI
**Status**: 🔴 Not Started

**Objective**: Record harvest collection from members

**DocType**: Produce Collection

**Fields**:
- member
- collection_date
- crop_cycle (Link)
- crop
- quantity_kg
- quality_grade (Select: Grade A, B, C)
- price_per_kg
- total_value (calculated)
- payment_status (Select: Pending, Paid)
- warehouse
- moisture_content (Percent)
- remarks

**Integration**:
- Create Stock Entry (Frappe)
- Create Member Account credit entry

**Time**: 1 hour

---

### PHASE 5: MEMBER PORTAL

#### TASK-019: Create Member Portal Pages
**Agent**: Claude CLI
**Status**: 🔴 Not Started

**Objective**: Build web portal for members

**Pages to Create**:

1. **Member Dashboard** (`/member-portal`)
   - Total shares
   - Account balance
   - Active crop cycles
   - Recent transactions
   - Quick actions

2. **Buy Shares** (`/buy-shares`)
   - Share type selection
   - Quantity input
   - Total calculation
   - Paystack payment button

3. **Account Statement** (`/account-statement`)
   - Date filter
   - Transaction list
   - Download PDF

4. **My Crops** (`/my-crops`)
   - Active crop cycles
   - Expected vs actual yields
   - Performance charts

5. **My Shares** (`/my-shares`)
   - Share ownership breakdown
   - Certificate downloads
   - Dividend history

**Authentication**: Frappe website user authentication

**Time**: 3 hours

---

### PHASE 6: TESTING & DEPLOYMENT

#### TASK-021: Write Unit Tests
**Agent**: Claude CLI
**Status**: 🔴 Not Started

**Test Files**:
1. `test_member.py` - Member DocType tests
2. `test_share_purchase.py` - Share purchase and Paystack
3. `test_member_account.py` - Account ledger
4. `test_dividend.py` - Dividend calculations
5. `test_crop_cycle.py` - Agriculture integration

**Coverage Target**: >80%

**Time**: 2 hours

---

#### TASK-023: Deploy to Production
**Agent**: Claude CLI
**Status**: 🔴 Not Started

**Server Setup**:
1. Ubuntu 20.04 LTS server
2. Install ERPNext production setup
3. Configure domain and SSL
4. Install custom app
5. Migrate database
6. Configure Paystack (live keys)
7. Test all features
8. Go live

**Time**: 2 hours

---

## Progress Tracking

### Overall Progress

**Total Tasks**: 23
**Completed**: 0
**In Progress**: 0
**Not Started**: 23

**Progress**: ▱▱▱▱▱▱▱▱▱▱ 0%

### By Agent

**Claude CLI Tasks**: 13
- Completed: 0
- Remaining: 13

**Gemini CLI Tasks**: 10
- Completed: 0
- Remaining: 10

### By Phase

- **Phase 1 (Foundation)**: 0/2 (0%)
- **Phase 2 (Member Mgmt)**: 0/8 (0%)
- **Phase 3 (Financial)**: 0/2 (0%)
- **Phase 4 (Agriculture)**: 0/5 (0%)
- **Phase 5 (Portal)**: 0/2 (0%)
- **Phase 6 (Testing)**: 0/4 (0%)

---

## GitHub Integration

### Repository Structure

```
nextgen-farmers-hub-erp/
├── README.md
├── docs/
│   ├── PRODUCT_REQUIREMENTS_DOCUMENT.md
│   ├── CLI_AGENT_IMPLEMENTATION_GUIDE.md
│   ├── TASK_DELEGATION_MATRIX.md
│   ├── NEXTCRM_BRANDING_GUIDE.md
│   └── USER_MANUAL.md
├── apps/
│   └── nextgen_farmers/
│       └── (Frappe app)
└── .github/
    ├── workflows/
    │   ├── tests.yml
    │   └── deploy.yml
    └── PULL_REQUEST_TEMPLATE.md
```

### Branch Protection

**Main Branch**:
- Require pull request reviews
- Require status checks to pass
- No direct commits

**Develop Branch**:
- Integration branch
- Require status checks

**Feature Branches**:
- Naming: `feature/task-name`
- Must pass CI tests
- Require code review

### Pull Request Template

```markdown
## Task
- Task ID: TASK-XXX
- Task Name: [Name]
- Agent: [Claude/Gemini]

## Description
[Brief description of changes]

## Changes
- [ ] New DocType created
- [ ] API methods added
- [ ] Tests written
- [ ] Documentation updated

## Testing
- [ ] Unit tests pass
- [ ] Manual testing complete
- [ ] Screenshots attached

## Checklist
- [ ] Code follows style guide
- [ ] No console errors
- [ ] Migrations successful
- [ ] Documentation complete

## Screenshots
[Attach screenshots]

## Additional Notes
[Any notes for reviewers]
```

---

## Communication Protocol

### Daily Standup (Automated)

**Claude CLI** reports at end of each task:

```
Daily Progress Report - [Date]

Completed Today:
✓ TASK-003: Member DocType (1.5hr actual vs 1hr estimated)
✓ TASK-005: Share Type DocType (0.5hr actual vs 0.5hr estimated)

In Progress:
⏳ TASK-006: Paystack Integration (60% complete, 1hr remaining)

Blocked:
- None

Tomorrow's Plan:
- Complete TASK-006
- Start TASK-009 (Member Account)
- Delegate TASK-010 to Gemini

Total Progress: 3/23 tasks (13%)
```

### Error Reporting

When error occurs:

```
ERROR REPORT - TASK-006

Error:
PermissionError: [Errno 13] Permission denied: 'share_purchase.py'

Context:
- Attempting to create Share Purchase DocType
- Error on file write operation

Troubleshooting Attempted:
1. Checked file permissions: drwxr-xr-x
2. Checked user: running as frappe user
3. Tried sudo chown

Resolution Needed:
Human intervention required to fix file permissions

Workaround:
Temporarily skipped, moving to TASK-007

Status: BLOCKED
```

---

## Success Criteria

### Definition of Done (per task)

A task is considered "DONE" when:

1. ✅ **Code Complete**
   - All files created
   - All methods implemented
   - No syntax errors

2. ✅ **Tests Pass**
   - Unit tests written
   - All tests pass
   - Code coverage >80%

3. ✅ **Manual Testing**
   - Feature tested manually
   - Expected behavior confirmed
   - Edge cases tested

4. ✅ **Documentation**
   - Code documented (docstrings)
   - README updated
   - User guide updated (if user-facing)

5. ✅ **Git**
   - Code committed
   - Pushed to GitHub
   - Pull request created
   - Review requested

6. ✅ **Report**
   - Progress report submitted
   - Screenshots attached
   - Next steps identified

---

## Final Deliverables

### At Project Completion

**Claude CLI** will deliver:

1. **Codebase**
   - Complete nextgen_farmers app
   - All 23 tasks implemented
   - Tests passing
   - Documentation complete

2. **GitHub Repository**
   - All code committed
   - Proper branch structure
   - CI/CD configured

3. **Production Deployment**
   - Live server running
   - Domain configured
   - SSL enabled
   - Backups configured

4. **Documentation Package**
   - Technical documentation
   - User manual
   - Admin guide
   - Training videos

5. **Handover Report**
   - Implementation summary
   - Known issues
   - Future enhancements
   - Maintenance guide

---

**END OF TASK DELEGATION MATRIX**

*Ready for Claude CLI to begin implementation.*
*Start with TASK-001.*
