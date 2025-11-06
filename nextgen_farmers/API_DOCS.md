# NextGen Farmers Hub - API Documentation

REST API documentation for integrating with NextGen Farmers Hub ERP system.

## Authentication

All API requests require authentication using an API key or token.

### Get API Key

1. Login to ERPNext
2. Go to User > API Access
3. Generate API Key and Secret

### Authentication Methods

**Method 1: API Key (Recommended)**
```bash
curl -X GET https://nextgenfarmershub.com/api/resource/Cooperative%20Member \
  -H "Authorization: token <api_key>:<api_secret>"
```

**Method 2: Session-based**
```bash
# Login
curl -X POST https://nextgenfarmershub.com/api/method/login \
  -H "Content-Type: application/json" \
  -d '{"usr":"user@example.com", "pwd":"password"}'

# Use returned cookies for subsequent requests
```

## Base URL

```
https://nextgenfarmershub.com/api
```

## Common Headers

```
Authorization: token <api_key>:<api_secret>
Content-Type: application/json
Accept: application/json
```

## API Endpoints

### Cooperative Member APIs

#### Get Member Dashboard
Get comprehensive dashboard data for a member.

```http
GET /api/method/nextgen_farmers.api.member.get_member_dashboard
```

**Parameters:**
- `member` (required): Member ID

**Response:**
```json
{
  "message": {
    "member": {
      "name": "MEM-2025-001",
      "full_name": "John Mensah",
      "membership_tier": "Active Farmer",
      "total_contributions": 5000.00,
      "total_profit_share": 1200.00
    },
    "contributions": [...],
    "profit_distributions": [...],
    "training_programs": [...],
    "equipment_rentals": [...]
  }
}
```

#### Get Member Statistics
Get overall cooperative member statistics.

```http
GET /api/method/nextgen_farmers.api.member.get_member_statistics
```

**Response:**
```json
{
  "message": {
    "total_members": 515,
    "active_members": 498,
    "pending_approval": 17,
    "new_members_this_month": 23,
    "tier_distribution": [
      {"membership_tier": "Youth Farmer", "count": 250},
      {"membership_tier": "Active Farmer", "count": 200},
      {"membership_tier": "Lead Farmer", "count": 48}
    ]
  }
}
```

#### Create New Member
Register a new cooperative member.

```http
POST /api/resource/Cooperative Member
```

**Request Body:**
```json
{
  "member_id": "MEM-2025-100",
  "first_name": "Kwame",
  "last_name": "Asante",
  "email": "kwame@example.com",
  "mobile_number": "+233241234567",
  "membership_tier": "Youth Farmer",
  "join_date": "2025-01-15",
  "membership_status": "Active"
}
```

#### Update Member
Update member information.

```http
PUT /api/resource/Cooperative Member/{member_id}
```

#### Get Member List
Get list of all members with filters.

```http
GET /api/resource/Cooperative Member
```

**Query Parameters:**
- `fields`: JSON array of fields to return
- `filters`: JSON array of filters
- `limit_start`: Pagination offset
- `limit_page_length`: Number of records per page

**Example:**
```bash
GET /api/resource/Cooperative%20Member?fields=["name","full_name","mobile_number"]&filters=[["membership_status","=","Active"]]&limit_page_length=20
```

### Equipment Rental APIs

#### Get Available Equipment
Get list of equipment available for rental in a specific period.

```http
GET /api/method/nextgen_farmers.api.equipment.get_available_equipment
```

**Parameters:**
- `start_date` (required): Rental start date (YYYY-MM-DD)
- `end_date` (required): Rental end date (YYYY-MM-DD)

**Response:**
```json
{
  "message": [
    {
      "name": "ASSET-001",
      "asset_name": "Tractor - John Deere 5075E",
      "item_code": "TRACTOR-JD-001",
      "location": "Main Farm - Accra"
    }
  ]
}
```

#### Create Equipment Rental
Book equipment for rental.

```http
POST /api/resource/Equipment Rental
```

