# NextGen Farmers Hub - Installation Guide

This guide will help you install and configure the NextGen Farmers Hub ERPNext customization.

## Prerequisites

Before installing, ensure you have:

1. **Frappe Bench** installed and configured
   - Frappe Framework version 14 or higher
   - ERPNext version 14 or higher

2. **System Requirements:**
   - Ubuntu 20.04 LTS or later / Debian 11 or later
   - Python 3.10+
   - Node.js 16+
   - MariaDB 10.6+ / PostgreSQL 13+
   - Redis 5+
   - nginx 1.18+

3. **Required ERPNext Apps:**
   - `erpnext` (core)
   - `agriculture` (optional but recommended)

## Installation Steps

### Step 1: Navigate to Frappe Bench

```bash
cd ~/frappe-bench
```

### Step 2: Get the NextGen Farmers App

**Option A: From GitHub (Recommended for production)**
```bash
bench get-app https://github.com/nextgenfarmershub/nextgen_farmers.git
```

**Option B: From Local Directory (For development)**
```bash
# Copy the nextgen_farmers directory to frappe-bench/apps/
cp -r /path/to/nextgen_farmers ~/frappe-bench/apps/

# Get the app
cd ~/frappe-bench
bench get-app nextgen_farmers
```

### Step 3: Install on Your Site

Replace `your-site-name.local` with your actual site name:

```bash
bench --site your-site-name.local install-app nextgen_farmers
```

### Step 4: Run Migrations

```bash
bench --site your-site-name.local migrate
```

### Step 5: Build Assets

```bash
bench build --app nextgen_farmers
```

### Step 6: Restart Bench

```bash
bench restart
```

### Step 7: Clear Cache

```bash
bench --site your-site-name.local clear-cache
bench --site your-site-name.local clear-website-cache
```

## Post-Installation Configuration

### 1. Create User Roles

Login as Administrator and create the following roles:

1. **Cooperative Manager**
   - Full access to all cooperative management features
   - Can manage members, finances, and operations

2. **Farm Manager**
   - Access to farm operations
   - Can manage farm activities, plots, and crops

3. **Cooperative Member**
   - Limited access to member portal
   - Can view their own data and book equipment

### 2. Configure Company Details

Navigate to:
**Setup > Company**

Update company details for NextGen Farmers Hub:
- Company Name: NextGen Farmers Hub
- Country: Ghana
- Default Currency: GHS (Ghana Cedi)
- Address: Asylum Down, Samora Mahel Street, Accra

### 3. Setup Membership Tiers

Navigate to:
**NextGen Farmers Hub > Membership Tier**

Create membership tiers (suggested):

**Tier 1: Youth Farmer**
- Minimum Contribution: GHS 100
- Registration Fee: GHS 50
- Profit Share: 10%
- Benefits: Basic access to equipment and training

**Tier 2: Active Farmer**
- Minimum Contribution: GHS 500
- Registration Fee: GHS 100
- Profit Share: 15%
- Benefits: Priority equipment access, advanced training

**Tier 3: Lead Farmer**
- Minimum Contribution: GHS 1,000
- Registration Fee: GHS 200
- Profit Share: 20%
- Benefits: Full access, mentorship opportunities, voting rights

### 4. Import Member Data

If you have existing member data, prepare a CSV file with the following columns:
- member_id
- first_name
- last_name
- email
- mobile_number
- membership_tier
- join_date

Then import via:
**Home > Data Import Tool > Cooperative Member**

### 5. Setup Farm Locations

Navigate to:
**NextGen Farmers Hub > Farm Location**

Add your farm locations with:
- Farm name and code
- GPS coordinates
- Land area
- Soil type and characteristics

### 6. Configure Equipment (Assets)

Navigate to:
**Assets > Asset**

Add cooperative equipment such as:
- Tractors
- Harvesters
- Ploughs
- Irrigation equipment

Then configure rental rates in:
**NextGen Farmers Hub > Equipment Rental**

### 7. Setup Products for Marketplace

Navigate to:
**Stock > Item**

Create items for your main produce:
- Tomatoes
- Rice
- Cabbage
- Maize
- Cassava
- Okra

### 8. Configure Payment Methods

Navigate to:
**Accounts > Mode of Payment**

Ensure the following payment methods exist:
- Cash
- Mobile Money (MTN, Vodafone, AirtelTigo)
- Bank Transfer
- Cheque

### 9. Setup Portal Access

To enable member portal access:

1. Navigate to **Website Settings**
2. Enable "Allow Sign Up"
3. Set Home Page to member dashboard
4. Configure portal menu items

### 10. Configure Email

Setup email for member notifications:

1. Navigate to **Email Domain** and **Email Account**
2. Configure SMTP settings
3. Setup email templates for:
   - New member welcome
   - Equipment rental confirmation
   - Training program registration
   - Profit distribution notification

## Optional: Install Agriculture Domain

For enhanced farming features:

```bash
bench get-app agriculture
bench --site your-site-name.local install-app agriculture
bench --site your-site-name.local migrate
bench restart
```

## Verification

### Test the Installation

1. **Login as Administrator**
   - Access the desk
   - Navigate to **NextGen Farmers Hub** workspace
   - Verify all modules are visible

2. **Create Test Data**
   - Create a test member
   - Create a test farm location
   - Create a test equipment rental
   - Create a test marketplace product

3. **Test Member Portal**
   - Create a portal user for a test member
   - Login as that member
   - Verify portal access and features

## Troubleshooting

### Common Issues

**Issue: App not appearing after installation**
```bash
bench --site your-site-name.local clear-cache
bench restart
```

**Issue: Permission errors**
```bash
bench --site your-site-name.local set-admin-password <new-password>
# Then rebuild permissions
bench --site your-site-name.local build-search-index
```

**Issue: Database errors during migration**
```bash
# Check migration status
bench --site your-site-name.local migrate

# If errors persist, check logs
tail -f ~/frappe-bench/logs/your-site-name.local.log
```

**Issue: Assets not loading**
```bash
bench build --app nextgen_farmers
bench --site your-site-name.local clear-cache
```

## Backup and Restore

### Create Backup

```bash
bench --site your-site-name.local backup
```

### Restore from Backup

```bash
bench --site your-site-name.local restore /path/to/backup/file
```

## Updating the App

To update to the latest version:

```bash
cd ~/frappe-bench
bench get-app nextgen_farmers --branch main
bench --site your-site-name.local migrate
bench build --app nextgen_farmers
bench restart
```

## Security Recommendations

1. **Change Default Passwords**
   - Change Administrator password immediately
   - Use strong passwords for all users

2. **Enable Two-Factor Authentication**
   - Navigate to User settings
   - Enable 2FA for all admin users

3. **Configure Firewall**
   ```bash
   sudo ufw allow 22/tcp
   sudo ufw allow 80/tcp
   sudo ufw allow 443/tcp
   sudo ufw enable
   ```

4. **Setup SSL Certificate**
   ```bash
   bench setup lets-encrypt your-site-name.local
   ```

5. **Regular Backups**
   - Setup automated daily backups
   - Store backups offsite

## Support

For issues and support:
- **Email**: support@nextgenfarmershub.com
- **Location**: Asylum Down, Samora Mahel Street, Accra, Ghana
- **GitHub**: https://github.com/nextgenfarmershub/nextgen_farmers/issues

## Next Steps

After installation:
1. Review the [User Guide](./USER_GUIDE.md)
2. Configure workflows for your specific needs
3. Train staff on using the system
4. Import existing data
5. Start onboarding members

---

**Welcome to NextGen Farmers Hub ERP System!** 🌾
