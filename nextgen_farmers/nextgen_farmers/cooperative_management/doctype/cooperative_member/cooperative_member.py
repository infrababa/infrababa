# Copyright (c) 2025, NextGen Farmers Hub and contributors
# For license information, please see license.txt

import frappe
from frappe.model.document import Document
from frappe.utils import nowdate, getdate


class CooperativeMember(Document):
    def before_save(self):
        """Set full name before saving"""
        self.full_name = f"{self.first_name} {self.last_name}"

    def validate(self):
        """Validate member data"""
        # Validate mobile number
        if self.mobile_number:
            self.validate_mobile_number()

        # Validate email uniqueness if provided
        if self.email:
            self.validate_email_unique()

        # Validate age if date of birth is provided
        if self.date_of_birth:
            self.validate_age()

    def validate_mobile_number(self):
        """Ensure mobile number is valid"""
        # Remove spaces and special characters
        mobile = self.mobile_number.replace(" ", "").replace("-", "").replace("+", "")

        # Basic validation - should be numeric and reasonable length
        if not mobile.isdigit():
            frappe.throw("Mobile number should contain only digits")

        if len(mobile) < 9 or len(mobile) > 15:
            frappe.throw("Mobile number should be between 9 and 15 digits")

    def validate_email_unique(self):
        """Ensure email is unique across members"""
        existing = frappe.db.exists(
            "Cooperative Member",
            {"email": self.email, "name": ("!=", self.name)}
        )
        if existing:
            frappe.throw(f"Email {self.email} is already registered with another member")

    def validate_age(self):
        """Validate member age (should be at least 16 years old)"""
        from dateutil.relativedelta import relativedelta
        today = getdate(nowdate())
        dob = getdate(self.date_of_birth)
        age = relativedelta(today, dob).years

        if age < 16:
            frappe.throw("Member must be at least 16 years old to join the cooperative")

    def after_insert(self):
        """After inserting a new member"""
        # Create portal user if portal access is enabled
        if self.portal_access and self.email and not self.user_id:
            self.create_portal_user()

    def create_portal_user(self):
        """Create a portal user for this member"""
        if frappe.db.exists("User", self.email):
            user = frappe.get_doc("User", self.email)
        else:
            user = frappe.get_doc({
                "doctype": "User",
                "email": self.email,
                "first_name": self.first_name,
                "last_name": self.last_name,
                "send_welcome_email": 1,
                "user_type": "Website User"
            })
            user.insert(ignore_permissions=True)

        # Add Cooperative Member role
        if not user.has_role("Cooperative Member"):
            user.add_roles("Cooperative Member")

        # Link user to member
        self.db_set("user_id", user.name)

        frappe.msgprint(f"Portal user created for {self.full_name}")

    def update_financial_totals(self):
        """Update total contributions and profit share"""
        # Get total contributions
        contributions = frappe.db.sql("""
            SELECT SUM(amount) as total
            FROM `tabMember Contribution`
            WHERE member = %s AND docstatus = 1
        """, self.name, as_dict=1)

        self.total_contributions = contributions[0].total or 0

        # Get total profit distributions
        profit_share = frappe.db.sql("""
            SELECT SUM(distribution_amount) as total
            FROM `tabProfit Distribution`
            WHERE member = %s AND docstatus = 1
        """, self.name, as_dict=1)

        self.total_profit_share = profit_share[0].total or 0

        # Calculate outstanding balance
        self.outstanding_balance = self.total_contributions - self.total_profit_share

        self.save()


@frappe.whitelist()
def get_member_dashboard(member):
    """Get dashboard data for a specific member"""
    member_doc = frappe.get_doc("Cooperative Member", member)

    # Get recent contributions
    contributions = frappe.get_all(
        "Member Contribution",
        filters={"member": member, "docstatus": 1},
        fields=["name", "contribution_date", "amount", "payment_method"],
        order_by="contribution_date desc",
        limit=5
    )

    # Get recent profit distributions
    profit_distributions = frappe.get_all(
        "Profit Distribution",
        filters={"member": member, "docstatus": 1},
        fields=["name", "distribution_date", "distribution_amount"],
        order_by="distribution_date desc",
        limit=5
    )

    # Get training programs enrolled
    training_programs = frappe.get_all(
        "Training Attendance",
        filters={"member": member},
        fields=["training_program", "attendance_status"],
        limit=10
    )

    # Get equipment rentals
    equipment_rentals = frappe.get_all(
        "Equipment Rental",
        filters={"member": member},
        fields=["name", "equipment", "rental_start_date", "rental_end_date", "rental_status"],
        order_by="rental_start_date desc",
        limit=5
    )

    return {
        "member": member_doc,
        "contributions": contributions,
        "profit_distributions": profit_distributions,
        "training_programs": training_programs,
        "equipment_rentals": equipment_rentals
    }


@frappe.whitelist()
def get_member_statistics():
    """Get overall member statistics"""
    stats = {
        "total_members": frappe.db.count("Cooperative Member"),
        "active_members": frappe.db.count("Cooperative Member", {"membership_status": "Active"}),
        "pending_approval": frappe.db.count("Cooperative Member", {"membership_status": "Pending Approval"}),
        "new_members_this_month": frappe.db.count(
            "Cooperative Member",
            {
                "join_date": [">=", frappe.utils.get_first_day(nowdate())],
                "join_date": ["<=", nowdate()]
            }
        )
    }

    # Get members by tier
    tier_distribution = frappe.db.sql("""
        SELECT membership_tier, COUNT(*) as count
        FROM `tabCooperative Member`
        WHERE membership_status = 'Active'
        GROUP BY membership_tier
    """, as_dict=1)

    stats["tier_distribution"] = tier_distribution

    return stats
