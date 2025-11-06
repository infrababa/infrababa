from . import __version__ as app_version

app_name = "nextgen_farmers"
app_title = "NextGen Farmers Hub"
app_publisher = "NextGen Farmers Hub"
app_description = "ERPNext customization for NextGen Farmers Hub - Agricultural Cooperative Management"
app_email = "support@nextgenfarmershub.com"
app_license = "MIT"

# Includes in <head>
# ------------------

# include js, css files in header of desk.html
# app_include_css = "/assets/nextgen_farmers/css/nextgen_farmers.css"
# app_include_js = "/assets/nextgen_farmers/js/nextgen_farmers.js"

# include js, css files in header of web template
# web_include_css = "/assets/nextgen_farmers/css/nextgen_farmers.css"
# web_include_js = "/assets/nextgen_farmers/js/nextgen_farmers.js"

# include custom scss in every website theme (without file extension ".scss")
# website_theme_scss = "nextgen_farmers/public/scss/website"

# include js, css files in header of web form
# webform_include_js = {"doctype": "public/js/doctype.js"}
# webform_include_css = {"doctype": "public/css/doctype.css"}

# include js in page
# page_js = {"page" : "public/js/file.js"}

# include js in doctype views
# doctype_js = {"doctype" : "public/js/doctype.js"}
# doctype_list_js = {"doctype" : "public/js/doctype_list.js"}
# doctype_tree_js = {"doctype" : "public/js/doctype_tree.js"}
# doctype_calendar_js = {"doctype" : "public/js/doctype_calendar.js"}

# Home Pages
# ----------

# application home page (will override Website Settings)
# home_page = "login"

# website user home page (by Role)
# role_home_page = {
#	"Role": "home_page"
# }

# Generators
# ----------

# automatically create page for each record of this doctype
# website_generators = ["Web Page"]

# Jinja
# ----------

# add methods and filters to jinja environment
# jinja = {
# 	"methods": "nextgen_farmers.utils.jinja_methods",
# 	"filters": "nextgen_farmers.utils.jinja_filters"
# }

# Installation
# ------------

# before_install = "nextgen_farmers.install.before_install"
# after_install = "nextgen_farmers.install.after_install"

# Uninstallation
# ------------

# before_uninstall = "nextgen_farmers.uninstall.before_uninstall"
# after_uninstall = "nextgen_farmers.uninstall.after_uninstall"

# Desk Notifications
# -------------------
# See frappe.core.notifications.get_notification_config

# notification_config = "nextgen_farmers.notifications.get_notification_config"

# Permissions
# -----------
# Permissions evaluated in scripted ways

# permission_query_conditions = {
# 	"Event": "frappe.desk.doctype.event.event.get_permission_query_conditions",
# }
#
# has_permission = {
# 	"Event": "frappe.desk.doctype.event.event.has_permission",
# }

# DocType Class
# ---------------
# Override standard doctype classes

# override_doctype_class = {
# 	"ToDo": "custom_app.overrides.CustomToDo"
# }

# Document Events
# ---------------
# Hook on document methods and events

# doc_events = {
# 	"*": {
# 		"on_update": "method",
# 		"on_cancel": "method",
# 		"on_trash": "method"
#	}
# }

# Scheduled Tasks
# ---------------

# scheduler_events = {
# 	"all": [
# 		"nextgen_farmers.tasks.all"
# 	],
# 	"daily": [
# 		"nextgen_farmers.tasks.daily"
# 	],
# 	"hourly": [
# 		"nextgen_farmers.tasks.hourly"
# 	],
# 	"weekly": [
# 		"nextgen_farmers.tasks.weekly"
# 	],
# 	"monthly": [
# 		"nextgen_farmers.tasks.monthly"
# 	],
# }

# Testing
# -------

# before_tests = "nextgen_farmers.install.before_tests"

# Overriding Methods
# ------------------------------
#
# override_whitelisted_methods = {
# 	"frappe.desk.doctype.event.event.get_events": "nextgen_farmers.event.get_events"
# }
#
# each overriding function accepts a `data` argument;
# generated from the base implementation of the doctype dashboard,
# along with any modifications made in other Frappe apps
# override_doctype_dashboards = {
# 	"Task": "nextgen_farmers.task.get_dashboard_data"
# }

# exempt linked doctypes from being automatically cancelled
#
# auto_cancel_exempted_doctypes = ["Auto Repeat"]

# Ignore links to specified DocTypes when deleting documents
# -----------------------------------------------------------

# ignore_links_on_delete = ["Communication", "ToDo"]


# User Data Protection
# --------------------

# user_data_fields = [
# 	{
# 		"doctype": "{doctype_1}",
# 		"filter_by": "{filter_by}",
# 		"redact_fields": ["{field_1}", "{field_2}"],
# 		"partial": 1,
# 	},
# 	{
# 		"doctype": "{doctype_2}",
# 		"filter_by": "{filter_by}",
# 		"partial": 1,
# 	},
# 	{
# 		"doctype": "{doctype_3}",
# 		"strict": False,
# 	},
# 	{
# 		"doctype": "{doctype_4}"
# 	}
# ]

# Authentication and authorization
# --------------------------------

# auth_hooks = [
# 	"nextgen_farmers.auth.validate"
# ]

# Translation
# --------------------------------

# Make link fields search translated document names for these DocTypes
# Recommended only for DocTypes which have limited documents with untranslated names
# For example: Role, Gender, etc.
# translated_search_doctypes = []

# Workspace
workspaces = [
    {
        "module": "NextGen Farmers Hub",
        "app": "nextgen_farmers",
        "label": "NextGen Farmers Hub",
        "link": "nextgen-farmers-hub",
        "category": "Modules",
        "icon": "icon-leaf",
        "color": "#2ecc71",
        "description": "Manage cooperative operations, farms, equipment, marketplace, training and exports"
    }
]

# Website
website_route_rules = [
    {"from_route": "/marketplace/<path:app_path>", "to_route": "marketplace"},
]

# Portal Menu
get_website_user_home_page = "nextgen_farmers.utils.get_home_page"

fixtures = [
    {
        "doctype": "Custom Field",
        "filters": [
            [
                "module",
                "in",
                [
                    "Cooperative Management",
                    "Farm Operations",
                    "Equipment Rental",
                    "Marketplace",
                    "Training Development",
                    "Export Management"
                ]
            ]
        ]
    }
]
