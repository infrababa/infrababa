# Copyright (c) 2025, NextGen Farmers Hub and contributors
# For license information, please see license.txt

import frappe
from frappe.model.document import Document
from frappe.utils import date_diff, time_diff_in_hours, get_datetime


class EquipmentRental(Document):
    def validate(self):
        """Validate equipment rental data"""
        # Ensure rental end date is after start date
        if self.rental_end_date < self.rental_start_date:
            frappe.throw("Rental End Date must be after Rental Start Date")

        # Calculate rental period
        self.calculate_rental_period()

        # Calculate total amount
        self.calculate_total_amount()

        # Check equipment availability
        self.check_equipment_availability()

    def calculate_rental_period(self):
        """Calculate total rental days and hours"""
        self.total_rental_days = date_diff(self.rental_end_date, self.rental_start_date) + 1

        if self.rental_start_time and self.rental_end_time:
            # Calculate hours if time is provided
            start_datetime = get_datetime(f"{self.rental_start_date} {self.rental_start_time}")
            end_datetime = get_datetime(f"{self.rental_end_date} {self.rental_end_time}")
            self.total_rental_hours = time_diff_in_hours(end_datetime, start_datetime)

    def calculate_total_amount(self):
        """Calculate total rental amount"""
        total = 0

        if self.rental_rate_per_hour and self.total_rental_hours:
            total = self.rental_rate_per_hour * self.total_rental_hours
        elif self.rental_rate_per_day and self.total_rental_days:
            total = self.rental_rate_per_day * self.total_rental_days

        # Add delivery fee if applicable
        if self.delivery_required and self.delivery_fee:
            total += self.delivery_fee

        self.total_rental_amount = total
        self.balance_amount = total - (self.deposit_amount or 0)

    def check_equipment_availability(self):
        """Check if equipment is available for the requested period"""
        if self.name:
            # Exclude current document when checking
            exclude_condition = f"AND name != '{self.name}'"
        else:
            exclude_condition = ""

        overlapping_rentals = frappe.db.sql(f"""
            SELECT name
            FROM `tabEquipment Rental`
            WHERE equipment = %s
            AND rental_status IN ('Booked', 'In Use')
            AND docstatus != 2
            AND (
                (rental_start_date BETWEEN %s AND %s)
                OR (rental_end_date BETWEEN %s AND %s)
                OR (rental_start_date <= %s AND rental_end_date >= %s)
            )
            {exclude_condition}
        """, (self.equipment, self.rental_start_date, self.rental_end_date,
              self.rental_start_date, self.rental_end_date,
              self.rental_start_date, self.rental_end_date))

        if overlapping_rentals:
            frappe.throw(
                f"Equipment {self.equipment} is already booked for the selected period. "
                f"Conflicting rental: {overlapping_rentals[0][0]}"
            )

    def on_submit(self):
        """Mark equipment as unavailable when rental is confirmed"""
        if self.rental_status == "Booked":
            self.rental_status = "In Use"
            self.save()


@frappe.whitelist()
def get_available_equipment(start_date, end_date):
    """Get list of equipment available for a given period"""
    booked_equipment = frappe.db.sql("""
        SELECT DISTINCT equipment
        FROM `tabEquipment Rental`
        WHERE rental_status IN ('Booked', 'In Use')
        AND docstatus != 2
        AND (
            (rental_start_date BETWEEN %s AND %s)
            OR (rental_end_date BETWEEN %s AND %s)
            OR (rental_start_date <= %s AND rental_end_date >= %s)
        )
    """, (start_date, end_date, start_date, end_date, start_date, end_date), as_list=1)

    booked_equipment_list = [eq[0] for eq in booked_equipment]

    # Get all equipment (Assets with category "Equipment")
    filters = {"docstatus": 1, "status": "In Location"}
    if booked_equipment_list:
        filters["name"] = ["not in", booked_equipment_list]

    available_equipment = frappe.get_all(
        "Asset",
        filters=filters,
        fields=["name", "asset_name", "item_code", "location"]
    )

    return available_equipment
