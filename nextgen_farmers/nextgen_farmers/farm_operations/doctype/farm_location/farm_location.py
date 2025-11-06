# Copyright (c) 2025, NextGen Farmers Hub and contributors
# For license information, please see license.txt

import frappe
from frappe.model.document import Document


class FarmLocation(Document):
    def validate(self):
        """Validate farm location data"""
        # Ensure total land area is positive
        if self.total_land_area <= 0:
            frappe.throw("Total land area must be greater than zero")

        # Validate GPS coordinates format if provided
        if self.gps_coordinates:
            self.validate_gps_coordinates()

    def validate_gps_coordinates(self):
        """Validate GPS coordinates format (Latitude, Longitude)"""
        try:
            coords = self.gps_coordinates.split(",")
            if len(coords) != 2:
                raise ValueError
            lat = float(coords[0].strip())
            lon = float(coords[1].strip())

            # Basic validation for Ghana coordinates
            # Ghana: Latitude 4.5°N to 11.5°N, Longitude 3.5°W to 1.3°E
            if not (-11.5 <= lat <= 11.5 and -3.5 <= lon <= 1.3):
                frappe.msgprint("GPS coordinates seem to be outside Ghana. Please verify.")
        except:
            frappe.throw("GPS coordinates must be in format: Latitude, Longitude (e.g., 5.6037, -0.1870)")
