# Copyright (c) 2025, NextGen Farmers Hub and contributors
# For license information, please see license.txt

import frappe
from frappe.model.document import Document


class FarmPlot(Document):
    def validate(self):
        """Validate farm plot data"""
        # Ensure plot size is positive
        if self.plot_size <= 0:
            frappe.throw("Plot size must be greater than zero")

        # Validate soil pH if provided
        if self.soil_ph and (self.soil_ph < 0 or self.soil_ph > 14):
            frappe.throw("Soil pH must be between 0 and 14")
