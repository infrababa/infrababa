# Copyright (c) 2025, NextGen Farmers Hub and contributors
# For license information, please see license.txt

import frappe
from frappe.model.document import Document


class MembershipTier(Document):
    def validate(self):
        """Validate membership tier data"""
        # Ensure profit share percentage is between 0 and 100
        if self.profit_share_percentage < 0 or self.profit_share_percentage > 100:
            frappe.throw("Profit share percentage must be between 0 and 100")

        # Ensure minimum contribution is not negative
        if self.minimum_contribution < 0:
            frappe.throw("Minimum contribution cannot be negative")
