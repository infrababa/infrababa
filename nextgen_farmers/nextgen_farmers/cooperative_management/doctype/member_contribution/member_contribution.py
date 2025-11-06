# Copyright (c) 2025, NextGen Farmers Hub and contributors
# For license information, please see license.txt

import frappe
from frappe.model.document import Document


class MemberContribution(Document):
    def validate(self):
        """Validate contribution data"""
        # Ensure amount is positive
        if self.amount <= 0:
            frappe.throw("Contribution amount must be greater than zero")

    def on_submit(self):
        """Update member's financial totals when contribution is submitted"""
        # Update member's total contributions and last contribution date
        member = frappe.get_doc("Cooperative Member", self.member)
        member.update_financial_totals()
        member.db_set("last_contribution_date", self.contribution_date)

        # Create Journal Entry if accounting is enabled
        self.create_journal_entry()

    def on_cancel(self):
        """Update member's financial totals when contribution is cancelled"""
        member = frappe.get_doc("Cooperative Member", self.member)
        member.update_financial_totals()

    def create_journal_entry(self):
        """Create a journal entry for the contribution"""
        # This would create a proper accounting entry in ERPNext
        # For now, this is a placeholder for the accounting integration
        pass
