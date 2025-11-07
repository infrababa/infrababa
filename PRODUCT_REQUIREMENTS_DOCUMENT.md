# NextGen Farmers Hub - ERPNext Customization
## Product Requirements Document (PRD)

**Project**: NextGen Farmers Hub CRM Platform
**Version**: 1.0
**Date**: 2025-11-07
**Product Designer**: Senior Product Design Team
**Status**: Ready for Implementation

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Project Vision & Goals](#project-vision--goals)
3. [System Architecture](#system-architecture)
4. [User Personas](#user-personas)
5. [Feature Requirements](#feature-requirements)
6. [Module Customizations](#module-customizations)
7. [Payment Integration (Paystack)](#payment-integration-paystack)
8. [Branding & UI/UX](#branding--uiux)
9. [Technical Stack](#technical-stack)
10. [Implementation Phases](#implementation-phases)
11. [Success Metrics](#success-metrics)
12. [Risk Assessment](#risk-assessment)

---

## Executive Summary

NextGen Farmers Hub is a farming cooperative requiring a comprehensive ERP system to manage:
- **Member farmers** and their agricultural activities
- **Cooperative share management** with online payments
- **Crop production tracking** from planting to harvest
- **Inventory management** for inputs and produce
- **Financial operations** including member accounts and transactions
- **Communication** between cooperative and members

This document outlines the complete customization of ERPNext to meet these needs, branded with NextGen Farmers Hub's identity.

---

## Project Vision & Goals

### Vision
Create a unified digital platform where NextGen Farmers Hub members can:
- Track their farming operations
- Purchase cooperative shares online
- Access agricultural resources
- Collaborate with fellow farmers
- Manage their accounts and transactions

### Primary Goals

1. **Member Empowerment**
   - Self-service portal for farmers
   - Real-time access to cooperative information
   - Transparent share ownership and dividends

2. **Operational Efficiency**
   - Automate cooperative management
   - Reduce manual paperwork
   - Centralize data and reporting

3. **Financial Inclusion**
   - Online payment integration (Paystack)
   - Digital share certificates
   - Automated dividend calculations

4. **Agricultural Excellence**
   - Data-driven farming decisions
   - Best practice sharing
   - Yield optimization through analytics

---

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     NextGen Farmers Hub                      │
│                   ERPNext Custom Platform                    │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
   ┌────▼────┐         ┌────▼────┐        ┌────▼────┐
   │  Member │         │ Coop    │        │  Public │
   │  Portal │         │ Admin   │        │ Website │
   └─────────┘         └─────────┘        └─────────┘
        │                   │                   │
        └───────────────────┼───────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
   ┌────▼─────┐       ┌─────▼────┐       ┌─────▼────┐
   │ Agriculture│      │ Finance  │       │ CRM/Sales│
   │  Module    │      │ & Shares │       │  Module  │
   └────────────┘      └──────────┘       └──────────┘
                            │
                       ┌────▼────┐
                       │ Paystack│
                       │   API   │
                       └─────────┘
```

### Technology Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Frappe Framework (Vue.js components) |
| **Backend** | Python (Frappe/ERPNext) |
| **Database** | MariaDB/MySQL |
| **Payment Gateway** | Paystack API |
| **Telephony** | FreePBX/Asterisk (optional) |
| **Hosting** | VPS/Cloud (DigitalOcean, AWS, etc.) |
| **Version Control** | Git/GitHub |

---

## User Personas

### Persona 1: **Member Farmer (John Kamau)**
- **Age**: 42
- **Farm Size**: 5 hectares
- **Tech Literacy**: Moderate (smartphone user)
- **Goals**:
  - Track his crop cycles
  - Purchase cooperative shares
  - Access farming resources (fertilizer, seeds)
  - View his account balance and dividends
- **Pain Points**:
  - Manual paperwork is time-consuming
  - Unclear share ownership status
  - Delayed access to cooperative information

### Persona 2: **Cooperative Manager (Grace Wanjiku)**
- **Age**: 38
- **Role**: Operations Manager
- **Tech Literacy**: High
- **Goals**:
  - Manage all member farmers
  - Track cooperative finances
  - Generate reports for board meetings
  - Coordinate bulk purchases
  - Distribute dividends
- **Pain Points**:
  - Excel spreadsheets are error-prone
  - Manual dividend calculations take days
  - Difficult to get real-time data

### Persona 3: **Board Member (David Ochieng)**
- **Age**: 55
- **Role**: Board Treasurer
- **Tech Literacy**: Moderate
- **Goals**:
  - Monitor cooperative financial health
  - Review member contributions
  - Approve major expenses
  - Access reports on mobile
- **Pain Points**:
  - Delayed financial reports
  - Lack of transparency
  - Difficult to verify data accuracy

### Persona 4: **Field Officer (Peter Mwangi)**
- **Age**: 30
- **Role**: Agricultural Extension Officer
- **Tech Literacy**: High
- **Goals**:
  - Visit member farms
  - Log farm activities and observations
  - Report on crop health and diseases
  - Provide technical advice
- **Pain Points**:
  - No mobile access to farmer data
  - Cannot update records in the field
  - Manual reporting is slow

---

## Feature Requirements

### 1. Member Management

#### 1.1 Member Registration
- **MUS-001**: System shall capture member details (name, ID, phone, email, location)
- **MUS-002**: System shall assign unique member number
- **MUS-003**: System shall support profile photo upload
- **MUS-004**: System shall link member to farm location(s)
- **MUS-005**: System shall track membership status (Active, Suspended, Exited)

#### 1.2 Member Portal
- **MUP-001**: Members shall login with phone number/email and password
- **MUP-002**: Members shall view their dashboard with key metrics
- **MUP-003**: Members shall view their share ownership
- **MUP-004**: Members shall view their account statement
- **MUP-005**: Members shall view their farm records
- **MUP-006**: Members shall update contact information
- **MUP-007**: Members shall receive notifications (SMS/Email)

### 2. Share Management System

#### 2.1 Share Purchase
- **SHP-001**: System shall define share types (Ordinary, Preference)
- **SHP-002**: System shall set share price and minimum/maximum limits
- **SHP-003**: Members shall purchase shares online via Paystack
- **SHP-004**: System shall generate digital share certificate
- **SHP-005**: System shall send confirmation SMS/Email after purchase
- **SHP-006**: System shall update member share balance in real-time
- **SHP-007**: System shall track payment status (Pending, Paid, Failed)

#### 2.2 Share Tracking
- **SHT-001**: System shall maintain share register
- **SHT-002**: System shall calculate total shares per member
- **SHT-003**: System shall calculate member ownership percentage
- **SHT-004**: System shall track share purchase history
- **SHT-005**: System shall support share transfer between members

#### 2.3 Dividend Management
- **DIV-001**: System shall calculate dividends based on share ownership
- **DIV-002**: System shall support different dividend rates
- **DIV-003**: System shall generate dividend vouchers
- **DIV-004**: System shall process dividend payments (M-Pesa/Bank)
- **DIV-005**: System shall track dividend history

### 3. Agriculture Management

#### 3.1 Crop Cycle Tracking
- **AGR-001**: System shall create crop cycles per member/field
- **AGR-002**: System shall track planting dates and expected harvest
- **AGR-003**: System shall record actual vs expected yields
- **AGR-004**: System shall calculate cost per crop cycle
- **AGR-005**: System shall track crop cycle status (Planned, Active, Harvested)

#### 3.2 Farm Resources
- **AGR-006**: System shall maintain catalog of seeds, fertilizers, pesticides
- **AGR-007**: System shall track inventory of farm inputs
- **AGR-008**: System shall support bulk purchase by cooperative
- **AGR-009**: System shall allocate resources to members
- **AGR-010**: System shall track resource usage per crop cycle

#### 3.3 Soil & Water Management
- **AGR-011**: System shall record soil analysis results
- **AGR-012**: System shall record water quality tests
- **AGR-013**: System shall recommend fertilizer based on soil data
- **AGR-014**: System shall track irrigation schedules

#### 3.4 Disease & Pest Management
- **AGR-015**: System shall maintain disease catalog
- **AGR-016**: System shall log disease outbreaks
- **AGR-017**: System shall alert members of nearby outbreaks
- **AGR-018**: System shall track treatment effectiveness

### 4. Inventory Management

#### 4.1 Input Inventory
- **INV-001**: System shall track fertilizer stock levels
- **INV-002**: System shall track seed inventory
- **INV-003**: System shall track pesticide inventory
- **INV-004**: System shall alert on low stock
- **INV-005**: System shall support batch tracking

#### 4.2 Produce Inventory
- **INV-006**: System shall receive harvested produce from members
- **INV-007**: System shall track produce quality grades
- **INV-008**: System shall manage warehouse locations
- **INV-009**: System shall track produce sales
- **INV-010**: System shall calculate member payments from sales

### 5. Financial Management

#### 5.1 Member Accounts
- **FIN-001**: System shall maintain account for each member
- **FIN-002**: System shall record share purchases as credit
- **FIN-003**: System shall record resource purchases as debit
- **FIN-004**: System shall calculate running balance
- **FIN-005**: System shall support account top-up (deposits)
- **FIN-006**: System shall generate account statements

#### 5.2 Cooperative Finances
- **FIN-007**: System shall track all cooperative income
- **FIN-008**: System shall track all cooperative expenses
- **FIN-009**: System shall generate profit & loss statements
- **FIN-010**: System shall generate balance sheet
- **FIN-011**: System shall support budgeting
- **FIN-012**: System shall track against budget

#### 5.3 Payment Processing
- **FIN-013**: System shall integrate Paystack for online payments
- **FIN-014**: System shall support M-Pesa payments
- **FIN-015**: System shall support bank transfers
- **FIN-016**: System shall reconcile payments automatically
- **FIN-017**: System shall generate payment receipts

### 6. Reporting & Analytics

#### 6.1 Member Reports
- **REP-001**: Member account statement
- **REP-002**: Member share certificate
- **REP-003**: Member crop performance summary
- **REP-004**: Member transaction history

#### 6.2 Cooperative Reports
- **REP-005**: Total member summary
- **REP-006**: Share register
- **REP-007**: Production summary by crop
- **REP-008**: Financial statements (P&L, Balance Sheet)
- **REP-009**: Inventory status report
- **REP-010**: Payment collection report

#### 6.3 Dashboards
- **DASH-001**: Cooperative management dashboard
- **DASH-002**: Member dashboard
- **DASH-003**: Financial dashboard
- **DASH-004**: Agriculture dashboard

### 7. Communication

#### 7.1 Notifications
- **COM-001**: SMS notifications for transactions
- **COM-002**: Email notifications for shares/dividends
- **COM-003**: In-app notifications
- **COM-004**: Push notifications (mobile app future)

#### 7.2 Announcements
- **COM-005**: Cooperative announcements to all members
- **COM-006**: Targeted announcements by region/crop
- **COM-007**: SMS broadcast capability

---

## Module Customizations

### Custom Doctypes Required

#### 1. **Member** (Custom DocType)
```python
Fields:
- member_id (Auto-generated: MEM-00001)
- member_name (Data)
- id_number (Data, Unique)
- phone_number (Data, Unique)
- email (Data)
- date_of_birth (Date)
- gender (Select: Male, Female, Other)
- membership_date (Date)
- membership_status (Select: Active, Suspended, Exited)
- member_photo (Attach Image)
- farm_locations (Table: Linked Location)
- total_shares (Read Only, calculated)
- account_balance (Read Only, calculated)
- total_land_hectares (Float)
```

#### 2. **Share Type** (Custom DocType)
```python
Fields:
- share_type_name (Data: e.g., "Ordinary Share")
- share_price (Currency: e.g., KES 1000)
- minimum_shares (Int: e.g., 1)
- maximum_shares (Int: e.g., 1000)
- description (Text)
- active (Check)
```

#### 3. **Share Purchase** (Custom DocType)
```python
Fields:
- member (Link: Member)
- share_type (Link: Share Type)
- number_of_shares (Int)
- share_price (Currency, read-only from Share Type)
- total_amount (Currency, calculated)
- purchase_date (Date)
- payment_method (Select: Paystack, M-Pesa, Bank Transfer, Cash)
- payment_status (Select: Pending, Paid, Failed)
- paystack_reference (Data)
- share_certificate_number (Data, auto-generated)
- remarks (Text)
```

#### 4. **Member Share Register** (Report/View)
```python
Virtual DocType showing:
- member_id
- member_name
- total_shares_owned
- total_investment (Currency)
- ownership_percentage (Percent)
- last_purchase_date
```

#### 5. **Dividend Declaration** (Custom DocType)
```python
Fields:
- dividend_year (Data: e.g., "2025")
- dividend_rate (Percent: e.g., 10%)
- total_dividend_pool (Currency)
- declaration_date (Date)
- payment_date (Date)
- status (Select: Draft, Declared, Paid)
- dividend_entries (Table: Member, Shares, Amount)
```

#### 6. **Member Account** (Custom DocType)
```python
Fields:
- member (Link: Member)
- transaction_date (Date)
- transaction_type (Select: Share Purchase, Resource Purchase,
                     Produce Sale, Dividend, Deposit, Withdrawal)
- description (Text)
- debit (Currency)
- credit (Currency)
- balance (Currency, calculated)
- reference_doctype (Data)
- reference_document (Dynamic Link)
```

#### 7. **Farm Location** (Extends Agriculture Location)
```python
Additional Fields:
- member (Link: Member)
- location_name (Data: e.g., "Kamau Farm - Field A")
- size_hectares (Float)
- gps_coordinates (Data)
- soil_type (Select)
- water_source (Select: Rain-fed, Borehole, River, etc.)
```

#### 8. **Member Crop Cycle** (Extends Crop Cycle)
```python
Additional Fields:
- member (Link: Member)
- farm_location (Link: Farm Location)
- cooperative_support (Table: Resource, Quantity, Cost)
- expected_yield_kg (Float)
- actual_yield_kg (Float)
- cost_per_kg (Currency, calculated)
- revenue (Currency)
- profit (Currency, calculated)
```

#### 9. **Resource Allocation** (Custom DocType)
```python
Fields:
- member (Link: Member)
- allocation_date (Date)
- resource_type (Select: Fertilizer, Seed, Pesticide)
- item (Link: Item)
- quantity (Float)
- unit_price (Currency)
- total_cost (Currency, calculated)
- payment_method (Select: Account Deduction, Cash, Credit)
- linked_crop_cycle (Link: Member Crop Cycle)
- delivery_status (Select: Pending, Delivered)
```

#### 10. **Produce Collection** (Custom DocType)
```python
Fields:
- member (Link: Member)
- collection_date (Date)
- crop_cycle (Link: Member Crop Cycle)
- crop (Link: Crop)
- quantity_kg (Float)
- quality_grade (Select: Grade A, Grade B, Grade C)
- price_per_kg (Currency)
- total_value (Currency, calculated)
- payment_status (Select: Pending, Paid)
- warehouse (Link: Warehouse)
- moisture_content (Percent)
- remarks (Text)
```

---

## Payment Integration (Paystack)

### Paystack Integration Specification

#### Overview
Integrate Paystack payment gateway to enable members to purchase cooperative shares online using cards, bank transfers, or mobile money.

#### Technical Requirements

##### 1. Paystack Account Setup
- Create Paystack business account
- Obtain API keys (Public Key, Secret Key)
- Configure webhook URL for payment verification
- Enable payment channels: Cards, Bank Transfer, USSD, Mobile Money

##### 2. Integration Architecture

```
Member Portal
     ↓
  Share Purchase Form
     ↓
  Paystack Payment Page (Popup/Redirect)
     ↓
  Payment Processing
     ↓
  Webhook Callback → ERPNext
     ↓
  Update Share Purchase Record
     ↓
  Send Confirmation (SMS/Email)
     ↓
  Generate Share Certificate
```

##### 3. API Endpoints Required

**A. Initialize Payment**
```python
Endpoint: /api/method/nextgen_farmers.api.initialize_payment
Method: POST
Parameters:
  - member_id
  - share_type
  - number_of_shares
  - amount

Response:
  - authorization_url (redirect to Paystack)
  - access_code
  - reference
```

**B. Verify Payment**
```python
Endpoint: /api/method/nextgen_farmers.api.verify_payment
Method: POST
Parameters:
  - reference (from Paystack callback)

Response:
  - status (success/failed)
  - amount
  - transaction_date
  - customer_email
```

**C. Webhook Handler**
```python
Endpoint: /api/method/nextgen_farmers.api.paystack_webhook
Method: POST
Payload: Paystack webhook event

Actions:
  - Verify webhook signature
  - Update Share Purchase status
  - Create Member Account entry
  - Generate share certificate
  - Send notifications
```

##### 4. Custom Python Controller

**File**: `nextgen_farmers/nextgen_farmers/doctype/share_purchase/share_purchase.py`

```python
import frappe
import requests
import hashlib
import hmac
from frappe import _

class SharePurchase(Document):
    def validate(self):
        """Calculate total amount before save"""
        self.total_amount = self.number_of_shares * self.share_price

    def on_submit(self):
        """Create member account entry when payment is confirmed"""
        if self.payment_status == "Paid":
            self.create_member_account_entry()
            self.generate_share_certificate()
            self.send_confirmation_notification()

    def initialize_paystack_payment(self):
        """Initialize payment with Paystack"""
        settings = frappe.get_single("Paystack Settings")

        url = "https://api.paystack.co/transaction/initialize"
        headers = {
            "Authorization": f"Bearer {settings.secret_key}",
            "Content-Type": "application/json"
        }

        member = frappe.get_doc("Member", self.member)

        payload = {
            "email": member.email,
            "amount": int(self.total_amount * 100),  # Convert to kobo/cents
            "reference": self.name,
            "callback_url": f"{frappe.utils.get_url()}/api/method/nextgen_farmers.api.payment_callback",
            "metadata": {
                "member_id": self.member,
                "member_name": member.member_name,
                "share_type": self.share_type,
                "number_of_shares": self.number_of_shares
            }
        }

        response = requests.post(url, json=payload, headers=headers)

        if response.status_code == 200:
            data = response.json()["data"]
            self.paystack_reference = data["reference"]
            self.save()
            return data["authorization_url"]
        else:
            frappe.throw(_("Payment initialization failed"))

    def verify_paystack_payment(self, reference):
        """Verify payment with Paystack"""
        settings = frappe.get_single("Paystack Settings")

        url = f"https://api.paystack.co/transaction/verify/{reference}"
        headers = {
            "Authorization": f"Bearer {settings.secret_key}"
        }

        response = requests.get(url, headers=headers)

        if response.status_code == 200:
            data = response.json()["data"]
            if data["status"] == "success":
                self.payment_status = "Paid"
                self.purchase_date = frappe.utils.now()
                self.save()
                self.submit()
                return True

        return False

    def create_member_account_entry(self):
        """Create member account entry for share purchase"""
        account_entry = frappe.get_doc({
            "doctype": "Member Account",
            "member": self.member,
            "transaction_date": self.purchase_date,
            "transaction_type": "Share Purchase",
            "description": f"Purchase of {self.number_of_shares} {self.share_type}",
            "credit": self.total_amount,
            "reference_doctype": "Share Purchase",
            "reference_document": self.name
        })
        account_entry.insert()

    def generate_share_certificate(self):
        """Generate digital share certificate"""
        # Auto-generate certificate number
        self.share_certificate_number = f"CERT-{self.name}"
        self.save()

        # Generate PDF certificate (template required)
        # Send via email

    def send_confirmation_notification(self):
        """Send SMS and Email confirmation"""
        member = frappe.get_doc("Member", self.member)

        # SMS
        message = f"Dear {member.member_name}, your purchase of {self.number_of_shares} shares worth KES {self.total_amount} has been confirmed. Certificate No: {self.share_certificate_number}"
        # Send SMS via configured provider

        # Email
        frappe.sendmail(
            recipients=[member.email],
            subject="Share Purchase Confirmation",
            message=f"""
            <p>Dear {member.member_name},</p>
            <p>Your purchase has been confirmed:</p>
            <ul>
                <li>Shares: {self.number_of_shares}</li>
                <li>Amount: KES {self.total_amount}</li>
                <li>Certificate: {self.share_certificate_number}</li>
            </ul>
            <p>Thank you for your investment in NextGen Farmers Hub!</p>
            """
        )

@frappe.whitelist(allow_guest=True)
def paystack_webhook():
    """Handle Paystack webhook events"""
    settings = frappe.get_single("Paystack Settings")

    # Get request data
    payload = frappe.request.get_data()
    signature = frappe.request.headers.get("X-Paystack-Signature")

    # Verify webhook signature
    computed_signature = hmac.new(
        settings.secret_key.encode(),
        payload,
        hashlib.sha512
    ).hexdigest()

    if signature != computed_signature:
        frappe.throw("Invalid webhook signature")

    # Process event
    event = frappe.parse_json(payload)

    if event["event"] == "charge.success":
        reference = event["data"]["reference"]
        share_purchase = frappe.get_doc("Share Purchase", reference)
        share_purchase.verify_paystack_payment(reference)

    return "Webhook processed"
```

##### 5. Paystack Settings DocType

```python
Fields:
- public_key (Data)
- secret_key (Password)
- webhook_secret (Password)
- test_mode (Check)
- enabled (Check)
- supported_currencies (Table: Currency Code)
```

##### 6. Frontend Integration

**Share Purchase Form (JS)**

```javascript
frappe.ui.form.on('Share Purchase', {
    refresh: function(frm) {
        if (frm.doc.payment_status === "Pending" && !frm.doc.__islocal) {
            frm.add_custom_button(__('Pay with Paystack'), function() {
                frm.call({
                    method: 'initialize_paystack_payment',
                    callback: function(r) {
                        if (r.message) {
                            // Redirect to Paystack payment page
                            window.open(r.message, '_blank');
                        }
                    }
                });
            }).addClass('btn-primary');
        }

        if (frm.doc.payment_status === "Pending") {
            frm.add_custom_button(__('Verify Payment'), function() {
                frm.call({
                    method: 'verify_paystack_payment',
                    args: {
                        reference: frm.doc.paystack_reference
                    },
                    callback: function(r) {
                        if (r.message) {
                            frappe.msgprint(__('Payment verified successfully'));
                            frm.reload_doc();
                        } else {
                            frappe.msgprint(__('Payment verification failed'));
                        }
                    }
                });
            });
        }
    },

    number_of_shares: function(frm) {
        // Calculate total amount
        if (frm.doc.share_price && frm.doc.number_of_shares) {
            frm.set_value('total_amount',
                frm.doc.share_price * frm.doc.number_of_shares);
        }
    }
});
```

##### 7. Security Considerations

- **API Key Protection**: Store Paystack keys in encrypted fields
- **Webhook Verification**: Always verify webhook signatures
- **HTTPS Only**: Ensure site runs on HTTPS
- **Amount Validation**: Verify payment amount matches purchase amount
- **Idempotency**: Prevent duplicate payment processing
- **Logging**: Log all payment transactions for audit
- **Error Handling**: Graceful handling of payment failures

##### 8. Testing Checklist

- [ ] Test mode payment flow
- [ ] Card payment successful
- [ ] Card payment failed
- [ ] Bank transfer payment
- [ ] Mobile money payment
- [ ] Webhook reception
- [ ] Duplicate payment prevention
- [ ] Email/SMS notifications
- [ ] Share certificate generation
- [ ] Account balance update
- [ ] Production mode testing

---

## Branding & UI/UX

### Design System

#### Color Palette (NextGen Farmers Hub)

**Primary Colors:**
```css
--brand-primary: #f4511e;        /* Orange */
--brand-secondary: #32373c;      /* Dark Gray */
--brand-white: #ffffff;
--brand-black: #000000;
```

**Extended Palette:**
```css
/* Orange Shades */
--orange-50: #fff5f2;
--orange-100: #ffe8e0;
--orange-500: #f4511e;  /* Primary */
--orange-600: #dc4619;  /* Hover */
--orange-700: #b83b15;  /* Active */

/* Gray Shades */
--gray-500: #32373c;    /* Secondary */
--gray-600: #2d3136;
--gray-400: #5f6570;
```

#### Typography

```css
/* Headings */
font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;

h1 { font-size: 2.5rem; font-weight: 700; color: var(--gray-500); }
h2 { font-size: 2rem; font-weight: 600; color: var(--gray-500); }
h3 { font-size: 1.5rem; font-weight: 600; color: var(--gray-500); }

/* Body */
body { font-size: 1rem; line-height: 1.6; color: #333; }
```

#### Component Styling

**Buttons:**
```css
.btn-primary {
    background-color: var(--brand-primary);
    border-color: var(--brand-primary);
    color: white;
}

.btn-primary:hover {
    background-color: var(--orange-600);
}

.btn-secondary {
    background-color: var(--brand-secondary);
    border-color: var(--brand-secondary);
    color: white;
}
```

**Navigation:**
```css
.navbar {
    background-color: var(--brand-secondary);
}

.navbar-brand {
    color: white;
}

.nav-link:hover {
    color: var(--brand-primary);
}
```

### Custom Templates

#### 1. Member Portal Landing Page

**File**: `nextgen_farmers/templates/pages/member_portal.html`

```html
{% extends "templates/web.html" %}

{% block title %}Member Portal - NextGen Farmers Hub{% endblock %}

{% block page_content %}
<div class="member-portal">
    <div class="portal-header">
        <h1>Welcome, {{ member.member_name }}!</h1>
        <p>Member ID: {{ member.member_id }}</p>
    </div>

    <div class="dashboard-cards">
        <div class="card">
            <h3>My Shares</h3>
            <p class="metric">{{ member.total_shares }}</p>
            <a href="/shares" class="btn btn-primary">View Details</a>
        </div>

        <div class="card">
            <h3>Account Balance</h3>
            <p class="metric">KES {{ member.account_balance }}</p>
            <a href="/account" class="btn btn-primary">View Statement</a>
        </div>

        <div class="card">
            <h3>My Crops</h3>
            <p class="metric">{{ member.active_crop_cycles }} Active</p>
            <a href="/crops" class="btn btn-primary">View Crops</a>
        </div>

        <div class="card">
            <h3>Buy Shares</h3>
            <p class="metric">Quick Purchase</p>
            <a href="/buy-shares" class="btn btn-primary">Buy Now</a>
        </div>
    </div>

    <div class="recent-activities">
        <h2>Recent Activities</h2>
        <!-- Activity timeline -->
    </div>
</div>
{% endblock %}
```

#### 2. Share Purchase Page

**File**: `nextgen_farmers/templates/pages/buy_shares.html`

```html
{% extends "templates/web.html" %}

{% block page_content %}
<div class="share-purchase-page">
    <h1>Purchase Cooperative Shares</h1>

    <form id="share-purchase-form">
        <div class="form-group">
            <label>Share Type</label>
            <select name="share_type" required>
                {% for share_type in share_types %}
                <option value="{{ share_type.name }}">
                    {{ share_type.share_type_name }} -
                    KES {{ share_type.share_price }}
                </option>
                {% endfor %}
            </select>
        </div>

        <div class="form-group">
            <label>Number of Shares</label>
            <input type="number" name="number_of_shares"
                   min="1" max="1000" required>
        </div>

        <div class="form-group">
            <label>Total Amount</label>
            <input type="text" name="total_amount" readonly>
        </div>

        <button type="submit" class="btn btn-primary btn-lg">
            Proceed to Payment
        </button>
    </form>
</div>

<script>
    // Calculate total amount
    // Initialize Paystack payment
    // Handle payment callback
</script>
{% endblock %}
```

---

## Technical Stack

### Development Environment

```bash
# Required Software
- Python 3.10+
- Node.js 16+
- MariaDB 10.6+
- Redis
- Git

# Frappe Bench Setup
bench init frappe-bench --frappe-branch version-15
cd frappe-bench
bench new-site nextgenfarmers.com
bench get-app erpnext
bench get-app agriculture
bench --site nextgenfarmers.com install-app erpnext
bench --site nextgenfarmers.com install-app agriculture
```

### Custom App Structure

```
nextgen_farmers/
├── nextgen_farmers/
│   ├── __init__.py
│   ├── hooks.py
│   ├── modules.txt
│   ├── config/
│   │   ├── desktop.py
│   │   └── docs.py
│   ├── nextgen_farmers/
│   │   ├── doctype/
│   │   │   ├── member/
│   │   │   ├── share_purchase/
│   │   │   ├── share_type/
│   │   │   ├── member_account/
│   │   │   ├── dividend_declaration/
│   │   │   └── ...
│   │   ├── page/
│   │   │   └── member_dashboard/
│   │   ├── report/
│   │   │   ├── member_share_register/
│   │   │   └── cooperative_summary/
│   │   └── api/
│   │       ├── paystack.py
│   │       └── member_portal.py
│   ├── templates/
│   │   ├── pages/
│   │   │   ├── member_portal.html
│   │   │   ├── buy_shares.html
│   │   │   └── member_account.html
│   │   └── includes/
│   ├── public/
│   │   ├── css/
│   │   │   ├── nextgen_theme.css
│   │   │   └── member_portal.css
│   │   └── js/
│   │       └── member_portal.js
│   └── www/
│       └── (web pages)
├── README.md
├── license.txt
└── requirements.txt
```

---

## Implementation Phases

### Phase 1: Foundation (Weeks 1-2)

**Objectives:**
- Set up development environment
- Create custom app structure
- Implement branding

**Tasks:**
1. Install Frappe/ERPNext development environment
2. Create `nextgen_farmers` custom app
3. Apply NextGen Farmers Hub branding
4. Set up version control (GitHub)
5. Create development and production branches

**Deliverables:**
- Working ERPNext instance with branding
- Custom app skeleton
- GitHub repository

### Phase 2: Core Member Management (Weeks 3-4)

**Objectives:**
- Implement member registration and management
- Create member portal

**Tasks:**
1. Create Member DocType
2. Create Member Account DocType
3. Build member registration workflow
4. Develop member portal interface
5. Implement member authentication

**Deliverables:**
- Member registration system
- Member portal dashboard
- Member login functionality

### Phase 3: Share Management (Weeks 5-6)

**Objectives:**
- Implement share purchase and tracking
- Integrate Paystack payment

**Tasks:**
1. Create Share Type DocType
2. Create Share Purchase DocType
3. Integrate Paystack API
4. Implement payment verification
5. Generate share certificates
6. Create share register report

**Deliverables:**
- Share purchase system
- Paystack integration
- Digital share certificates
- Share register report

### Phase 4: Agriculture Module (Weeks 7-9)

**Objectives:**
- Customize agriculture module for cooperative
- Enable crop tracking per member

**Tasks:**
1. Extend Crop Cycle DocType for members
2. Create Farm Location DocType
3. Implement resource allocation system
4. Build produce collection system
5. Create agriculture dashboards

**Deliverables:**
- Member crop tracking
- Resource allocation system
- Produce collection workflow
- Agriculture reports

### Phase 5: Financial Management (Weeks 10-11)

**Objectives:**
- Implement member accounting
- Create dividend management

**Tasks:**
1. Build member account ledger
2. Create Dividend Declaration DocType
3. Implement dividend calculation
4. Build financial reports
5. Integrate M-Pesa for payments

**Deliverables:**
- Member account system
- Dividend management
- Financial statements
- Payment integration

### Phase 6: Testing & Deployment (Weeks 12-13)

**Objectives:**
- Comprehensive testing
- Production deployment
- User training

**Tasks:**
1. Unit testing
2. Integration testing
3. User acceptance testing
4. Production server setup
5. Data migration
6. User training
7. Go-live

**Deliverables:**
- Tested system
- Production deployment
- User documentation
- Training materials

---

## Success Metrics

### Quantitative Metrics

1. **User Adoption**
   - Target: 80% of members registered within 3 months
   - Target: 60% monthly active users

2. **Share Purchases**
   - Target: 70% of share purchases done online
   - Target: Average payment success rate >95%

3. **Operational Efficiency**
   - Target: Reduce admin time by 50%
   - Target: Report generation time <5 minutes

4. **Financial**
   - Target: Process 100+ transactions/month
   - Target: Zero payment reconciliation errors

### Qualitative Metrics

1. **User Satisfaction**
   - Member portal usability score >4/5
   - Positive feedback from 80% of users

2. **Data Quality**
   - 100% accurate member records
   - Real-time financial data

3. **Business Impact**
   - Increased transparency
   - Better decision-making
   - Improved member engagement

---

## Risk Assessment

### Technical Risks

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Paystack API downtime | High | Low | Implement retry logic, fallback to manual |
| Data loss | Critical | Very Low | Daily backups, redundancy |
| Performance issues | Medium | Medium | Load testing, optimization |
| Security breach | Critical | Low | Security audit, encryption, access control |

### Business Risks

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Low user adoption | High | Medium | Training, change management, support |
| Resistance to change | Medium | High | Stakeholder engagement, pilot program |
| Budget overrun | Medium | Low | Phased approach, priority features first |

### Operational Risks

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Internet connectivity | Medium | Medium | Offline mode for critical functions |
| Staff turnover | Medium | Medium | Documentation, knowledge transfer |
| Vendor dependency | Low | Low | Open-source stack reduces lock-in |

---

## Appendices

### A. Glossary

- **Member**: A registered farmer in the cooperative
- **Share**: Unit of ownership in the cooperative
- **Crop Cycle**: Complete growing period from planting to harvest
- **Cooperative**: NextGen Farmers Hub organization
- **Paystack**: Payment gateway provider

### B. References

- ERPNext Documentation: https://docs.erpnext.com
- Frappe Framework: https://frappeframework.com
- Paystack API: https://paystack.com/docs/api
- Agriculture Module: https://github.com/frappe/agriculture

### C. Approval

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Product Designer | [Name] | _______ | _______ |
| Technical Lead | [Name] | _______ | _______ |
| Project Sponsor | [Name] | _______ | _______ |

---

**End of Product Requirements Document**