**Request Body:**
```json
{
  "member": "MEM-2025-001",
  "equipment": "ASSET-001",
  "rental_start_date": "2025-02-01",
  "rental_end_date": "2025-02-03",
  "rental_rate_per_day": 500.00,
  "delivery_required": 1,
  "delivery_location": "Farm Location A, Plot 5",
  "payment_method": "Mobile Money"
}
```

#### Check Equipment Availability
Check if specific equipment is available.

```http
GET /api/method/nextgen_farmers.api.equipment.check_availability
```

**Parameters:**
- `equipment`: Equipment/Asset ID
- `start_date`: Rental start date
- `end_date`: Rental end date

### Marketplace APIs

#### Get Marketplace Products
List all products available in marketplace.

```http
GET /api/resource/Marketplace Product
```

#### Create Marketplace Order
Place an order for farm produce.

```http
POST /api/resource/Marketplace Order
```

**Request Body:**
```json
{
  "customer_name": "ABC Agro Ltd",
  "customer_mobile": "+233241234567",
  "items": [
    {
      "product": "PROD-001",
      "quantity": 100,
      "unit": "Kg",
      "rate": 5.50
    }
  ],
  "delivery_required": 1,
  "delivery_address": "123 Market Street, Accra"
}
```

#### Get Product Pricing
Get current pricing for a product.

```http
GET /api/method/nextgen_farmers.api.marketplace.get_product_price
```

**Parameters:**
- `product`: Product ID
- `quantity`: Quantity requested

### Training Program APIs

#### Get Training Programs
List all available training programs.

```http
GET /api/resource/Training Program
```

**Query Parameters:**
- `filters`: Filter by status, date range, etc.

**Example:**
```bash
GET /api/resource/Training%20Program?filters=[["program_status","=","Upcoming"]]
```

#### Register for Training
Register a member for a training program.

```http
POST /api/method/nextgen_farmers.api.training.register_member
```

**Request Body:**
```json
{
  "member": "MEM-2025-001",
  "training_program": "TRAIN-2025-001"
}
```

#### Get Member Training History
Get training history for a member.

```http
GET /api/method/nextgen_farmers.api.training.get_member_training
```

**Parameters:**
- `member`: Member ID

### Farm Operations APIs

#### Get Farm Locations
List all farm locations.

```http
GET /api/resource/Farm Location
```

#### Get Farm Plots
Get plots for a specific farm.

```http
GET /api/resource/Farm Plot?filters=[["farm_location","=","Farm-001"]]
```

#### Record Farm Activity
Record a farm activity.

```http
POST /api/resource/Farm Activity
```

**Request Body:**
```json
{
  "farm_plot": "Farm-001-P01",
  "activity_type": "Planting",
  "activity_date": "2025-01-20",
  "crop": "Tomato",
  "quantity": "1000 seedlings",
  "labor_hours": 8,
  "supervisor": "MEM-2025-010"
}
```

### Financial APIs

#### Record Member Contribution
Record a financial contribution from a member.

```http
POST /api/resource/Member Contribution
```

**Request Body:**
```json
{
  "member": "MEM-2025-001",
  "contribution_date": "2025-01-15",
  "contribution_type": "Regular Contribution",
  "amount": 500.00,
  "payment_method": "Mobile Money",
  "reference_number": "MTN-123456789"
}
```

#### Calculate Profit Distribution
Calculate profit distribution for all members.

```http
POST /api/method/nextgen_farmers.api.finance.calculate_profit_distribution
```

**Request Body:**
```json
{
  "period_from": "2025-01-01",
  "period_to": "2025-03-31",
  "total_profit": 50000.00
}
```

### Export Management APIs

#### Create Export Order
Create an order for export.

```http
POST /api/resource/Export Order
```

**Request Body:**
```json
{
  "buyer_name": "International Foods Ltd",
  "buyer_country": "United Kingdom",
  "items": [
    {
      "product": "Tomato",
      "quantity": 5000,
      "unit": "Kg"
    }
  ],
  "shipment_date": "2025-02-15",
  "incoterm": "FOB"
}
```

