# USER INTERFACE & FUNCTIONALITY GUIDE
## Beau Bassin Elderly Care Hostel Management System

---

## TABLE OF CONTENTS

1. [Application Launch & Onboarding](#application-launch)
2. [Authentication Screens](#authentication-screens)
3. [Admin Portal](#admin-portal)
4. [Customer/Resident Portal](#customer-resident-portal)
5. [Settings & Additional Features](#settings-features)
6. [Navigation Flow](#navigation-flow)

---

## APPLICATION LAUNCH

### 1. SPLASH SCREEN

**File**: `lib/screens/splash_screen.dart`

**Purpose**: 
The splash screen is the first screen users see when launching the application. It provides a welcoming introduction to the app while loading necessary resources in the background.

**Visual Design**:
- **Background Image**: Professional elderly care photograph showing a caregiver with an elderly person
- **Gradient Overlay**: Dark gradient overlay (black with 60% opacity) to ensure text readability
- **App Logo**: White circular container with a heart icon in teal color
- **App Name**: "ElderCare" in large white text
- **Tagline**: "Caring for Your Loved Ones" subtitle
- **Loading Indicator**: Circular progress indicator at the bottom

**Functionality**:
- Displays for 4 seconds automatically
- Shows brand identity and sets professional tone
- Provides visual feedback with loading indicator
- Automatically navigates to Welcome Screen after timer expires
- No user interaction required

**Technical Implementation**:
```dart
Timer(Duration(seconds: 4), () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => WelcomeScreen()),
  );
});
```

**User Experience**:
- Creates professional first impression
- Gives users time to prepare for interaction
- Sets visual theme with elderly care imagery
- Smooth transition to next screen

---

### 2. WELCOME SCREEN

**File**: `lib/screens/welcome_screen.dart`

**Purpose**:
The welcome screen serves as the main entry point where users choose their role and navigate to the appropriate login portal. It acts as a router directing different types of users to their respective interfaces.

**Visual Design**:
- **Clean Layout**: Centered content with ample white space
- **App Branding**: Logo and app name at the top
- **Welcome Message**: "Welcome to ElderCare" heading
- **Subtitle**: Brief description of the system
- **Two Large Buttons**:
  - "Admin Portal" - Teal button with shield icon
  - "Resident/Visitor Login" - Blue button with person icon

**Functionality**:

**Button 1: Admin Portal**
- **Icon**: Shield icon indicating security/authority
- **Action**: Navigates to Admin Login Screen
- **Target Users**: Facility administrators and staff
- **Color**: Teal (#1FC8DB)

**Button 2: Resident/Visitor Login**
- **Icon**: Person icon indicating customer access
- **Action**: Navigates to Customer Login Screen
- **Target Users**: Residents and their family/visitors
- **Color**: Blue

**User Flow**:
```
Welcome Screen
├── Admin Portal → Admin Login → Admin Dashboard
└── Resident/Visitor Login → Customer Login → Resident Dashboard
```

**Technical Implementation**:
- Two distinct navigation paths
- Clear visual separation between user roles
- Easy-to-understand interface for elderly users
- Large touch targets for accessibility

**User Experience**:
- Immediately clear role separation
- Simple two-choice decision
- No confusion about which button to press
- Professional and inviting design

---

## AUTHENTICATION SCREENS

### 3. ADMIN LOGIN SCREEN

**File**: `lib/screens/auth/admin_login_screen.dart`

**Purpose**:
Secure authentication portal exclusively for facility administrators. This screen verifies admin credentials and ensures only authorized staff can access resident management features.

**Visual Design**:
- **Background**: Professional elderly care image with gradient overlay
- **Header Section**:
  - App logo in white circular container
  - "Administrator Login" title in large text
  - Subtitle explaining admin access
- **Login Card**:
  - White elevated card with rounded corners
  - Clean form layout with proper spacing
  - Professional color scheme

**Form Fields**:

**1. Email Field**
- **Label**: "Email"
- **Icon**: Email envelope icon
- **Placeholder**: "Enter admin email"
- **Validation**: 
  - Required field
  - Must be valid email format
  - Example: lindiwe.motaung@umail.utm.ac.mu
- **Keyboard Type**: Email keyboard

**2. Password Field**
- **Label**: "Password"
- **Icon**: Lock icon
- **Placeholder**: "Enter password"
- **Validation**:
  - Required field
  - Minimum 6 characters
- **Features**:
  - Password obscured by default
  - Eye icon to show/hide password
  - Secure input

**3. Remember Me Checkbox**
- Optional feature to save email for next login
- Does not save password for security
- Persists using SharedPreferences

**Action Buttons**:

**Login Button**:
- Full-width button in teal color
- Text: "Login"
- Shows loading spinner during authentication
- Disabled while processing
- Validates form before submitting

**Back Button**:
- Located at top-left
- Returns to Welcome Screen
- Arrow icon for intuitive navigation

**Functionality**:

**Login Process**:
1. User enters email and password
2. Form validation checks both fields
3. If valid, attempts authentication with Supabase
4. Verifies user has 'admin' role in metadata
5. On success: Navigates to Admin Dashboard
6. On failure: Shows error message via SnackBar

**Error Handling**:
- Invalid email format → "Please enter a valid email"
- Wrong credentials → "Invalid email or password"
- Not an admin → "Access denied. Admin privileges required"
- Network error → "Connection error. Please try again"

**Security Features**:
- JWT token authentication
- Role-based access control
- Password never stored locally
- Secure session management
- Failed attempt logging (Supabase built-in)

**Test Credentials**:
- Email: lindiwe.motaung@umail.utm.ac.mu
- Password: [Set in Supabase]
- Role: admin (in user metadata)

---

### 4. CUSTOMER REGISTRATION SCREEN

**File**: `lib/screens/auth/customer_register_screen.dart`

**Purpose**:
Allows new residents and visitors to create accounts in the system. Provides comprehensive registration form with validation and role selection.

**Visual Design**:
- **Background**: Elderly care image with white gradient overlay
- **Header**:
  - App logo and branding
  - "Create Account" title
  - Subtitle encouraging registration
- **Registration Form**:
  - White card with elevated shadow
  - Vertical layout with proper spacing
  - Clear field labels and icons

**Form Fields**:

**1. Full Name**
- **Label**: "Full Name"
- **Icon**: Person icon
- **Placeholder**: "Enter your full name"
- **Validation**:
  - Required field
  - Minimum 2 characters
  - Only letters and spaces allowed
- **Example**: "Margaret Smith"

**2. Email Address**
- **Label**: "Email"
- **Icon**: Email icon
- **Placeholder**: "Enter your email address"
- **Validation**:
  - Required field
  - Valid email format
  - Must be unique (checked by Supabase)
- **Example**: "margaret.smith@test.com"
- **Keyboard**: Email keyboard

**3. Password**
- **Label**: "Password"
- **Icon**: Lock icon
- **Placeholder**: "Create a password"
- **Validation**:
  - Required field
  - Minimum 6 characters
  - Should contain letters and numbers (recommended)
- **Features**:
  - Obscured by default
  - Toggle visibility icon
  - Strength indicator (future enhancement)

**4. Confirm Password**
- **Label**: "Confirm Password"
- **Icon**: Lock icon
- **Placeholder**: "Re-enter your password"
- **Validation**:
  - Required field
  - Must match password field exactly
- **Real-time matching**: Shows error if passwords don't match

**5. Role Selection**
- **Label**: "I am registering as"
- **Icon**: Group icon
- **Type**: Dropdown menu
- **Options**:
  - "Resident" - For elderly residents of the facility
  - "Visitor" - For family members and friends
- **Validation**: Required selection
- **Default**: No selection (forces user to choose)

**6. Terms and Conditions**
- **Type**: Checkbox
- **Label**: "I agree to the Terms and Conditions"
- **Validation**: Must be checked to register
- **Link**: Terms are clickable (future: show dialog with full terms)

**Action Buttons**:

**Register Button**:
- Full-width button in teal color
- Text: "Create Account"
- Validates all fields before submission
- Shows loading spinner during process
- Disabled during registration process

**Already Have Account Link**:
- Text: "Already have an account? Login"
- Links to Customer Login Screen
- Helpful for users who navigate here by mistake

**Functionality**:

**Registration Process**:
1. User fills all form fields
2. Client-side validation checks:
   - Name is valid
   - Email format is correct
   - Passwords match
   - Password meets minimum length
   - Role is selected
   - Terms are accepted
3. If all valid, submit to Supabase Auth
4. Supabase creates user account with:
   - Email and hashed password
   - User metadata: {role: 'resident' or 'visitor', name: 'Full Name'}
5. If resident role, also creates entry in residents table
6. Success: Show confirmation message
7. Auto-navigate to login screen
8. User can now login with new credentials

**Error Handling**:
- Email already exists → "This email is already registered"
- Weak password → "Password must be at least 6 characters"
- Network error → "Registration failed. Please try again"
- Invalid input → Field-specific error messages

**User Experience**:
- Clear, step-by-step form
- Immediate validation feedback
- Large input fields for accessibility
- Helpful error messages
- Success confirmation
- Automatic redirect to login

---

### 5. CUSTOMER LOGIN SCREEN

**File**: `lib/screens/auth/customer_login_screen.dart`

**Purpose**:
Authentication portal for residents and visitors. Provides secure login with role-based routing to appropriate dashboards.

**Visual Design**:
- **Background**: Professional elderly care photograph
- **Gradient Overlay**: White gradient (90-95% opacity) for readability
- **Header Section**:
  - Circular white logo container with heart icon
  - "Welcome Back" heading
  - "Login to continue" subtitle
- **Login Card**:
  - White elevated card
  - Clean form design
  - Teal accent color for branding

**Form Fields**:

**1. Email Field**
- **Label**: "Email"
- **Icon**: Email envelope icon
- **Placeholder**: "Enter your email"
- **Validation**:
  - Required field
  - Valid email format
- **Auto-fill Support**: Compatible with browser/OS auto-fill
- **Keyboard**: Email keyboard type

**2. Password Field**
- **Label**: "Password"
- **Icon**: Lock icon
- **Placeholder**: "Enter your password"
- **Validation**: Required field
- **Features**:
  - Text obscured by default
  - Show/hide toggle button (eye icon)
  - Secure input mode

**Additional Features**:

**Remember Me Checkbox**:
- Located below password field
- Saves email (not password) locally
- Persists using SharedPreferences
- Pre-fills email on next visit
- Opt-in feature for convenience

**Forgot Password Link**:
- Text link below form
- Opens password reset flow
- Sends reset email via Supabase
- User receives link to create new password

**Action Buttons**:

**Login Button**:
- Full-width button
- Teal background color (#1FC8DB)
- White text
- Shows loading spinner during authentication
- Disabled while processing
- Text: "Login"

**Register Link**:
- Below login button
- Text: "Don't have an account? Register"
- Navigates to Customer Registration Screen
- Blue color to differentiate from button

**Functionality**:

**Login Process**:
1. User enters email and password
2. Optional: Check "Remember me"
3. Click "Login" button
4. Form validation runs
5. If valid, authenticate with Supabase Auth
6. Retrieve user metadata to check role
7. Based on role:
   - If 'resident' → Navigate to Resident Dashboard
   - If 'visitor' → Navigate to Visitor Dashboard (future)
8. Session token stored automatically by Supabase
9. User remains logged in until logout or token expiry

**Remember Me Feature**:
- When checked:
  - Saves email to SharedPreferences
  - Sets remember_me flag
- On next app launch:
  - Checks for saved email
  - Pre-fills email field if found
  - User only needs to enter password

**Error Handling**:
- Wrong credentials → "Invalid email or password"
- Account doesn't exist → "No account found. Please register"
- Network error → "Connection failed. Check your internet"
- Account disabled → "Your account has been suspended. Contact admin"

**Security Features**:
- Password never stored locally
- JWT token authentication
- Session timeout handling
- Secure password transmission (HTTPS)
- Failed attempt tracking

**User Experience**:
- Clean, uncluttered interface
- Large touch targets for elderly users
- Clear visual feedback
- Helpful error messages
- Quick access to password reset
- Easy navigation to registration

**Test Accounts**:

**Resident Account**:
- Email: margaret.smith@test.com
- Password: Margaret123
- Expected: Navigate to Resident Dashboard

**Visitor Account**:
- Email: visitor@test.com
- Password: Visitor123
- Expected: Navigate to Visitor Dashboard

---

## ADMIN PORTAL

### 6. ADMIN DASHBOARD

**File**: `lib/screens/admin/admin_dashboard.dart`

**Purpose**:
Central hub for all administrative functions. Provides administrators with tools to manage residents, track health information, schedule activities, and approve visit requests.

**Visual Design**:
- **App Bar**:
  - Title: "Admin Dashboard"
  - Teal background color
  - White text
  - Logout icon button (top-right)
- **Tab Bar**:
  - 4 tabs with icons and labels
  - Selected tab highlighted in teal
  - Unselected tabs in grey
  - Smooth tab switching animation

**Navigation Structure**:

The admin dashboard uses a tab-based navigation system with 4 main sections:

```
Admin Dashboard
├── Tab 1: View Residents
├── Tab 2: Record Vitals
├── Tab 3: Manage Schedules
└── Tab 4: Approve Visits
```

---

### TAB 1: VIEW RESIDENTS

**Purpose**:
Complete resident management with CRUD (Create, Read, Update, Delete) operations. Administrators can view all residents, add new ones, edit information, and remove residents.

**Visual Layout**:

**Header Section**:
- Page title: "Residents"
- Search bar for finding residents by name
- Filter button (future: filter by room, age, etc.)

**Main Content**:
- **Grid View** of resident cards
- 2 columns on desktop, 1 on mobile
- Each card contains resident summary

**Resident Card Design**:
```
┌─────────────────────────────────────┐
│  👤 [Profile Picture Placeholder]   │
│                                     │
│  Margaret Smith                     │
│  Room: 204 | Age: 76               │
│  Blood Type: O+                     │
│                                     │
│  [View Details] [Edit] [Delete]    │
└─────────────────────────────────────┘
```

**Card Information**:
- Profile photo placeholder (circular)
- Full name in bold
- Room number and age
- Blood type
- Quick action buttons

**Floating Action Button (FAB)**:
- Located at bottom-right
- "+" icon
- Teal background
- Opens "Add New Resident" dialog
- Always visible while scrolling

**Functionality**:

**1. View All Residents**:
- Displays all residents in grid format
- Shows key information on each card
- Tap card to view full details
- Scrollable list if many residents

**2. Search Residents**:
- Search bar at top
- Real-time filtering as user types
- Searches by name
- Case-insensitive search

**3. View Resident Details**:
- Tap any card to open detail dialog
- Shows complete information:
  - Personal: Name, age, room, phone, email
  - Medical: Blood type, allergies, medications
  - Emergency: Contact name and phone
  - Care: Care notes from staff
  - History: Admission date, last updated

**4. Add New Resident**:
- Click FAB button
- Opens "Add Resident" form dialog
- Required fields:
  - Full name
  - Age
  - Room number
- Optional fields:
  - Phone number
  - Email address
  - Blood type
  - Allergies (text area)
  - Current medications (multi-line)
  - Emergency contact name
  - Emergency contact phone
  - Care notes
- Validation on required fields
- Save button submits to database
- Cancel button closes without saving

**5. Edit Resident**:
- Click "Edit" button on card
- Opens same form as Add, pre-filled with current data
- All fields editable
- Save updates database
- Cancel discards changes
- Updated timestamp recorded

**6. Delete Resident**:
- Click "Delete" button on card
- Shows confirmation dialog:
  - "Are you sure you want to delete [Name]?"
  - Warning: "This action cannot be undone"
  - "Cancel" and "Delete" buttons
- If confirmed:
  - Deletes resident from database
  - Cascades to related records (vitals, activities, visits)
  - Shows success message
  - Refreshes resident list

**Empty State**:
- When no residents in system
- Icon: Empty box illustration
- Message: "No residents yet"
- Action: "Click + to add first resident"

**User Experience**:
- Large, readable cards
- Clear action buttons
- Confirmation for destructive actions
- Loading indicators during operations
- Success/error feedback messages
- Smooth animations

---

### TAB 2: RECORD VITALS

**Purpose**:
Record and track health vital signs for residents. Allows staff to document blood pressure, heart rate, temperature, oxygen levels, and notes.

**Visual Layout**:

**Form Structure**:
- Single-column form layout
- Clear section headers
- Large input fields
- Helpful hints and units

**Form Sections**:

**1. Resident Selection**
- **Field Type**: Dropdown menu
- **Label**: "Select Resident"
- **Icon**: Person icon
- **Content**: List of all residents (name + room)
- **Validation**: Required
- **Example**: "Margaret Smith (Room 204)"
- **Hint**: "Choose resident to record vitals for"

**2. Vital Signs Input Fields**

**Blood Pressure**:
- **Label**: "Blood Pressure"
- **Icon**: Heart pulse icon
- **Format**: "Systolic/Diastolic"
- **Placeholder**: "120/80"
- **Unit**: mmHg
- **Validation**: Format XXX/XXX
- **Example**: "120/80"
- **Help Text**: "Normal: 90/60 to 120/80"

**Heart Rate**:
- **Label**: "Heart Rate"
- **Icon**: Heart icon
- **Input Type**: Number
- **Placeholder**: "72"
- **Unit**: BPM (Beats Per Minute)
- **Validation**: 40-200 range
- **Example**: "72"
- **Help Text**: "Normal: 60-100 BPM"

**Body Temperature**:
- **Label**: "Temperature"
- **Icon**: Thermometer icon
- **Input Type**: Decimal number
- **Placeholder**: "36.8"
- **Unit**: °C (Celsius)
- **Validation**: 35-42 range
- **Example**: "36.8"
- **Help Text**: "Normal: 36.5-37.5°C"

**Oxygen Saturation**:
- **Label**: "Oxygen Level"
- **Icon**: Oxygen tank icon
- **Input Type**: Number
- **Placeholder**: "98"
- **Unit**: % (Percentage)
- **Validation**: 0-100 range
- **Example**: "98"
- **Help Text**: "Normal: 95-100%"
- **Warning**: Red text if below 90%

**3. Additional Notes**
- **Label**: "Notes"
- **Icon**: Notepad icon
- **Field Type**: Multi-line text area
- **Placeholder**: "Any observations or concerns..."
- **Optional**: Yes
- **Max Length**: 500 characters
- **Example**: "Patient feeling well. No complaints. Active during morning walk."

**Action Buttons**:

**Record Vitals Button**:
- Full-width button at bottom
- Teal background
- White text
- Icon: Save icon
- Validates all fields
- Shows loading spinner
- Disabled during save

**Clear Form Button**:
- Outline button
- Clears all fields
- Confirmation: "Are you sure?"
- Resets to empty state

**Functionality**:

**Recording Process**:
1. Admin selects resident from dropdown
2. Enters all vital measurements
3. Adds optional notes
4. Clicks "Record Vitals" button
5. System validates all inputs
6. If valid:
   - Saves to health_vitals table
   - Records timestamp automatically
   - Shows success message
   - Form clears for next entry
7. If invalid:
   - Shows field-specific errors
   - Highlights problematic fields
   - Form retains entered data

**Data Storage**:
- Saved to health_vitals table
- Links to resident via resident_id
- Includes recorded_at timestamp
- All vitals stored as specified
- Notes saved as text

**Validation Rules**:
- Resident selection: Required
- Blood pressure: Must match format XXX/XXX
- Heart rate: Must be 40-200
- Temperature: Must be 35.0-42.0
- Oxygen level: Must be 0-100
- Notes: Optional, max 500 chars

**Visual Indicators**:
- Normal values: Green checkmark
- Borderline values: Yellow warning
- Concerning values: Red alert icon
- Required fields: Asterisk (*)

**Success Feedback**:
- Green SnackBar appears
- Message: "Vitals recorded successfully for [Resident Name]"
- Checkmark icon
- Auto-dismisses after 3 seconds

**User Experience**:
- Clear, organized form layout
- Helpful hints for normal ranges
- Visual feedback for values
- Easy data entry with proper keyboards
- Quick clear and save options
- Immediate confirmation

---

### TAB 3: MANAGE SCHEDULES

**Purpose**:
Create and manage daily activity schedules for residents. Allows administrators to plan activities for each day of the week and assign them to specific residents.

**Visual Layout**:

**Day Selector**:
- Horizontal chip-based selector
- 7 chips for each day (Mon-Sun)
- Selected day highlighted in teal
- Unselected days in grey
- Tap to switch days

**Activity List**:
- Scrollable list of activities for selected day
- Organized by time
- Color-coded by activity type
- Each activity in a card

**Activity Card Design**:
```
┌───────────────────────────────────────┐
│ 🏃  08:00 AM                          │
│                                       │
│ Morning Walk                          │
│ Exercise                              │
│ Resident: Margaret Smith (Room 204)  │
│                                       │
│ [Edit] [Delete]                       │
└───────────────────────────────────────┘
```

**Card Components**:
- Left border color (activity type color)
- Activity type icon
- Scheduled time in large text
- Activity description
- Activity category label
- Assigned resident name and room
- Edit and Delete action buttons

**Floating Action Button**:
- "+" icon
- Opens "Add Activity" dialog
- Always visible
- Teal background

**Activity Types with Colors**:

1. **Exercise** 🏃 - Blue (#2196F3)
   - Walking, Yoga, Stretching, Gym

2. **Meals** 🍽️ - Orange (#FF9800)
   - Breakfast, Lunch, Dinner, Snacks

3. **Medication** 💊 - Red (#F44336)
   - Medicine times, Health checks

4. **Social** 👥 - Purple (#9C27B0)
   - Group activities, Games, Discussions

5. **Therapy** 🧘 - Green (#4CAF50)
   - Physical therapy, Occupational therapy

6. **Recreation** 🎨 - Teal (#1FC8DB)
   - Arts, Music, Entertainment

**Functionality**:

**1. View Activities by Day**:
- Select day from chip selector
- View all activities scheduled for that day
- Activities sorted by time (earliest first)
- Color-coded for quick identification
- Shows resident assignments

**2. Add New Activity**:
- Click FAB button
- Opens "Add Activity" dialog

**Add Activity Dialog Fields**:

**Resident Selection**:
- Dropdown menu
- Shows all residents
- Format: "Name (Room #)"
- Required field

**Activity Type**:
- Dropdown menu
- 6 options: Exercise, Meal, Medication, Social, Therapy, Recreation
- Required field
- Changes icon and color

**Description**:
- Text input field
- Placeholder: "Activity description"
- Required field
- Max 200 characters
- Example: "Morning Walk in Garden"

**Day of Week**:
- Dropdown menu
- Options: Monday - Sunday
- Pre-selected to current day
- Required field

**Scheduled Time**:
- Time picker field
- 24-hour or 12-hour format (device dependent)
- Required field
- Example: "08:00 AM"
- Visual clock picker

**Action Buttons**:
- "Cancel" - Closes dialog without saving
- "Save" - Validates and saves activity

**3. Edit Activity**:
- Click "Edit" button on any card
- Opens same dialog as Add
- Fields pre-filled with current data
- All fields editable
- Save updates database
- Cancel discards changes

**4. Delete Activity**:
- Click "Delete" button on card
- Shows confirmation dialog
- Message: "Delete this activity?"
- Shows activity details
- Options: "Cancel" and "Delete"
- If confirmed:
  - Removes from database
  - Refreshes activity list
  - Shows success message

**Data Organization**:
- Activities grouped by day
- Sorted by time within each day
- Persistent storage in daily_activities table
- Links to resident_id
- Includes day_of_week and scheduled_time

**Empty State**:
- When no activities for selected day
- Icon: Calendar with no events
- Message: "No activities scheduled for [Day]"
- Suggestion: "Click + to add activity"

**User Experience**:
- Quick day switching with chips
- Visual time organization
- Color coding for quick recognition
- Clear resident assignments
- Easy add/edit/delete operations
- Confirmation for destructive actions

---

### TAB 4: APPROVE VISITS

**Purpose**:
Manage visitor requests from family and friends. Administrators can review pending visit requests, approve or reject them, and manage visit scheduling.

**Visual Layout**:

**Filter Tabs**:
- Secondary tab bar below main tabs
- Options:
  - "Pending" (default) - Yellow badge with count
  - "Approved" - Green badge
  - "Rejected" - Red badge
  - "All" - No badge

**Visit Request Cards**:
- Vertical scrollable list
- Each request in a card
- Color-coded by status
- Comprehensive information display

**Visit Card Design**:
```
┌──────────────────────────────────────────┐
│ 🟡 PENDING                               │
│                                          │
│ Visitor: John Smith                      │
│ Relationship: Son                        │
│ Contact: +230 5123 4567                  │
│                                          │
│ Visiting: Margaret Smith (Room 204)     │
│                                          │
│ Scheduled: February 25, 2026            │
│ Time: 2:30 PM                            │
│                                          │
│ Purpose: Weekly family visit            │
│                                          │
│ Requested: 2 days ago                   │
│                                          │
│ [✓ Approve]  [✗ Reject]                │
└──────────────────────────────────────────┘
```

**Card Components**:

**Status Badge**:
- Top-left corner
- Color-coded:
  - Yellow: Pending
  - Green: Approved  
  - Red: Rejected
- Icon and text

**Visitor Information**:
- Name in bold
- Relationship to resident
- Contact phone number
- Icon: Person icon

**Resident Information**:
- Name of resident to visit
- Room number
- Icon: Home icon

**Visit Details**:
- Scheduled date (formatted: Month Day, Year)
- Scheduled time (12-hour format with AM/PM)
- Purpose/reason for visit
- Icons: Calendar and clock

**Request Metadata**:
- When request was submitted
- Relative time (e.g., "2 days ago")
- Icon: Clock icon

**Action Buttons** (for Pending only):
- **Approve Button**:
  - Green background
  - Checkmark icon
  - Text: "Approve"
  - Full width or half width
  
- **Reject Button**:
  - Red background
  - X icon
  - Text: "Reject"
  - Full width or half width

**Functionality**:

**1. View Visit Requests**:
- Default shows Pending requests
- Tap filter tabs to switch views
- Badge shows count of pending requests
- Cards sorted by request date (newest first)
- Infinite scroll for large lists

**2. Filter by Status**:
- **Pending Tab**:
  - Shows requests awaiting admin decision
  - Includes action buttons
  - Yellow indicators
  
- **Approved Tab**:
  - Shows confirmed visits
  - Green indicators
  - No action buttons
  - Option to cancel if needed
  
- **Rejected Tab**:
  - Shows denied requests
  - Red indicators
  - Shows rejection reason (if provided)
  - Option to reverse decision
  
- **All Tab**:
  - Shows complete history
  - Mixed status indicators
  - Useful for reporting

**3. Approve Visit Request**:
- Click "Approve" button on pending card
- Confirmation dialog appears:
  - "Approve visit for [Visitor Name]?"
  - Shows visit details
  - Warning: "Resident will be notified"
  - Options: "Cancel" and "Approve"
- If confirmed:
  - Updates status to 'approved' in database
  - Shows success message
  - Card moves to Approved tab
  - Resident sees visit in their dashboard
  - Optional: Email notification (future)

**4. Reject Visit Request**:
- Click "Reject" button on pending card
- Rejection dialog appears:
  - "Reject visit for [Visitor Name]?"
  - Optional reason field:
    - Placeholder: "Reason for rejection (optional)"
    - Text area
    - Examples: "Resident unavailable", "Facility policy"
  - Options: "Cancel" and "Reject"
- If confirmed:
  - Updates status to 'rejected'
  - Saves rejection reason if provided
  - Shows success message
  - Card moves to Rejected tab
  - Optional: Notify visitor (future)

**5. View Request Details**:
- Tap anywhere on card
- Opens expanded detail view
- Shows all information
- Includes:
  - Full visitor and resident profiles
  - Complete visit information
  - Request history
  - Previous visits by same visitor
- Action buttons still available

**Database Integration**:
- Reads from visits table
- Filters by status
- Updates status field on approve/reject
- Stores rejection_reason
- Records admin_action_timestamp

**Empty States**:

**No Pending Requests**:
- Icon: Calendar with checkmark
- Message: "No pending visit requests"
- Subtitle: "All caught up!"

**No Approved Visits**:
- Icon: Calendar
- Message: "No approved visits yet"

**No Rejected Requests**:
- Icon: Calendar with X
- Message: "No rejected requests"

**User Experience**:
- Clear status visualization
- Comprehensive information display
- Easy approve/reject process
- Confirmation prevents mistakes
- Quick filtering by status
- Responsive to admin actions
- Real-time updates to residents

**Access Control**:
- Only admins can approve/reject
- Residents can only view their approved visits
- Visitors can only create requests
- Audit trail of admin actions (future)

---

### 7. ADMIN LOGOUT

**Functionality**:
- Logout button in top-right of app bar
- Icon: Exit/door icon
- Confirmation dialog:
  - "Are you sure you want to logout?"
  - Options: "Cancel" and "Logout"
- If confirmed:
  - Signs out from Supabase
  - Clears session
  - Returns to Welcome Screen
  - Session tokens invalidated

---

## CUSTOMER/RESIDENT PORTAL

### 8. RESIDENT DASHBOARD

**File**: `lib/screens/customer/resident_dashboard.dart`

**Purpose**:
Personal dashboard for residents to view their health information, daily schedules, upcoming visits, and manage their account settings. Provides easy access to all resident-facing features.

**Visual Design**:
- **App Bar**:
  - Title: "My Dashboard" or resident name
  - Teal background
  - White text
  - Notification bell icon (future)
  - Theme toggle icon
- **Bottom Navigation Bar**:
  - 5 tabs with icons and labels
  - Selected tab highlighted
  - Icons change color when selected
  - Smooth transitions between tabs

**Navigation Structure**:

```
Resident Dashboard
├── Tab 1: Home 🏠
├── Tab 2: Health 🩺
├── Tab 3: Activities 🚶
├── Tab 4: Visits 👨‍👩‍👧
└── Tab 5: Profile 👤
```

---

### TAB 1: HOME

**Purpose**:
Welcome screen showing overview of resident's information, today's schedule, upcoming visits, and latest health status.

**Visual Layout**:

**1. Welcome Banner**
- **Image**: Professional elderly care photograph
- **Height**: 150px
- **Gradient Overlay**: Dark gradient for text visibility
- **Content**:
  - "Welcome to Your Dashboard" heading
  - Resident's first name
  - Current date and time
  - Weather icon (future)

**2. Profile Summary Card**
- **Layout**: Horizontal card
- **Components**:
  - Circular profile photo (left)
  - Name and details (center)
  - Health status badge (right)
  
**Card Content**:
```
┌──────────────────────────────────────┐
│  👤    Margaret Smith               │
│        Room 204 | Age 76            │
│        Blood Type: O+               │
│                    🟢 Good Health   │
└──────────────────────────────────────┘
```

**3. Quick Stats Row**
- Three stat cards in a row
- Icons and numbers

**Stat Cards**:
```
┌──────────┐ ┌──────────┐ ┌──────────┐
│ 📅  4    │ │ 👨‍👩‍👧  2   │ │ 🩺  98%  │
│ This Week│ │ Upcoming │ │ Oxygen   │
│ Activities│ │ Visits   │ │ Level    │
└──────────┘ └──────────┘ └──────────┘
```

**4. Today's Schedule Section**
- **Header**: "Today's Activities"
- **Icon**: Calendar icon
- **Content**: List of today's activities
- **Empty State**: "No activities scheduled for today"

**Activity Item**:
```
┌──────────────────────────────────────┐
│ 🏃 08:00 AM - Morning Walk           │
│    Exercise                          │
└──────────────────────────────────────┘
```

**Time Sections**:
- Morning (before 12 PM)
- Afternoon (12 PM - 5 PM)
- Evening (after 5 PM)

**5. Upcoming Visits Section**
- **Header**: "Upcoming Visits"
- **Icon**: People icon
- **Content**: Next 3 approved visits
- **Empty State**: "No visits scheduled"

**Visit Item**:
```
┌──────────────────────────────────────┐
│ 👤 John Smith (Son)                  │
│ 📅 February 25, 2026                 │
│ 🕐 2:30 PM                           │
│ Purpose: Weekly family visit         │
└──────────────────────────────────────┘
```

**6. Latest Vitals Section**
- **Header**: "Latest Health Vitals"
- **Icon**: Heart icon
- **Content**: Most recent vital signs
- **Tap**: Opens Health tab

**Vitals Display**:
```
┌──────────────────────────────────────┐
│ Blood Pressure: 120/80 mmHg   ✅    │
│ Heart Rate: 72 BPM             ✅    │
│ Temperature: 36.8°C            ✅    │
│ Oxygen Level: 98%              ✅    │
│                                      │
│ Recorded: 1 day ago                  │
└──────────────────────────────────────┘
```

**Status Indicators**:
- ✅ Green checkmark: Normal
- ⚠️ Yellow warning: Borderline
- ❌ Red alert: Needs attention

**Functionality**:

**Data Loading**:
- Loads resident data on tab open
- Fetches today's activities
- Retrieves upcoming visits
- Gets latest vitals
- Real-time updates

**Interactions**:
- Tap activity → Opens Activities tab
- Tap visit → Opens Visits tab
- Tap vitals → Opens Health tab
- Pull to refresh functionality
- Automatic refresh periodically

**User Experience**:
- Comprehensive overview
- Large, readable fonts
- Clear visual hierarchy
- Professional imagery
- Easy navigation to details
- Comfortable for elderly users

---

### TAB 2: HEALTH

**Purpose**:
Complete health information display including medical details, current medications, vital signs history, and care notes.

**Visual Layout**:

**1. Medical Information Card**
- **Header**: "Medical Information"
- **Icon**: Medical bag icon

**Content**:
```
┌──────────────────────────────────────┐
│ Personal Medical Info                │
│                                      │
│ Blood Type: O+                      │
│ Known Allergies: Penicillin         │
│ Chronic Conditions: None            │
│ Dietary Restrictions: None          │
└──────────────────────────────────────┘
```

**2. Current Medications Card**
- **Header**: "Current Medications"
- **Icon**: Pills icon
- **Content**: List of medications

**Medication Item**:
```
┌──────────────────────────────────────┐
│ 💊 Blood Pressure Medication         │
│    Dosage: 10mg daily               │
│    Time: 8:00 AM                    │
│    Started: January 2026            │
└──────────────────────────────────────┘
```

**3. Vitals History Card**
- **Header**: "Health Vitals History"
- **Icon**: Chart icon
- **Content**: Timeline of past readings

**Vitals Entry**:
```
┌──────────────────────────────────────┐
│ February 17, 2026 - 9:30 AM         │
│                                      │
│ 💓 Blood Pressure: 120/80 mmHg ✅   │
│ ❤️  Heart Rate: 72 BPM          ✅   │
│ 🌡️ Temperature: 36.8°C          ✅   │
│ 🫁 Oxygen Level: 98%            ✅   │
│                                      │
│ Notes: Normal vitals, patient well  │
└──────────────────────────────────────┘
```

**4. Care Notes Card**
- **Header**: "Care Notes from Staff"
- **Icon**: Notepad icon
- **Content**: Important notes from caregivers

**Note Entry**:
```
┌──────────────────────────────────────┐
│ February 16, 2026                    │
│ By: Nurse Sarah                      │
│                                      │
│ Requires assistance with mobility.   │
│ Prefers morning activities.          │
│ Participating well in group events.  │
└──────────────────────────────────────┘
```

**Functionality**:

**View Medical Info**:
- Displays all medical information
- Read-only for residents
- Editable by admin only
- Clear categorization

**Medications List**:
- Shows all current medications
- Includes dosage and timing
- Color-coded by medication type
- Reminder notifications (future)

**Vitals Timeline**:
- Chronological order (newest first)
- Shows all past readings
- Scroll through history
- Tap to expand details
- Export to PDF (future)

**Visual Trends** (Future Enhancement):
- Line graphs for each vital
- Shows trends over time
- Identifies patterns
- Highlights concerns

**Care Notes Access**:
- Read-only view
- Sorted by date
- Shows staff member name
- Searchable (future)

**User Experience**:
- Complete health overview
- Easy-to-read format
- Clear visual indicators
- Historical tracking
- Professional medical layout

---

### TAB 3: ACTIVITIES

**Purpose**:
View weekly activity schedule with all planned activities organized by day and time.

**Visual Layout**:

**1. Day Selector**
- Horizontal scrollable chips
- 7 days: Mon, Tue, Wed, Thu, Fri, Sat, Sun
- Today highlighted by default
- Tap to select different day

**2. Date Display**
- Shows full date for selected day
- Format: "Monday, February 18, 2026"
- Icon: Calendar icon

**3. Activities List**
- Grouped by time of day
- Color-coded by activity type
- Scrollable vertical list

**Time Sections**:

**Morning Activities (6 AM - 12 PM)**:
- **Header**: "🌅 Morning"
- **Background**: Light blue tint

**Activity Card**:
```
┌──────────────────────────────────────┐
│ 🏃 08:00 AM                          │
│                                      │
│ Morning Walk                         │
│ Exercise                             │
│                                      │
│ Meet at main entrance               │
└──────────────────────────────────────┘
```

**Afternoon Activities (12 PM - 5 PM)**:
- **Header**: "☀️ Afternoon"
- **Background**: Light yellow tint

**Evening Activities (5 PM - 10 PM)**:
- **Header**: "🌙 Evening"
- **Background**: Light purple tint

**Activity Card Components**:
- Activity type icon (colorful)
- Time in large font
- Activity name/title
- Activity category label
- Description or location
- Colored left border

**Activity Types**:
- 🏃 Exercise (Blue)
- 🍽️ Meals (Orange)
- 💊 Medication (Red)
- 👥 Social (Purple)
- 🧘 Therapy (Green)
- 🎨 Recreation (Teal)

**Empty State**:
```
┌──────────────────────────────────────┐
│        📅                            │
│                                      │
│ No activities scheduled              │
│ for Monday                           │
│                                      │
│ Enjoy your free time!               │
└──────────────────────────────────────┘
```

**Functionality**:

**Day Navigation**:
- Swipe left/right to change days
- Tap day chip to jump to specific day
- Today button to return to current day
- Shows activities for selected day only

**Activity Details**:
- Tap card to view full details
- Shows complete description
- Location information
- Staff assigned (if any)
- Other participants (if group)

**Time Display**:
- 12-hour format with AM/PM
- 24-hour format (settings option)
- Adjusts to device settings
- Clear, large fonts

**Visual Organization**:
- Time-based sections
- Color coding by type
- Chronological order
- Easy scanning

**Notifications** (Future):
- Reminder 15 minutes before
- Push notification
- Sound/vibration option
- Configurable in settings

**User Experience**:
- Weekly planning view
- Clear time organization
- Beautiful color system
- Easy day switching
- Suitable for elderly users

---

### TAB 4: VISITS

**Purpose**:
View upcoming approved visits from family and friends. Shows visitor information, visit times, and purposes.

**Visual Layout**:

**1. Header Section**
- Title: "Upcoming Visits"
- Icon: People icon
- Count badge: Number of upcoming visits

**2. Filter Options** (Future):
- This Week
- This Month
- All Upcoming
- Past Visits

**3. Visit Cards List**
- Scrollable vertical list
- Each approved visit in a card
- Sorted by date (soonest first)
- Color-coded by status

**Visit Card Design**:
```
┌──────────────────────────────────────┐
│ 👤 John Smith                        │
│    Son                               │
│                                      │
│ 📅 Monday, February 25, 2026         │
│ 🕐 2:30 PM - 4:00 PM                │
│                                      │
│ Purpose: Weekly family visit         │
│                                      │
│ 📞 +230 5123 4567                   │
│                                      │
│ ✅ Approved                          │
│                                      │
│ [Contact] [Directions] [Cancel]      │
└──────────────────────────────────────┘
```

**Card Components**:

**Visitor Info**:
- Name in bold
- Relationship label
- Profile photo placeholder
- Icon: Person

**Visit DateTime**:
- Full date (day, month, date, year)
- Time with AM/PM
- Duration (if specified)
- Icons: Calendar and clock

**Purpose**:
- Reason for visit
- Free text field
- Examples:
  - "Weekly family visit"
  - "Birthday celebration"
  - "Medical appointment assistance"

**Contact Information**:
- Phone number
- Clickable to call
- Icon: Phone

**Status Badge**:
- Green badge: "Approved"
- Shows approval date
- Icon: Checkmark

**Action Buttons**:

**Contact Button**:
- Opens phone dialer
- Pre-fills visitor's number
- Icon: Phone
- Blue color

**Directions Button** (Future):
- Sends visitor facility address
- Integration with maps
- Icon: Map pin
- Purple color

**Cancel Button**:
- Allows resident to cancel visit
- Shows confirmation dialog
- Notifies admin
- Icon: X
- Red color

**Status Types**:
- **Approved** (Green): Confirmed visit
- **Pending** (Yellow): Awaiting admin approval (not shown to resident)
- **Completed** (Grey): Past visit
- **Cancelled** (Red): Cancelled by resident or admin

**Empty State**:
```
┌──────────────────────────────────────┐
│        👨‍👩‍👧                           │
│                                      │
│ No upcoming visits scheduled         │
│                                      │
│ Ask family to request a visit!      │
│                                      │
│ [Request Visit] (future)            │
└──────────────────────────────────────┘
```

**Functionality**:

**View Visits**:
- See all approved upcoming visits
- Detailed information for each
- Sorted chronologically
- Auto-refresh on tab open

**Contact Visitor**:
- Tap phone number or Contact button
- Opens phone app with number
- One-tap calling
- Easy for elderly users

**Cancel Visit**:
- Tap Cancel button
- Confirmation dialog:
  - "Cancel visit with [Name]?"
  - "Scheduled for [Date]"
  - "Are you sure?"
  - Options: "No, Keep Visit" and "Yes, Cancel"
- If confirmed:
  - Updates status to 'cancelled'
  - Notifies admin
  - Optionally notifies visitor
  - Shows confirmation message

**Past Visits** (Future Tab):
- Shows completed visits
- Historical record
- Can add notes/ratings
- View visit history

**Request Visit** (Future Feature):
- Button to request new visit
- Form for visitor details
- Submit to admin for approval
- Track request status

**Data Display**:
- Loads from visits table
- Filters status='approved'
- Orders by scheduled_at
- Only future visits
- Linked to logged-in resident

**User Experience**:
- Large, readable cards
- Clear visitor information
- Easy contact access
- Simple cancellation process
- Comfortable layout
- Professional design

---

### TAB 5: PROFILE

**Purpose**:
Account management, settings access, and app preferences. Gateway to all additional functionalities (20 marks features).

**Visual Layout**:

**1. Profile Header**
- Large circular profile photo
- Gradient background
- Edit photo button (camera icon)

**Profile Display**:
```
┌──────────────────────────────────────┐
│                                      │
│          👤 [Photo]                  │
│           📷                         │
│                                      │
│      Margaret Smith                  │
│      Room 204                        │
│      margaret.smith@test.com        │
│                                      │
└──────────────────────────────────────┘
```

**2. Personal Info Section**
- **Header**: "Personal Information"
- **Content**: Key details

**Info Display**:
```
┌──────────────────────────────────────┐
│ Personal Information                 │
│                                      │
│ 📧 Email                             │
│    margaret.smith@test.com          │
│                                      │
│ 📱 Phone                             │
│    +230 5987 6543                   │
│                                      │
│ 🏠 Room Number                       │
│    204                              │
│                                      │
│ 🎂 Age                               │
│    76 years                         │
│                                      │
│ 🩸 Blood Type                        │
│    O+                               │
└──────────────────────────────────────┘
```

**3. Settings Menu**
- **Header**: "Settings"
- **List**: All settings options

**Settings Items**:

```
┌──────────────────────────────────────┐
│ ⚙️  Account Settings          >      │
│    Manage personal information       │
│                                      │
│ 🔔 Notification Settings      >      │
│    Control notification preferences  │
│                                      │
│ 💳 Payment Methods            >      │
│    Manage payment options           │
│                                      │
│ 🔒 Privacy & Security         >      │
│    Privacy controls & security      │
│                                      │
│ 🌙 Dark Mode                  🔘     │
│    Switch theme                     │
└──────────────────────────────────────┘
```

**Each Setting Item Has**:
- Icon (colorful, representative)
- Title (bold, clear)
- Subtitle (description)
- Arrow icon (indicates navigation)
- Tap area (full width)

**4. Additional Options**

```
┌──────────────────────────────────────┐
│ 📞 Help & Support             >      │
│    Get help and contact support     │
│                                      │
│ 📄 About                      >      │
│    App info and version             │
│                                      │
│ 🚪 Logout                            │
│    Sign out of your account         │
└──────────────────────────────────────┘
```

**Functionality**:

**Profile Photo** (Future):
- Tap to view full size
- Camera icon to change
- Upload from gallery
- Take new photo
- Crop and resize

**View Personal Info**:
- Displays all profile data
- Read-only view
- Edit via Account Settings
- Auto-loads from database

**Settings Navigation**:

**Account Settings →**
- Opens AccountSettingsScreen
- Edit name, phone
- Update emergency contacts
- Save changes to database

**Notification Settings →**
- Opens NotificationSettingsScreen
- 9 notification types
- Toggle switches
- Save preferences locally

**Payment Methods →**
- Opens PaymentMethodsScreen
- View all payment options
- Add new payment method
- Edit/delete existing
- Set default payment

**Privacy & Security →**
- Opens PrivacySecurityScreen
- Privacy toggles
- Security settings
- Data management options

**Dark Mode Toggle**:
- Switch widget
- Inline toggle (no navigation)
- Instant theme change
- Uses Provider
- Persists preference
- Affects entire app

**Help & Support** (Future):
- FAQ section
- Contact form
- Emergency numbers
- Live chat support
- Email support

**About**:
- App version number
- Developer information
- Terms of Service link
- Privacy Policy link
- Credits

**Logout**:
- Tap Logout button
- Confirmation dialog:
  - "Are you sure you want to logout?"
  - "You will need to login again"
  - Options: "Cancel" and "Logout"
- If confirmed:
  - Sign out from Supabase
  - Clear session
  - Keep local settings
  - Navigate to Welcome Screen

**User Experience**:
- Complete profile management
- Easy settings access
- Clear navigation
- Professional layout
- All features accessible
- Intuitive organization

---

## SETTINGS & ADDITIONAL FEATURES

These are the 20-mark additional functionalities accessible from the Profile tab.

### 9. ACCOUNT SETTINGS SCREEN

**File**: `lib/screens/customer/settings/account_settings_screen.dart`

**Purpose**:
Manage personal information and emergency contacts. Residents can update their details and ensure emergency contact information is current.

**Navigation**: Profile Tab → Account Settings

**Visual Layout**:

**App Bar**:
- Title: "Account Settings"
- Back button
- Save button (checkmark icon)

**Form Sections**:

**1. Personal Information Section**
```
┌──────────────────────────────────────┐
│ Personal Information                 │
│                                      │
│ Full Name *                          │
│ [Margaret Smith          ]          │
│                                      │
│ Phone Number *                       │
│ [+230 5987 6543         ]          │
│                                      │
│ Email Address                        │
│ [margaret.smith@test.com] 🔒        │
│ (Cannot be changed)                  │
└──────────────────────────────────────┘
```

**2. Emergency Contact Section**
```
┌──────────────────────────────────────┐
│ Emergency Contact                    │
│                                      │
│ Contact Name *                       │
│ [John Smith             ]          │
│                                      │
│ Contact Phone *                      │
│ [+230 5123 4567         ]          │
│                                      │
│ Relationship                         │
│ [Son                    ]          │
└──────────────────────────────────────┘
```

**3. Info Banner**
```
┌──────────────────────────────────────┐
│ ℹ️  Your information is secure       │
│                                      │
│ Changes are saved to your profile.   │
│ Emergency contacts can be reached    │
│ by staff in case of urgent situations│
└──────────────────────────────────────┘
```

**Field Details**:

**Full Name**:
- Required field (*)
- Text input
- Validation: Minimum 2 characters
- Current value pre-filled
- Editable

**Phone Number**:
- Required field (*)
- Phone input
- Format: +230 XXXX XXXX
- Validation: Valid phone format
- Current value pre-filled

**Email Address**:
- Read-only field
- Lock icon indicator
- Cannot be changed (security)
- Shows current email
- Grey background

**Emergency Contact Name**:
- Required field (*)
- Text input
- Validation: Minimum 2 characters
- Example: "John Smith"

**Emergency Contact Phone**:
- Required field (*)
- Phone input
- Format validation
- Example: "+230 5123 4567"

**Emergency Contact Relationship**:
- Optional field
- Text input
- Examples: "Son", "Daughter", "Friend", "Spouse"

**Action Buttons**:

**Save Button** (App Bar):
- Icon: Checkmark
- Color: White
- Position: Top-right
- Action: Save all changes
- Validates before saving

**Save Button** (Bottom):
- Full-width button
- Teal background
- Text: "Save Changes"
- Icon: Save icon
- Validates form
- Shows loading

**Cancel Changes**:
- Text button above Save
- Red text
- Action: Revert to original values
- Confirmation dialog

**Functionality**:

**Load Data**:
- Fetches resident data on screen open
- From residents table
- Linked to logged-in user
- Pre-fills all fields
- Shows loading indicator

**Edit Information**:
- All fields editable except email
- Real-time input
- No character limits (reasonable)
- Proper keyboards (phone for phone fields)

**Validation**:
- Required fields checked
- Name: Not empty, min 2 chars
- Phone: Valid format
- Emergency contact name: Not empty
- Emergency contact phone: Valid format

**Save Changes**:
1. User edits fields
2. Clicks Save button
3. Validation runs
4. If invalid: Show field errors
5. If valid:
   - Update residents table in Supabase
   - Set updated_at timestamp
   - Show success SnackBar
   - Stay on screen or go back
6. On error:
   - Show error message
   - Keep edited values
   - User can try again

**Cancel Changes**:
- Discards all edits
- Confirmation: "Discard changes?"
- Reverts to original values
- Stays on screen

**Database Update**:
```dart
await SupabaseService.updateResident(residentId, {
  'name': nameController.text,
  'phone': phoneController.text,
  'emergency_contact_name': emergencyNameController.text,
  'emergency_contact_phone': emergencyPhoneController.text,
  'updated_at': DateTime.now(),
});
```

**Success Feedback**:
- Green SnackBar
- Message: "Profile updated successfully"
- Checkmark icon
- Auto-dismiss after 3 seconds

**Error Handling**:
- Network error: "Connection failed"
- Validation error: Field-specific messages
- Database error: "Update failed. Try again"
- Clear error display

**User Experience**:
- Simple, clean form
- Large input fields
- Clear required indicators
- Pre-filled with current data
- Easy to edit
- Clear save/cancel options
- Immediate feedback

---

### 10. NOTIFICATION SETTINGS SCREEN

**File**: `lib/screens/customer/settings/notification_settings_screen.dart`

**Purpose**:
Control which notifications the resident receives. Provides granular control over 9 different notification types with toggle switches.

**Navigation**: Profile Tab → Notification Settings

**Visual Layout**:

**App Bar**:
- Title: "Notification Settings"
- Back button
- Save button

**Info Banner**:
```
┌──────────────────────────────────────┐
│ ℹ️  Manage Your Notifications        │
│                                      │
│ Control what notifications you       │
│ receive. Emergency alerts are always │
│ enabled for your safety.            │
└──────────────────────────────────────┘
```

**Notification Categories**:

**1. Care & Health Notifications**
```
┌──────────────────────────────────────┐
│ Care & Health                        │
│                                      │
│ 🩺 Health Reminders           [🔘]   │
│    Check-ups and vital monitoring    │
│                                      │
│ 💊 Medication Reminders       [🔘]   │
│    Time to take your medications     │
│                                      │
│ 🍽️ Meal Reminders            [🔘]   │
│    Breakfast, lunch, and dinner times│
└──────────────────────────────────────┘
```

**2. Activities & Visits**
```
┌──────────────────────────────────────┐
│ Activities & Visits                  │
│                                      │
│ 🚶 Activity Reminders         [🔘]   │
│    Daily activities and exercise     │
│                                      │
│ 👨‍👩‍👧 Visit Notifications       [🔘]   │
│    When family or friends visit      │
└──────────────────────────────────────┘
```

**3. Important Notifications**
```
┌──────────────────────────────────────┐
│ Important                            │
│                                      │
│ 🚨 Emergency Alerts           [🔘]   │
│    Critical health alerts (Always ON)│
│                                      │
│ 📢 General Announcements      [🔘]   │
│    Updates and important information │
└──────────────────────────────────────┘
```

**4. Alert Settings**
```
┌──────────────────────────────────────┐
│ Alert Settings                       │
│                                      │
│ 🔊 Sound                      [🔘]   │
│    Play sound for notifications      │
│                                      │
│ 📳 Vibration                  [🔘]   │
│    Vibrate for notifications         │
└──────────────────────────────────────┘
```

**Toggle Switch States**:
- **ON** (Right, Teal): Notifications enabled
- **OFF** (Left, Grey): Notifications disabled
- **Disabled** (Grey, Locked): Cannot be changed (Emergency only)

**Notification Types Explained**:

**1. Health Reminders** 🩺:
- Purpose: Check-up appointments, vital monitoring schedules
- Example: "Time for your weekly health check"
- Default: ON

**2. Medication Reminders** 💊:
- Purpose: Medicine times throughout the day
- Example: "Take your blood pressure medication"
- Default: ON
- Critical for elderly health

**3. Meal Reminders** 🍽️:
- Purpose: Breakfast, lunch, dinner times
- Example: "Lunch is served in 10 minutes"
- Default: ON

**4. Activity Reminders** 🚶:
- Purpose: Scheduled activities, exercise, therapy
- Example: "Morning walk starts in 15 minutes"
- Default: ON

**5. Visit Notifications** 👨‍👩‍👧:
- Purpose: Family/friend visits approved or arriving
- Example: "Your son John will visit today at 2:30 PM"
- Default: ON

**6. Emergency Alerts** 🚨:
- Purpose: Critical health situations, facility emergencies
- Example: "Emergency: Report to nurse station"
- Default: ALWAYS ON (cannot disable)
- Safety feature

**7. General Announcements** 📢:
- Purpose: Facility news, events, updates
- Example: "Movie night tonight at 7 PM"
- Default: ON

**8. Sound** 🔊:
- Purpose: Audio alert for notifications
- Options: ON/OFF
- Default: ON
- Can be muted for quiet time

**9. Vibration** 📳:
- Purpose: Vibrate device for notifications
- Options: ON/OFF
- Default: ON
- Useful if sound is off

**Action Buttons**:

**Save Button** (App Bar):
- Icon: Checkmark
- Top-right position
- Saves all preferences

**Save Button** (Bottom):
- Full-width button
- Teal background
- Text: "Save Preferences"
- Saves all toggle states

**Functionality**:

**Load Preferences**:
- Reads from SharedPreferences on screen open
- Keys: notif_health, notif_medication, etc.
- Default all to true if not set
- Emergency always true (enforced)

**Toggle Notifications**:
- Tap switch to change state
- Instant visual feedback
- Changes stored in memory
- Not saved until Save button pressed

**Emergency Alerts (Special)**:
- Always enabled
- Switch is disabled (grey)
- Cannot be turned off
- Lock icon shown
- Tooltip: "Cannot be disabled for your safety"

**Save Preferences**:
1. User adjusts toggles
2. Clicks Save button
3. All states saved to SharedPreferences:
   ```dart
   await prefs.setBool('notif_health', healthEnabled);
   await prefs.setBool('notif_medication', medicationEnabled);
   // ... all 9 preferences
   ```
4. Success SnackBar shown
5. Preferences persist across app restarts

**Reset to Defaults** (Future):
- Button to reset all to default values
- Confirmation dialog
- All ON except optional ones

**Preference Keys**:
```dart
'notif_health' → bool
'notif_medication' → bool
'notif_meals' → bool
'notif_activities' → bool
'notif_visits' → bool
'notif_emergency' → bool (always true)
'notif_announcements' → bool
'notif_sound' → bool
'notif_vibration' → bool
```

**Integration** (Future):
- These preferences used by notification system
- Firebase Cloud Messaging
- Check preferences before sending notifications
- Respect user choices

**User Experience**:
- Clear categorization
- Visual separation of sections
- Easy on/off toggles
- Large touch targets
- Clear labels and descriptions
- Safety features (Emergency always on)
- Immediate visual feedback
- Simple save process

---

### 11. PAYMENT METHODS SCREEN

**File**: `lib/screens/customer/settings/payment_methods_screen.dart`

**Purpose**:
Manage payment methods for facility services. Residents can add, edit, and delete payment options including credit cards, bank accounts, and cash.

**Navigation**: Profile Tab → Payment Methods

**Visual Layout**:

**App Bar**:
- Title: "Payment Methods"
- Back button
- Add button (+ icon)

**Security Badge**:
```
┌──────────────────────────────────────┐
│ 🔒 Secure Payment Information        │
│                                      │
│ Your payment information is stored   │
│ securely and encrypted.             │
└──────────────────────────────────────┘
```

**Payment Methods List**:

**Visa Card**:
```
┌──────────────────────────────────────┐
│ 💳 Visa                         ⋮    │
│                                      │
│ •••• •••• •••• 4532                 │
│                                      │
│ Margaret Smith                       │
│ Expires: 12/2027                    │
│                                      │
│ ⭐ DEFAULT PAYMENT                   │
└──────────────────────────────────────┘
```

**Mastercard**:
```
┌──────────────────────────────────────┐
│ 💳 Mastercard                   ⋮    │
│                                      │
│ •••• •••• •••• 8899                 │
│                                      │
│ Margaret Smith                       │
│ Expires: 06/2026                    │
└──────────────────────────────────────┘
```

**Bank Account**:
```
┌──────────────────────────────────────┐
│ 🏦 Bank Account                 ⋮    │
│                                      │
│ •••• •••• 5678                      │
│                                      │
│ MCB Bank                            │
│ Savings Account                     │
└──────────────────────────────────────┘
```

**Cash**:
```
┌──────────────────────────────────────┐
│ 💵 Cash                         ⋮    │
│                                      │
│ Pay with cash on-site               │
│                                      │
│ No additional details needed        │
└──────────────────────────────────────┘
```

**Payment Types & Colors**:

1. **Visa** - Blue (#1976D2)
   - Icon: Visa logo
   - Shows last 4 digits
   - Expiry date
   - Cardholder name

2. **Mastercard** - Orange (#FF6D00)
   - Icon: Mastercard logo
   - Shows last 4 digits
   - Expiry date
   - Cardholder name

3. **Bank Account** - Green (#388E3C)
   - Icon: Bank building
   - Shows last 4 digits of account
   - Bank name
   - Account type

4. **Cash** - Teal (#1FC8DB)
   - Icon: Cash money
   - Simple option
   - No card/account details needed

**Card Menu (⋮)**:
- Three-dot menu on each card
- Options:
  - "Set as Default" (if not already)
  - "Edit"
  - "Delete"

**Default Payment Badge**:
- Gold star icon
- Text: "DEFAULT PAYMENT"
- Yellow background
- Only on one card

**Empty State**:
```
┌──────────────────────────────────────┐
│           💳                         │
│                                      │
│ No Payment Methods                   │
│                                      │
│ Add a payment method to make         │
│ payments easier.                    │
│                                      │
│ [Add Payment Method]                │
└──────────────────────────────────────┘
```

**Action Buttons**:

**Add Payment Method** (FAB):
- Floating action button
- Bottom-right corner
- "+" icon
- Teal background
- Opens Add Payment dialog

**Add Payment Method** (Empty State):
- Full-width button
- Teal background
- Opens Add Payment dialog

**Functionality**:

**Add Payment Method**:
1. Click + button
2. Opens "Add Payment Method" dialog

**Add Payment Dialog**:
```
┌──────────────────────────────────────┐
│ Add Payment Method            ✕     │
│                                      │
│ Payment Type *                       │
│ [Select type          ▼]            │
│ ↳ Visa                              │
│   Mastercard                        │
│   Bank Account                      │
│   Cash                              │
│                                      │
│ Last 4 Digits * (not for Cash)      │
│ [1234               ]               │
│                                      │
│ Expiry Date * (cards only)          │
│ [MM / YY            ]               │
│                                      │
│ Cardholder Name *                   │
│ [Margaret Smith     ]               │
│                                      │
│ Set as default payment               │
│ [checkbox]                          │
│                                      │
│ [Cancel]    [Add Payment Method]    │
└──────────────────────────────────────┘
```

**Form Fields (Dynamic based on type)**:

**All Types**:
- Payment Type dropdown (required)

**Visa/Mastercard**:
- Last 4 digits (required, numeric, exactly 4)
- Expiry date (required, MM/YY format)
- Cardholder name (required, text)
- Default checkbox

**Bank Account**:
- Last 4 digits (required)
- Bank name (required)
- Account type (optional: Savings/Checking)
- Default checkbox

**Cash**:
- No additional fields
- Just select Cash as type
- Default checkbox

**Validation**:
- Payment type: Required selection
- Last 4 digits: Exactly 4 numeric digits
- Expiry: Valid MM/YY format, future date
- Name: Minimum 2 characters
- All required fields must be filled

**Edit Payment Method**:
1. Click ⋮ menu on card
2. Select "Edit"
3. Opens same dialog with pre-filled data
4. All fields editable
5. Save updates the payment method

**Delete Payment Method**:
1. Click ⋮ menu on card
2. Select "Delete"
3. Confirmation dialog:
   - "Delete this payment method?"
   - Shows payment type and last 4 digits
   - "This action cannot be undone"
   - Options: "Cancel" and "Delete"
4. If confirmed:
   - Removes from storage
   - Refreshes list
   - Success message
5. If was default:
   - First remaining payment becomes default
   - Or no default if last payment deleted

**Set as Default**:
1. Click ⋮ menu on card
2. Select "Set as Default"
3. Removes default from previous card
4. Sets this card as default
5. Updates storage
6. Badge appears on this card
7. Success message shown

**Data Storage**:
- Stored in SharedPreferences
- Key: 'payment_methods'
- Format: List of JSON strings
- Each payment as: "type|digits|expiry|name|isDefault"
- Example: "Visa|4532|12/27|Margaret Smith|true"
- Encrypted format (production)

**Payment Method Object**:
```dart
{
  'type': 'Visa',
  'lastFourDigits': '4532',
  'expiryDate': '12/27',
  'cardholderName': 'Margaret Smith',
  'isDefault': true
}
```

**Security Features**:
- Only last 4 digits stored
- No full card numbers ever stored
- Encrypted local storage
- Secure badge visible
- Read-only in UI (full number never shown)

**User Experience**:
- Visual card-like design
- Color-coded by type
- Easy add process
- Quick edit/delete
- Clear default indicator
- Large touch targets
- Professional payment UI

---

### 12. PRIVACY & SECURITY SCREEN

**File**: `lib/screens/customer/settings/privacy_security_screen.dart`

**Purpose**:
Control privacy settings, security options, and data management. Residents can manage who sees their information and how their data is handled.

**Navigation**: Profile Tab → Privacy & Security

**Visual Layout**:

**App Bar**:
- Title: "Privacy & Security"
- Back button
- Save button

**Settings Sections**:

**1. Privacy Settings**
```
┌──────────────────────────────────────┐
│ Privacy Settings                     │
│                                      │
│ 🩺 Share Health Data          [🔘]   │
│    Allow staff to view health records│
│                                      │
│ 🟢 Show Activity Status       [🔘]   │
│    Let others see when you're active │
│                                      │
│ 👨‍👩‍👧‍👦 Allow Family Access     [🔘]   │
│    Family can view your schedule     │
│                                      │
│ 📍 Share Location with Staff  [🔘]   │
│    Help staff locate you in facility │
└──────────────────────────────────────┘
```

**2. Security Settings**
```
┌──────────────────────────────────────┐
│ Security                             │
│                                      │
│ 🔐 Two-Factor Authentication  [🔘]   │
│    Extra security for your account   │
│    ℹ️ (tap for info)                 │
│                                      │
│ 👆 Biometric Login            [🔘]   │
│    Use fingerprint or face ID       │
└──────────────────────────────────────┘
```

**3. Data Management**
```
┌──────────────────────────────────────┐
│ Data Management                      │
│                                      │
│ 💾 Automatic Data Backup      [🔘]   │
│    Regular backups of your data     │
│                                      │
│ 📥 Download My Data                  │
│    Get a copy of all your information│
│    [Download]                       │
│                                      │
│ ⚠️  Delete Account                   │
│    Permanently delete your account   │
│    [Delete Account]                 │
└──────────────────────────────────────┘
```

**Privacy Options Explained**:

**1. Share Health Data** 🩺:
- **Purpose**: Allow staff to view medical information
- **When OFF**: Health data only visible to admins (emergency access)
- **When ON**: All staff can view vitals, medications, notes
- **Default**: ON
- **Warning**: Turning OFF may affect care quality
- **Use Case**: Most residents keep this ON for better care

**2. Show Activity Status** 🟢:
- **Purpose**: Show online/active status to others
- **When OFF**: No one sees when you're using the app
- **When ON**: Staff/family can see when you're active
- **Default**: ON
- **Use Case**: Helps family know when to call

**3. Allow Family Access** 👨‍👩‍👧‍👦:
- **Purpose**: Let family members view your schedule
- **When OFF**: Only you and staff see your schedule
- **When ON**: Family can see activities and visits
- **Default**: ON
- **Use Case**: Family wants to coordinate visits around activities

**4. Share Location with Staff** 📍:
- **Purpose**: Help staff find you in facility (future: GPS tracking)
- **When OFF**: No location sharing
- **When ON**: Staff can locate you quickly
- **Default**: ON
- **Warning**: Important for emergencies
- **Use Case**: Safety feature for wandering or emergencies

**Security Options Explained**:

**5. Two-Factor Authentication (2FA)** 🔐:
- **Purpose**: Extra login security
- **How it works**: Password + SMS code
- **When OFF**: Only password required
- **When ON**: Password + code required (future implementation)
- **Default**: OFF
- **Info Dialog**: Explains 2FA process
- **Use Case**: High-security preference

**6. Biometric Login** 👆:
- **Purpose**: Use fingerprint/face recognition
- **When OFF**: Standard password login
- **When ON**: Quick biometric authentication (future)
- **Default**: OFF
- **Devices**: Requires compatible device
- **Use Case**: Easier for residents who forget passwords

**Data Management Options**:

**7. Automatic Data Backup** 💾:
- **Purpose**: Regular automatic backups
- **When OFF**: No automatic backups
- **When ON**: Daily backups to secure cloud
- **Default**: ON
- **Storage**: Secure encrypted backup
- **Use Case**: Prevents data loss

**8. Download My Data** 📥:
- **Purpose**: Get copy of all information
- **Format**: PDF or JSON file
- **Includes**: Profile, health records, activities, visits
- **Process**: Request → Admin approval → Email link
- **Compliance**: GDPR/data protection right
- **Use Case**: Records for personal filing, switching facilities

**9. Delete Account** ⚠️:
- **Purpose**: Permanently remove account and data
- **Warning**: IRREVERSIBLE action
- **Requirements**: Admin contact required
- **Process**: Request → Admin review → Confirmation
- **Data**: All data deleted (health records archived for legal)
- **Use Case**: Leaving facility, privacy concerns

**Dialogs & Interactions**:

**Share Health Data - Warning Dialog**:
```
┌──────────────────────────────────────┐
│ ⚠️  Privacy Warning                  │
│                                      │
│ Disabling health data sharing may    │
│ affect the quality of care you       │
│ receive. Staff will have limited     │
│ access to your medical information.  │
│                                      │
│ Are you sure?                       │
│                                      │
│ [Keep Enabled]  [Disable]           │
└──────────────────────────────────────┘
```

**Share Location - Warning Dialog**:
```
┌──────────────────────────────────────┐
│ ⚠️  Safety Warning                   │
│                                      │
│ Location sharing helps staff         │
│ respond quickly in emergencies.      │
│ Disabling this feature may delay     │
│ emergency response.                  │
│                                      │
│ Continue?                            │
│                                      │
│ [Keep Enabled]  [Disable]           │
└──────────────────────────────────────┘
```

**Two-Factor Authentication - Info Dialog**:
```
┌──────────────────────────────────────┐
│ ℹ️  Two-Factor Authentication        │
│                                      │
│ 2FA adds extra security to your      │
│ account:                            │
│                                      │
│ 1. Enter your password              │
│ 2. Receive code via SMS             │
│ 3. Enter code to login              │
│                                      │
│ This prevents unauthorized access    │
│ even if someone knows your password. │
│                                      │
│ [Got It]                            │
└──────────────────────────────────────┘
```

**Download Data - Process Dialog**:
```
┌──────────────────────────────────────┐
│ 📥 Download Your Data                │
│                                      │
│ We will prepare a complete copy of   │
│ your information including:          │
│                                      │
│ • Personal profile                  │
│ • Health records                    │
│ • Activity history                  │
│ • Visit records                     │
│                                      │
│ You will receive an email with a    │
│ download link within 24 hours.      │
│                                      │
│ Email: margaret.smith@test.com      │
│                                      │
│ [Cancel]  [Request Download]        │
└──────────────────────────────────────┘
```

**Delete Account - Confirmation Dialog**:
```
┌──────────────────────────────────────┐
│ ⚠️  Delete Account                   │
│                                      │
│ This will PERMANENTLY delete your    │
│ account and all associated data.     │
│                                      │
│ This action CANNOT be undone!       │
│                                      │
│ To proceed, please contact the      │
│ administrator:                      │
│                                      │
│ 📧 admin@eldercare.mu               │
│ 📞 +230 XXX XXXX                    │
│                                      │
│ [Cancel]  [Contact Admin]           │
└──────────────────────────────────────┘
```

**Functionality**:

**Load Privacy Settings**:
- Read from SharedPreferences
- Keys: privacy_share_health, privacy_show_activity, etc.
- Default all to true (most permissive)
- Display current states

**Toggle Privacy Options**:
- Tap switch to change
- Critical options show warning dialog
- Non-critical change instantly
- Changes stored in memory

**Toggle Security Options**:
- 2FA toggle with info dialog
- Biometric toggle checks device capability
- Shows "Not supported" if device incompatible
- Changes stored in memory

**Save Settings**:
1. User adjusts toggles
2. Clicks Save button (app bar or bottom)
3. All states saved to SharedPreferences:
   ```dart
   await prefs.setBool('privacy_share_health', shareHealth);
   await prefs.setBool('privacy_show_activity', showActivity);
   await prefs.setBool('privacy_family_access', familyAccess);
   await prefs.setBool('privacy_location_staff', shareLocation);
   await prefs.setBool('security_2fa', twoFactorEnabled);
   await prefs.setBool('security_biometric', biometricEnabled);
   await prefs.setBool('privacy_data_backup', autoBackup);
   ```
4. Success message shown
5. Settings persist across restarts

**Request Data Download**:
1. User clicks "Download" button
2. Shows confirmation dialog with email
3. If confirmed:
   - Creates download request
   - Notifies admin (future)
   - Sends confirmation email (future)
   - Shows success message
4. User receives email within 24 hours

**Request Account Deletion**:
1. User clicks "Delete Account" button
2. Shows strong warning dialog
3. Provides admin contact information
4. User must contact admin directly
5. Admin reviews request
6. Admin confirms identity
7. Admin processes deletion
8. Account and data removed (archives medical records)

**Preference Keys**:
```dart
'privacy_share_health' → bool
'privacy_show_activity' → bool
'privacy_family_access' → bool
'privacy_location_staff' → bool
'security_2fa' → bool
'security_biometric' → bool
'privacy_data_backup' → bool
```

**User Experience**:
- Clear categorization (Privacy, Security, Data)
- Warning dialogs for critical changes
- Info dialogs explaining features
- Large toggles easy for elderly
- Save confirmation
- Security emphasis
- Professional design

---

## NAVIGATION FLOW

### Complete Application Flow Diagram

```
Application Start
       │
       ▼
┌──────────────┐
│ Splash Screen│ (4 seconds)
└──────┬───────┘
       │
       ▼
┌──────────────┐
│Welcome Screen│
└──────┬───────┘
       │
       ├─────────────────┬───────────────────┐
       │                 │                   │
       ▼                 ▼                   ▼
┌─────────────┐   ┌──────────────┐   ┌─────────────┐
│Admin Login  │   │Customer Login│   │Registration │
└──────┬──────┘   └──────┬───────┘   └──────┬──────┘
       │                 │                   │
       │                 │                   └──────┐
       ▼                 ▼                          │
┌──────────────┐   ┌─────────────────┐            │
│Admin         │   │Resident Dashboard│◄───────────┘
│Dashboard     │   └────────┬─────────┘
└──────┬───────┘            │
       │                    │
       │                    ├──────┬─────────┬───────┬─────────┐
       │                    │      │         │       │         │
       ▼                    ▼      ▼         ▼       ▼         ▼
┌─────────────┐      ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌────────┐
│View         │      │Home  │ │Health│ │Activ.│ │Visits│ │Profile │
│Residents    │      └──────┘ └──────┘ └──────┘ └──────┘ └───┬────┘
├─────────────┤                                                │
│Record       │                                                │
│Vitals       │      ┌────────────────────────────────────────┘
├─────────────┤      │
│Manage       │      ├─────────┬──────────┬───────────┬───────────┐
│Schedules    │      │         │          │           │           │
├─────────────┤      ▼         ▼          ▼           ▼           ▼
│Approve      │   ┌───────┐ ┌──────┐ ┌────────┐ ┌────────┐ ┌──────┐
│Visits       │   │Account│ │Notif.│ │Payment │ │Privacy │ │Theme │
└─────────────┘   │Settings│ │Settings│ │Methods│ │Security│ │Toggle│
                  └───────┘ └──────┘ └────────┘ └────────┘ └──────┘
```

---

**End of UI & Functionality Guide**

This comprehensive guide covers all screens, features, and user interactions in the Beau Bassin Elderly Care Hostel Management System. Each screen has been documented with its purpose, visual design, functionality, and user experience considerations.
