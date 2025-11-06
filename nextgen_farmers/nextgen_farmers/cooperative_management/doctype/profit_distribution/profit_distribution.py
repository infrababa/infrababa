# Copyright (c) 2025, NextGen Farmers Hub and contributors
# For license information, please see license.txt

import frappe
from frappe.model.document import Document


class ProfitDistribution(Document):
    def validate(self):
        """Validate profit distribution data"""
        # Ensure distribution amount is positive
        if self.distribution_amount <= 0:
            frappe.throw("Distribution amount must be greater than zero")

        # Ensure period_to is after period_from
        if self.period_to < self.period_from:
            frappe.throw("Period To must be after Period From")

    def on_submit(self):
        """Update member's profit share when distribution is submitted"""
        member = frappe.get_doc("Cooperative Member", self.member)
        member.update_financial_totals()

    def on_cancel(self):
        """Update member's profit share when distribution is cancelled"""
        member = frappe.get_doc("Cooperative Member", self.member)
        member.update_financial_totals()


@frappe.whitelist()
def calculate_profit_distribution(period_from, period_to, total_profit):
    """
    Calculate profit distribution for all active members based on their contributions
    and membership tier during the specified period
    """
    # Get all active members
    members = frappe.get_all(
        "Cooperative Member",
        filters={"membership_status": "Active"},
        fields=["name", "full_name", "membership_tier"]
    )

    distributions = []

    # Calculate total contributions during the period
    total_contributions = frappe.db.sql("""
        SELECT SUM(amount) as total
        FROM `tabMember Contribution`
        WHERE docstatus = 1
        AND contribution_date BETWEEN %s AND %s
    """, (period_from, period_to), as_dict=1)[0].total or 0

    if total_contributions == 0:
        frappe.throw("No contributions found in the specified period")

    for member in members:
        # Get member's contributions during the period
        member_contribution = frappe.db.sql("""
            SELECT SUM(amount) as total
            FROM `tabMember Contribution`
            WHERE member = %s
            AND docstatus = 1
            AND contribution_date BETWEEN %s AND %s
        """, (member.name, period_from, period_to), as_dict=1)[0].total or 0

        if member_contribution > 0:
            # Calculate member's percentage
            member_percentage = (member_contribution / total_contributions) * 100

            # Get tier multiplier
            tier = frappe.get_doc("Membership Tier", member.membership_tier)
            tier_multiplier = 1 + (tier.profit_share_percentage / 100)

            # Calculate distribution amount
            base_amount = (member_contribution / total_contributions) * float(total_profit)
            distribution_amount = base_amount * tier_multiplier

            distributions.append({
                "member": member.name,
                "member_name": member.full_name,
                "member_contribution": member_contribution,
                "member_percentage": member_percentage,
                "distribution_amount": distribution_amount
            })

    return distributions
