# NextGen Farmers Hub - ERPNext Customization

![NextGen Farmers Hub](https://img.shields.io/badge/ERPNext-Agriculture-green)
![License](https://img.shields.io/badge/license-MIT-blue)

## Overview

Custom ERPNext application designed specifically for **NextGen Farmers Hub**, a youth-focused agricultural cooperative in Ghana with 515+ members. This app transforms ERPNext into a comprehensive cooperative management system.

## About NextGen Farmers Hub

NextGen Farmers Hub empowers Ghana's youth through agriculture by:
- Providing shared agricultural land, tools, and modern farming technology
- Offering training and mentorship from experienced farmers
- Enabling digital marketplace for buying/selling produce
- Facilitating machinery rental and farm labor employment
- Supporting export of Ghanaian produce (tomato, rice, cabbage, maize, cassava, okra)

## Features

### 🤝 Cooperative Management
- **Member Registration & Profiles**: Complete member database with 515+ active members
- **Membership Tiers**: Different membership levels with associated benefits
- **Contribution Tracking**: Monitor member contributions and investments
- **Profit Sharing**: Automated profit distribution calculations
- **Member Dashboard**: Individual member portal with activity tracking

### 🚜 Farm Operations Management
- **Multi-Farm Tracking**: Manage multiple farm locations and plots
- **Crop Planning**: Plan planting schedules and crop rotations
- **Activity Monitoring**: Track all farm activities in real-time
- **Harvest Management**: Record yields, quality metrics, and storage
- **Soil Testing Integration**: Link soil test results to farm plots
- **Weather Tracking**: Monitor weather conditions for farm planning

### 🛠️ Equipment Rental System
- **Asset Booking**: Smart booking system for machinery and tools
- **Rental Pricing**: Flexible pricing models for member vs non-member rates
- **Scheduling**: Prevent double-booking with calendar integration
- **Maintenance Tracking**: Schedule and track equipment maintenance
- **Usage Analytics**: Monitor equipment utilization rates

### 🌾 Digital Marketplace
- **Product Listings**: List farm produce for sale
- **Order Management**: Process customer orders efficiently
- **Fair Pricing Mechanism**: Ensure fair prices for farmers and buyers
- **Inventory Integration**: Real-time stock updates
- **Payment Processing**: Track payments and outstanding balances

### 📚 Training & Development
- **Program Scheduling**: Schedule training sessions and workshops
- **Attendance Tracking**: Monitor participant attendance
- **Mentorship Assignments**: Match mentors with mentees
- **Certification Management**: Track training certifications
- **Resource Library**: Store training materials and resources

### 🌍 Export Management
- **Export Documentation**: Generate required export documents
- **Quality Certifications**: Manage organic and quality certifications
- **Shipment Tracking**: Track export shipments
- **Compliance**: Ensure regulatory compliance
- **Customer Management**: Manage international buyers

### 📊 Project Management
- **Cassava Plantation Project**: Track large-scale cultivation projects
- **Tree Planting Initiative**: Monitor environmental sustainability efforts
- **Smart Farming Initiative**: Technology integration tracking
- **Soil Testing Initiative**: Crop optimization projects
- **Publicity & Marketing**: Brand development activities

### 💰 Financial Management
- **Member Contributions**: Track all financial contributions
- **Profit Distribution**: Calculate and distribute profits fairly
- **Transaction Processing**: Handle all marketplace transactions
- **Financial Reporting**: Comprehensive financial reports
- **Budget Management**: Plan and monitor budgets

## Installation

### 🐳 Quick Start with Docker (Recommended)

**Deploy in minutes using Docker Compose!**

```bash
# Clone repository
git clone https://github.com/your-org/nextgen_farmers.git
cd nextgen_farmers

# Configure environment
cp .env.example .env
nano .env  # Update passwords and settings

# Deploy with one command
docker-compose up -d

# Monitor deployment
docker-compose logs -f
```

**Access**: http://localhost (or your server IP)

📖 **See [DOCKER_QUICKSTART.md](./DOCKER_QUICKSTART.md)** for complete guide
🚀 **For AWS deployment, see [AWS_DEPLOYMENT.md](./AWS_DEPLOYMENT.md)**

**Benefits:**
- ✅ 10-minute setup
- ✅ All services included (database, cache, workers)
- ✅ Automated backups to S3
- ✅ SSL certificate support
- ✅ Production-ready configuration
- ✅ Easy updates and rollback

---

### Traditional Installation (Frappe Bench)

For manual installation without Docker:

#### Prerequisites
- Frappe Bench installed
- ERPNext (version 14 or higher recommended)
- Python 3.10+
- MariaDB 10.6+
- Node.js 16+

#### Setup Instructions

1. **Get the app from GitHub**
```bash
cd ~/frappe-bench
bench get-app https://github.com/your-org/nextgen_farmers.git
```

2. **Install the app on your site**
```bash
bench --site your-site-name install-app nextgen_farmers
```

3. **Set up initial data**
```bash
bench --site your-site-name migrate
bench --site your-site-name execute nextgen_farmers.setup.setup_initial_data
```

4. **Restart bench**
```bash
bench restart
```

### Development Installation

1. **Clone the repository**
```bash
cd ~/frappe-bench/apps
git clone https://github.com/your-org/nextgen_farmers.git
cd nextgen_farmers
```

2. **Install in development mode**
```bash
cd ~/frappe-bench
bench --site your-site-name install-app nextgen_farmers
bench start
```

## Configuration

### Initial Setup Checklist

- [ ] Configure Company details for NextGen Farmers Hub
- [ ] Set up Chart of Accounts
- [ ] Import Member list (515+ members)
- [ ] Configure Equipment and Assets
- [ ] Set up Farm Locations and Plots
- [ ] Define Membership Tiers
- [ ] Configure Profit Sharing Rules
- [ ] Set up Product Categories for Marketplace
- [ ] Configure Training Programs
- [ ] Set up Export Documentation Templates

### Module Configuration

Each module can be configured from:
**NextGen Farmers Hub Workspace > Settings**

## Usage

### For Administrators
1. Access **NextGen Farmers Hub** workspace from desk
2. Configure system settings under **Settings**
3. Monitor dashboards for key metrics
4. Generate reports for decision making

### For Members
1. Login to member portal
2. View personal dashboard
3. Book equipment rentals
4. Access training materials
5. List products in marketplace
6. Track contributions and profit share

### For Farm Managers
1. Access **Farm Operations** module
2. Create farm activity schedules
3. Record daily activities and harvests
4. Monitor crop health and progress
5. Manage labor assignments

## Module Structure

```
nextgen_farmers/
├── cooperative_management/       # Member management and cooperative operations
├── farm_operations/             # Multi-farm tracking and crop management
├── equipment_rental/            # Asset booking and rental system
├── marketplace/                 # Digital marketplace for produce
├── training_development/        # Training programs and mentorship
├── export_management/           # Export documentation and tracking
├── config/                      # Desktop and module configurations
├── public/                      # Static files (CSS, JS, images)
├── templates/                   # Web templates
└── www/                        # Web pages and portal
```

## Custom DocTypes

### Cooperative Management
- **Cooperative Member**: Member profiles and details
- **Membership Tier**: Different membership levels
- **Member Contribution**: Track financial contributions
- **Profit Distribution**: Calculate and record profit sharing

### Farm Operations
- **Farm Location**: Physical farm locations
- **Farm Plot**: Individual plots within farms
- **Crop Cycle**: Track crop planting to harvest
- **Farm Activity**: Daily farm activities
- **Soil Test Result**: Soil testing data

### Equipment Rental
- **Equipment Rental**: Rental bookings
- **Equipment Maintenance**: Maintenance schedules
- **Rental Pricing Rule**: Pricing configurations

### Marketplace
- **Marketplace Product**: Product listings
- **Marketplace Order**: Customer orders
- **Fair Price Rule**: Pricing mechanisms

### Training & Development
- **Training Program**: Training sessions
- **Training Attendance**: Attendance records
- **Mentorship Assignment**: Mentor-mentee pairs
- **Training Certificate**: Issued certificates

### Export Management
- **Export Order**: Export transactions
- **Export Documentation**: Required documents
- **Quality Certification**: Quality certificates
- **Export Shipment**: Shipment tracking

## API Endpoints

The app exposes RESTful APIs for mobile app integration:

```
/api/method/nextgen_farmers.api.member.get_member_dashboard
/api/method/nextgen_farmers.api.equipment.book_equipment
/api/method/nextgen_farmers.api.marketplace.create_order
/api/method/nextgen_farmers.api.training.register_for_program
```

Full API documentation: [API_DOCS.md](./API_DOCS.md)

## Mobile App Integration

This ERPNext customization is designed to work with mobile apps. Mobile-friendly features include:

- Responsive member portal
- Equipment booking via mobile
- Digital marketplace access
- Farm activity recording
- Training registration
- Real-time notifications

## Reports & Analytics

### Key Reports
- **Member Activity Report**: Track member engagement
- **Equipment Utilization Report**: Monitor asset usage
- **Farm Productivity Report**: Yield and harvest analytics
- **Marketplace Sales Report**: Track marketplace transactions
- **Training Participation Report**: Training analytics
- **Export Performance Report**: Export business metrics
- **Financial Summary Report**: Cooperative financial health

### Dashboards
- **Cooperative Overview Dashboard**: High-level metrics
- **Farm Operations Dashboard**: Real-time farm status
- **Equipment Dashboard**: Asset utilization
- **Marketplace Dashboard**: Sales and orders
- **Financial Dashboard**: Revenue and profit tracking

## Customization

To add custom fields or modify existing doctypes:

1. Use Custom Field from ERPNext UI
2. Or create migration scripts in `nextgen_farmers/patches/`
3. Update fixtures in `nextgen_farmers/fixtures/`

## Contributing

We welcome contributions! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Testing

Run tests using:
```bash
bench --site your-site-name run-tests --app nextgen_farmers
```

## Support

For support and questions:
- **Email**: support@nextgenfarmershub.com
- **Location**: Asylum Down, Samora Mahel Street, Accra, Ghana
- **GitHub Issues**: [Create an issue](https://github.com/your-org/nextgen_farmers/issues)

## License

MIT License

Copyright (c) 2025 NextGen Farmers Hub

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

## Credits

Built with ❤️ for Ghana's youth farmers

Powered by:
- [Frappe Framework](https://frappeframework.com/)
- [ERPNext](https://erpnext.com/)
- [Agriculture Domain](https://github.com/frappe/agriculture)

## Roadmap

### Phase 1 (Current)
- [x] Core cooperative management
- [x] Equipment rental system
- [x] Basic marketplace
- [x] Training management
- [x] Farm operations tracking

### Phase 2 (Planned)
- [ ] Mobile app (Android/iOS)
- [ ] IoT integration for smart farming
- [ ] Advanced analytics and AI predictions
- [ ] Payment gateway integration
- [ ] Multi-language support (English, Twi, Ga)

### Phase 3 (Future)
- [ ] Drone integration for farm monitoring
- [ ] Blockchain for supply chain transparency
- [ ] Integration with Ghana Export Promotion Authority
- [ ] Microfinance and lending module
- [ ] Community engagement features

## Acknowledgments

Special thanks to:
- NextGen Farmers Hub leadership and 515+ members
- Frappe Technologies for the amazing framework
- Open source contributors
- Ghana's agricultural community

---

**Transform individual challenges into collective opportunities** 🌾
