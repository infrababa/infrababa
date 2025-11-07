# NextCRM Branding Guide for NextGen Farmers Hub

## Executive Summary

This guide explains how to modify NextCRM branding to match the NextGen Farmers Hub color scheme. Based on analysis of the Frappe/ERPNext framework (which NextCRM likely uses or follows similar patterns), this document provides a comprehensive approach to implementing custom branding.

---

## 1. Target Color Scheme (NextGen Farmers Hub)

### Primary Brand Colors

| Color Name | Hex Code | Usage |
|------------|----------|-------|
| **Primary Orange** | `#f4511e` | Main brand accent, buttons, highlights |
| **Dark Gray** | `#32373c` | Primary buttons, navigation, text |
| **White** | `#ffffff` | Backgrounds, contrast elements |
| **Black** | `#000000` | Text, typography, borders |

### Design Philosophy
- **Warm & Approachable**: Orange accent creates a welcoming agricultural brand
- **Professional**: Dark gray provides stability and professionalism
- **Clean**: White and black create clear contrast and readability

---

## 2. Frappe/ERPNext Theming Architecture

### 2.1 CSS Variables Structure

Frappe uses a sophisticated CSS variable system that makes theming straightforward:

```scss
:root,
[data-theme="light"] {
  --brand-color: var(--primary);
  --primary-color: var(--gray-900);
  // ... other variables
}

[data-theme="dark"] {
  // Dark theme overrides
}
```

**Key Files:**
- `/frappe/public/scss/espresso/_colors.scss` - Base color palette definitions
- `/frappe/public/scss/common/css_variables.scss` - Common CSS variables
- `/frappe/public/scss/desk/css_variables.scss` - Desktop interface variables
- `/frappe/public/scss/desk/dark.scss` - Dark theme overrides

### 2.2 Color Palette System

Frappe uses a scale system for each color (50-900):
- **50-300**: Light shades (backgrounds, subtle accents)
- **400-600**: Medium shades (UI elements, borders)
- **700-900**: Dark shades (text, emphasis)

---

## 3. Implementation Strategy

### 3.1 Create Custom Orange Palette

Since Frappe has an orange palette but not matching `#f4511e`, create a custom palette:

```scss
:root {
  // NextGen Farmers Hub Orange Palette
  --nextgen-orange-50: #fff5f2;
  --nextgen-orange-100: #ffe8e0;
  --nextgen-orange-200: #ffd0c1;
  --nextgen-orange-300: #ffb8a1;
  --nextgen-orange-400: #ff9a6f;
  --nextgen-orange-500: #f4511e;  // Primary brand color
  --nextgen-orange-600: #dc4619;
  --nextgen-orange-700: #b83b15;
  --nextgen-orange-800: #942f11;
  --nextgen-orange-900: #6b220c;

  // NextGen Farmers Hub Dark Gray
  --nextgen-gray: #32373c;
  --nextgen-gray-light: #494f56;
  --nextgen-gray-lighter: #5f6570;
  --nextgen-gray-dark: #252a2e;
}
```

### 3.2 Override Key Brand Variables

```scss
:root,
[data-theme="light"] {
  // Primary brand color
  --brand-color: var(--nextgen-orange-500);
  --primary: var(--nextgen-orange-500);
  --primary-color: var(--nextgen-orange-500);

  // Update button colors
  --btn-primary: var(--nextgen-orange-500);

  // Update link colors
  --link-color: var(--nextgen-orange-600);

  // Update navbar
  --navbar-bg: var(--nextgen-gray);

  // Update accent colors for UI elements
  --bg-orange: var(--nextgen-orange-50);
  --text-on-orange: var(--nextgen-orange-900);

  // Focus states
  --focus-color: var(--nextgen-orange-500);
  --highlight-color: var(--nextgen-orange-50);
}
```

### 3.3 Dark Theme Considerations

```scss
[data-theme="dark"] {
  --brand-color: var(--nextgen-orange-500);
  --primary: var(--nextgen-orange-500);

  // Adjust for better contrast in dark mode
  --bg-orange: var(--nextgen-orange-800);
  --text-on-orange: var(--nextgen-orange-100);
}
```

---

## 4. Implementation Methods