## Webhooks

Configure webhooks to receive real-time notifications.

### Available Webhook Events

- `cooperative_member.on_update`: Member record updated
- `equipment_rental.after_insert`: New equipment rental created
- `marketplace_order.on_submit`: Order confirmed
- `training_attendance.after_insert`: Member registered for training
- `member_contribution.on_submit`: Contribution recorded

### Configure Webhook

1. Go to **Integrations > Webhook**
2. Create new webhook
3. Select Document Type and trigger event
4. Add your webhook URL
5. Configure authentication (optional)

**Example Webhook Payload:**
```json
{
  "doctype": "Equipment Rental",
  "name": "RENT-2025-001",
  "member": "MEM-2025-001",
  "equipment": "ASSET-001",
  "rental_start_date": "2025-02-01",
  "rental_status": "Booked"
}
```

## Rate Limiting

API requests are rate-limited to:
- **Anonymous**: 100 requests per hour
- **Authenticated**: 1000 requests per hour
- **Premium**: 5000 requests per hour

## Error Handling

### HTTP Status Codes

- `200 OK`: Request successful
- `201 Created`: Resource created successfully
- `400 Bad Request`: Invalid request parameters
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions
- `404 Not Found`: Resource not found
- `429 Too Many Requests`: Rate limit exceeded
- `500 Internal Server Error`: Server error

### Error Response Format

```json
{
  "exc_type": "ValidationError",
  "exception": "Validation Error: Mobile number is required",
  "_server_messages": "[...]"
}
```

## Mobile App Integration

### Initialize App
Get initial configuration for mobile app.

```http
GET /api/method/nextgen_farmers.api.mobile.get_app_config
```

**Response:**
```json
{
  "message": {
    "company_name": "NextGen Farmers Hub",
    "contact_email": "support@nextgenfarmershub.com",
    "contact_phone": "+233...",
    "features": {
      "equipment_rental": true,
      "marketplace": true,
      "training": true,
      "mobile_money": true
    },
    "payment_methods": ["Cash", "Mobile Money", "Bank Transfer"]
  }
}
```

### Sync Member Data
Sync member data for offline use.

```http
GET /api/method/nextgen_farmers.api.mobile.sync_member_data
```

**Parameters:**
- `member`: Member ID
- `last_sync`: Last sync timestamp (optional)

## Testing

### Test Environment

```
Base URL: https://test.nextgenfarmershub.com/api
```

### Test Credentials

Contact support for test API credentials.

### Postman Collection

Download Postman collection: [nextgen_farmers_api.json](./postman/nextgen_farmers_api.json)

## SDKs

### Python SDK

```python
from nextgen_farmers import NextGenFarmersClient

client = NextGenFarmersClient(
    url="https://nextgenfarmershub.com",
    api_key="your_api_key",
    api_secret="your_api_secret"
)

# Get member dashboard
dashboard = client.get_member_dashboard("MEM-2025-001")

# Create equipment rental
rental = client.create_equipment_rental({
    "member": "MEM-2025-001",
    "equipment": "ASSET-001",
    "rental_start_date": "2025-02-01",
    "rental_end_date": "2025-02-03"
})
```

### JavaScript SDK

```javascript
const NextGenFarmersClient = require('nextgen-farmers-sdk');

const client = new NextGenFarmersClient({
  url: 'https://nextgenfarmershub.com',
  apiKey: 'your_api_key',
  apiSecret: 'your_api_secret'
});

// Get member dashboard
const dashboard = await client.getMemberDashboard('MEM-2025-001');

// Create equipment rental
const rental = await client.createEquipmentRental({
  member: 'MEM-2025-001',
  equipment: 'ASSET-001',
  rental_start_date: '2025-02-01',
  rental_end_date: '2025-02-03'
});
```

## Support

For API support:
- **Email**: api-support@nextgenfarmershub.com
- **Documentation**: https://docs.nextgenfarmershub.com
- **Status Page**: https://status.nextgenfarmershub.com

---

**API Version**: 1.0.0
**Last Updated**: January 2025