### Method 1: Website Theme (Recommended for Portal/Public Pages)

**Location:** Tools > Website > Website Settings > Website Theme

1. Navigate to Website Theme doctype
2. In "Custom Overrides" section, add:

```scss
// Override primary brand color before Bootstrap imports
$primary: #f4511e;
$navbar-bg: #32373c;
```

3. In "Custom SCSS" section, add complete theme:

```scss
:root {
  --brand-color: #f4511e !important;
  --primary: #f4511e !important;
  --navbar-bg: #32373c !important;
}

// Buttons
.btn-primary {
  background-color: #f4511e !important;
  border-color: #f4511e !important;

  &:hover {
    background-color: #dc4619 !important;
    border-color: #dc4619 !important;
  }
}

// Links
a {
  color: #f4511e;

  &:hover {
    color: #dc4619;
  }
}

// Navbar
.navbar-main {
  background-color: #32373c !important;
}
```

4. Set theme in Website Settings

### Method 2: Custom App (Recommended for Desk/Backend)

Create a custom Frappe app for branding:

```bash
bench new-app nextgen_theme
bench --site [your-site] install-app nextgen_theme
```

**File Structure:**
```
nextgen_theme/
├── public/
│   ├── scss/
│   │   ├── desk.scss
│   │   └── website.scss
│   └── css/
│       └── (compiled CSS)
└── hooks.py
```

**hooks.py:**
```python
app_name = "nextgen_theme"
app_title = "NextGen Theme"
app_publisher = "Your Company"
app_description = "NextGen Farmers Hub branding for NextCRM"

# Include in Desk
app_include_css = [
    "/assets/nextgen_theme/css/desk.css"
]

# Include in Website
web_include_css = [
    "/assets/nextgen_theme/css/website.css"
]
```

**desk.scss:**
```scss
@import "variables";

// Override Frappe variables
:root {
  @import "nextgen_colors";
}

// Apply to Desk UI
.layout-main-section {
  .btn-primary {
    background-color: var(--brand-color);
    border-color: var(--brand-color);
  }
}
```

### Method 3: Direct CSS Injection (Quick Testing)

For rapid prototyping, use Custom Script:

1. Navigate to: Setup > Customize > Custom Script
2. Create script for "Global" scope:

```javascript
frappe.ready(function() {
  // Inject custom CSS
  const style = document.createElement('style');
  style.textContent = `
    :root {
      --brand-color: #f4511e !important;
      --primary: #f4511e !important;
    }
    .btn-primary {
      background-color: #f4511e !important;
    }
  `;
  document.head.appendChild(style);
});
```

---

## 5. Detailed Component Mapping

### 5.1 Navigation & Headers

```scss
// Top Navbar
.navbar {
  background-color: var(--nextgen-gray);

  .nav-link {
    color: #ffffff;

    &:hover {
      color: var(--nextgen-orange-500);
    }
  }
}

// Sidebar
.sidebar {
  .sidebar-item.selected {
    background-color: var(--nextgen-orange-50);
    border-left: 3px solid var(--nextgen-orange-500);
  }
}
```

### 5.2 Buttons

```scss
// Primary buttons
.btn-primary {
  background-color: var(--nextgen-orange-500);
  border-color: var(--nextgen-orange-500);
  color: white;

  &:hover, &:focus {
    background-color: var(--nextgen-orange-600);
    border-color: var(--nextgen-orange-600);
  }

  &:active {
    background-color: var(--nextgen-orange-700);
  }
}

// Secondary buttons using dark gray
.btn-secondary {
  background-color: var(--nextgen-gray);
  border-color: var(--nextgen-gray);
  color: white;

  &:hover {
    background-color: var(--nextgen-gray-light);
  }
}
```

### 5.3 Forms & Inputs

```scss
// Input focus states
input:focus,
select:focus,
textarea:focus {
  border-color: var(--nextgen-orange-500);
  box-shadow: 0 0 0 0.2rem rgba(244, 81, 30, 0.25);
}

// Radio buttons and checkboxes
input[type="checkbox"]:checked {
  background-color: var(--nextgen-orange-500);
  border-color: var(--nextgen-orange-500);
}

input[type="radio"]:checked {
  background-color: var(--nextgen-orange-500);
}
```

### 5.4 Status Indicators

```scss
// Active/selected states
.indicator-pill.orange,
.indicator-dot.orange {
  background-color: var(--nextgen-orange-500);
}

// Override default "blue" indicators for primary actions
.indicator-pill.blue,
.indicator-dot.blue {
  background-color: var(--nextgen-orange-500);
}
```

### 5.5 Links

```scss
a {
  color: var(--nextgen-orange-600);

  &:hover {
    color: var(--nextgen-orange-700);
    text-decoration: underline;
  }

  &:visited {
    color: var(--nextgen-orange-800);
  }
}

// Sidebar links
.sidebar-menu a.active {
  color: var(--nextgen-orange-600);
  font-weight: 600;
}
```

---

## 6. Testing Checklist

### 6.1 Visual Components to Test

- [ ] Top navigation bar (background, links)
- [ ] Sidebar (selected state, hover state)
- [ ] Primary buttons (default, hover, active, disabled)
- [ ] Secondary buttons
- [ ] Form inputs (focus states)
- [ ] Checkboxes and radio buttons (checked state)
- [ ] Links (default, hover, visited)
- [ ] Status indicators/badges
- [ ] Modal dialogs
- [ ] Dropdown menus
- [ ] Data tables (headers, selected rows)
- [ ] Cards and panels
- [ ] Alerts and notifications
- [ ] Loading spinners/progress bars

### 6.2 Theme Modes

- [ ] Light theme
- [ ] Dark theme (if enabled)
- [ ] Print view

### 6.3 Responsive Testing

- [ ] Desktop (1920px+)
- [ ] Laptop (1366px)
- [ ] Tablet (768px)
- [ ] Mobile (375px)

---

## 7. Advanced Customization

### 7.1 Logo Integration

Update the logo to match NextGen Farmers Hub branding:

**Location:** Website Settings > Brand

1. Upload NextGen Farmers Hub logo
2. Set logo dimensions
3. Configure favicon

### 7.2 Email Templates

Apply branding to email templates:

```html
<style>
  .header {
    background-color: #32373c;
    padding: 20px;
  }

  .button {
    background-color: #f4511e;
    color: white;
    padding: 10px 20px;
    text-decoration: none;
    border-radius: 4px;
  }

  .footer {
    color: #666;
    font-size: 12px;
  }
</style>
```

### 7.3 Print Formats

```scss
@media print {
  :root {
    --brand-color: #f4511e;
  }

  .print-heading {
    color: var(--brand-color);
    border-bottom: 2px solid var(--brand-color);
  }
}
```

---

## 8. Maintenance & Best Practices

### 8.1 Version Control

- Store custom theme files in git repository
- Document all customizations
- Tag releases for each branding update

### 8.2 Performance

- Minimize use of `!important` flags
- Use CSS variables for easy updates
- Compile and minify SCSS in production
- Cache static assets

### 8.3 Accessibility

- Ensure color contrast ratios meet WCAG 2.1 AA standards:
  - **Orange (#f4511e) on White**: Contrast ratio ~3.36:1 (Good for large text)
  - **Dark Gray (#32373c) on White**: Contrast ratio ~11.5:1 (Excellent)
  - **White on Orange**: Contrast ratio ~3.36:1 (Adequate for buttons)

- Test with color blindness simulators
- Provide text labels alongside color indicators

### 8.4 Browser Compatibility

Test on:
- Chrome/Edge (Chromium)
- Firefox
- Safari
- Mobile browsers (iOS Safari, Chrome Mobile)

---

## 9. Quick Start Commands

### If using Bench/Frappe

```bash
# Create theme app
bench new-app nextgen_theme

# Install on site
bench --site [your-site] install-app nextgen_theme

# Build assets
bench build --app nextgen_theme

# Clear cache
bench --site [your-site] clear-cache

# Restart
bench restart
```

### CSS Compilation (if using SCSS)

```bash
# Install dependencies
npm install node-sass

# Compile SCSS
node-sass public/scss/desk.scss public/css/desk.css

# Watch for changes
node-sass --watch public/scss/desk.scss public/css/desk.css
```

---

## 10. Resources & References

### Official Documentation
- [Frappe Website Theme Docs](https://docs.frappe.io/erpnext/user/manual/en/website-theme)
- [Frappe Framework GitHub](https://github.com/frappe/frappe)
- [ERPNext GitHub](https://github.com/frappe/erpnext)

### Color Tools
- [Coolors.co](https://coolors.co) - Color palette generator
- [Color Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Adobe Color](https://color.adobe.com) - Harmony & accessibility testing

### CSS Variables Reference
- [MDN CSS Variables](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties)
- [CSS Tricks: CSS Variables](https://css-tricks.com/guides/css-custom-properties/)

---

## 11. Support & Troubleshooting

### Common Issues

**Issue 1: Colors not applying**
- Clear browser cache (Ctrl+Shift+R)
- Clear Frappe cache: `bench --site [site] clear-cache`
- Check CSS specificity - use browser DevTools
- Verify CSS variable syntax

**Issue 2: Dark theme issues**
- Ensure dark theme overrides are defined
- Test contrast ratios in dark mode
- Adjust orange shade for dark backgrounds

**Issue 3: Build errors**
- Check SCSS syntax
- Verify import paths
- Run `bench build --app [app_name]` with verbose flag

### Getting Help
- Frappe Forum: https://discuss.frappe.io
- ERPNext Documentation
- Community Discord/Slack channels

---

## Appendix A: Complete Color Reference

### NextGen Farmers Hub Colors with Extended Palette

```scss
:root {
  // PRIMARY ORANGE (Main Brand)
  --nextgen-orange-50:  #fff5f2;  // Lightest - backgrounds
  --nextgen-orange-100: #ffe8e0;  // Very light - hover states
  --nextgen-orange-200: #ffd0c1;  // Light - disabled states
  --nextgen-orange-300: #ffb8a1;  // Light-medium - borders
  --nextgen-orange-400: #ff9a6f;  // Medium-light - icons
  --nextgen-orange-500: #f4511e;  // BRAND PRIMARY
  --nextgen-orange-600: #dc4619;  // Medium-dark - hover
  --nextgen-orange-700: #b83b15;  // Dark - active states
  --nextgen-orange-800: #942f11;  // Very dark - shadows
  --nextgen-orange-900: #6b220c;  // Darkest - text on light

  // SECONDARY DARK GRAY (Navigation, Headers)
  --nextgen-gray-50:     #f0f1f2;  // Lightest
  --nextgen-gray-100:    #d8dadc;  // Very light
  --nextgen-gray-200:    #b0b4b8;  // Light
  --nextgen-gray-300:    #888d94;  // Medium-light
  --nextgen-gray-400:    #5f6570;  // Medium
  --nextgen-gray-500:    #32373c;  // BRAND SECONDARY
  --nextgen-gray-600:    #2d3136;  // Medium-dark
  --nextgen-gray-700:    #252a2e;  // Dark
  --nextgen-gray-800:    #1e2227;  // Very dark
  --nextgen-gray-900:    #16191d;  // Darkest

  // NEUTRAL (White/Black)
  --nextgen-white:       #ffffff;
  --nextgen-black:       #000000;
  --nextgen-off-white:   #fafafa;
  --nextgen-off-black:   #0a0a0a;
}
```

### Usage Examples by Component

| Component | Color Variable | Hex Value |
|-----------|---------------|-----------|
| Primary Button | `--nextgen-orange-500` | `#f4511e` |
| Primary Button Hover | `--nextgen-orange-600` | `#dc4619` |
| Top Navbar | `--nextgen-gray-500` | `#32373c` |
| Sidebar Active Item | `--nextgen-orange-50` background, `--nextgen-orange-500` border | `#fff5f2`, `#f4511e` |
| Form Focus Border | `--nextgen-orange-500` | `#f4511e` |
| Link Default | `--nextgen-orange-600` | `#dc4619` |
| Link Hover | `--nextgen-orange-700` | `#b83b15` |

---

## Appendix B: Sample Complete Theme File

```scss
// File: nextgen_theme/public/scss/variables.scss

// Import base Frappe colors
@import "frappe/public/scss/espresso/colors";

// NextGen Farmers Hub Color Overrides
$primary: #f4511e;
$danger: #e03636;  // Keep Frappe's red for errors

// Define NextGen palette
:root {
  // Extended Orange Palette
  --nextgen-orange-50:  #fff5f2;
  --nextgen-orange-100: #ffe8e0;
  --nextgen-orange-200: #ffd0c1;
  --nextgen-orange-300: #ffb8a1;
  --nextgen-orange-400: #ff9a6f;
  --nextgen-orange-500: #f4511e;
  --nextgen-orange-600: #dc4619;
  --nextgen-orange-700: #b83b15;
  --nextgen-orange-800: #942f11;
  --nextgen-orange-900: #6b220c;

  // Gray Palette
  --nextgen-gray-500: #32373c;
  --nextgen-gray-600: #2d3136;
  --nextgen-gray-400: #5f6570;

  // Brand Color Assignments
  --brand-color: var(--nextgen-orange-500);
  --primary: var(--nextgen-orange-500);
  --primary-color: var(--nextgen-orange-500);

  // Update component colors
  --btn-primary: var(--nextgen-orange-500);
  --navbar-bg: var(--nextgen-gray-500);
  --sidebar-select-color: var(--nextgen-orange-50);
  --link-color: var(--nextgen-orange-600);

  // Focus states
  --focus-color: var(--nextgen-orange-500);
  --highlight-color: var(--nextgen-orange-50);

  // Borders
  --border-primary: var(--nextgen-orange-500);
}

// File: nextgen_theme/public/scss/desk.scss

@import "variables";
@import "frappe/public/scss/desk/variables";

// Apply theme to Desk components

// Buttons
.btn-primary {
  background-color: var(--brand-color);
  border-color: var(--brand-color);

  &:hover:not(:disabled) {
    background-color: var(--nextgen-orange-600);
    border-color: var(--nextgen-orange-600);
  }

  &:active:not(:disabled) {
    background-color: var(--nextgen-orange-700);
    border-color: var(--nextgen-orange-700);
  }

  &:focus {
    box-shadow: 0 0 0 0.2rem rgba(244, 81, 30, 0.25);
  }
}

// Navbar
.navbar {
  background-color: var(--navbar-bg);

  .navbar-brand {
    color: white;
  }

  .nav-link {
    color: rgba(255, 255, 255, 0.9);

    &:hover {
      color: var(--nextgen-orange-400);
    }
  }
}

// Sidebar
.desk-sidebar {
  .sidebar-item {
    &.selected,
    &.active {
      background-color: var(--sidebar-select-color);
      border-left: 3px solid var(--brand-color);
      color: var(--nextgen-orange-700);
    }

    &:hover:not(.selected) {
      background-color: var(--nextgen-orange-50);
    }
  }
}

// Forms
.form-control:focus {
  border-color: var(--brand-color);
  box-shadow: 0 0 0 0.2rem rgba(244, 81, 30, 0.15);
}

// Checkboxes
input[type="checkbox"]:checked {
  background-color: var(--brand-color);
  border-color: var(--brand-color);
}

// Links
a:not(.btn) {
  color: var(--link-color);

  &:hover {
    color: var(--nextgen-orange-700);
  }
}

// Indicators
.indicator-pill {
  &.blue,
  &.orange {
    background-color: var(--nextgen-orange-100);
    color: var(--nextgen-orange-700);
  }
}

.indicator-dot {
  &.blue,
  &.orange {
    background-color: var(--brand-color);
  }
}
```

---

## Conclusion

This guide provides a comprehensive approach to rebranding NextCRM with the NextGen Farmers Hub color scheme. The implementation leverages Frappe/ERPNext's CSS variable system for maintainable, scalable theming.

**Key Takeaways:**
1. Use CSS variables for easy maintenance
2. Test thoroughly across all components and themes
3. Maintain accessibility standards
4. Document all customizations
5. Version control your theme files

For questions or support, consult the Frappe community forums or official documentation.

---

**Document Version:** 1.0
**Last Updated:** 2025-11-07
**Author:** Generated from Frappe/ERPNext Analysis
**Target Framework:** Frappe Framework / ERPNext / NextCRM
