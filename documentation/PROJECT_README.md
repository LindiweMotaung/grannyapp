# Elder Care Hostel Flutter App

A comprehensive Flutter mobile application for managing an elderly care hostel facility with separate admin and customer portals, connected to Supabase backend.

## 📱 Project Overview

This app provides a complete solution for elderly care facility management with two main user roles:

### Admin Features (20 marks + 10 marks login)
- ✅ **Admin Login** - Secure authentication for administrators
- ✅ **Resident Management** - Add, edit, view, and delete resident information
- ✅ **Visit Management** - Approve/reject/complete visit requests
- ✅ **Service Management** - Manage care services offered
- ✅ **Staff Management** - Manage staff members and their schedules
- ✅ **Dashboard** - Centralized control panel

### Customer/Family Features (20 marks + 10 marks login + 10 marks registration)
- ✅ **Customer Registration** - New family member account creation
- ✅ **Customer Login** - Secure authentication for families
- ✅ **View Residents** - Browse information about residents
- ✅ **Book Visits** - Schedule visits with loved ones
- ✅ **View Services** - Browse available care services
- ✅ **My Visits** - Track visit history and status
- ✅ **Emergency Contact** - 24/7 helpline information

### Additional Features (20 marks)
- ✅ **Real-time Updates** - Supabase realtime capabilities
- ✅ **Visit Status Tracking** - Pending → Approved → Completed
- ✅ **Service Categories** - Medical, Recreational, Personal Care
- ✅ **Date/Time Pickers** - Easy visit scheduling
- ✅ **Responsive UI** - Beautiful Material Design
- ✅ **Pull to Refresh** - Update data with pull gesture
- ✅ **Search & Filter** - Filter services by category
- ✅ **Data Validation** - Form validation throughout app

## 🛠️ Technology Stack

- **Framework:** Flutter 3.x
- **Backend:** Supabase (PostgreSQL + Authentication)
- **State Management:** Provider
- **UI:** Material Design 3
- **Fonts:** Google Fonts
- **Date/Time:** intl package
- **Images:** Image Picker, Cached Network Image

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  supabase_flutter: ^2.5.6
  provider: ^6.1.2
  google_fonts: ^6.2.1
  intl: ^0.19.0
  image_picker: ^1.1.2
  cached_network_image: ^3.3.1
```

## 🚀 Setup Instructions

### 1. Prerequisites
- Flutter SDK (3.10.3 or higher)
- Dart SDK
- Android Studio / VS Code
- Supabase account

### 2. Clone & Install
```bash
cd c:\Advance_mobile_App\Apps\MyFlutterApp\grannyapp
flutter pub get
```

### 3. Supabase Setup
Follow the detailed instructions in `SUPABASE_SETUP.md`:
1. Create Supabase project
2. Run SQL scripts to create tables
3. Set up Row Level Security policies
4. Create admin user
5. Insert sample data (optional)

### 4. Configure App
Edit `lib/services/supabase_service.dart`:
```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

### 5. Run the App
```bash
flutter run
```

## 📱 App Structure

```
lib/
├── main.dart                      # App entry point
├── models/                        # Data models
│   ├── resident.dart
│   ├── visit.dart
│   ├── service.dart
│   └── staff.dart
├── services/                      # Business logic
│   ├── supabase_service.dart
│   └── auth_service.dart
└── screens/                       # UI screens
    ├── splash_screen.dart
    ├── welcome_screen.dart
    ├── auth/                      # Authentication screens
    │   ├── admin_login_screen.dart
    │   ├── customer_login_screen.dart
    │   └── customer_register_screen.dart
    ├── admin/                     # Admin section
    │   ├── admin_dashboard.dart
    │   ├── residents_list_screen.dart
    │   ├── visits_list_screen.dart
    │   ├── services_list_screen.dart
    │   └── staff_list_screen.dart
    └── customer/                  # Customer section
        ├── customer_dashboard.dart
        ├── view_residents_screen.dart
        ├── book_visit_screen.dart
        ├── view_services_screen.dart
        └── my_visits_screen.dart
```

## 🎯 Features Breakdown

### Admin Portal
1. **Login System** - Email/password authentication with role verification
2. **Resident Management**
   - CRUD operations for residents
   - Track medical conditions
   - Emergency contact information
   - Room assignments
3. **Visit Management**
   - View all visit requests
   - Approve/reject pending visits
   - Mark visits as completed
   - Status tracking
4. **Service Management**
   - Add/edit/delete services
   - Set pricing
   - Toggle availability
   - Categorize services
5. **Staff Management**
   - Add/edit/delete staff
   - Assign roles and shifts
   - Contact information

### Customer Portal
1. **Registration & Login** - Create account with phone verification
2. **Resident Directory** - View active residents and their information
3. **Visit Booking**
   - Select resident
   - Choose date and time
   - Specify purpose
   - Track approval status
4. **Services Catalog**
   - Browse by category
   - View descriptions and pricing
   - Contact for inquiries
5. **Visit History** - View past and upcoming visits with status

## 🔐 Demo Credentials

**Admin Account:**
- Email: `admin@eldercare.com`
- Password: `admin123`

**Customer Account:**
- Register through the app

## 📊 Database Schema

### Tables
- `residents` - Resident information
- `visits` - Visit scheduling and tracking
- `services` - Care services offered
- `staff` - Staff member information

### Security
- Row Level Security (RLS) enabled on all tables
- Role-based access control
- Admin-only operations protected
- Customers can only view/edit their own data

## 🎨 UI/UX Features

- Modern Material Design 3
- Teal color scheme
- Smooth animations
- Intuitive navigation
- Responsive layouts
- Loading indicators
- Error handling
- Success/failure feedback
- Pull-to-refresh functionality

## 📝 Marking Criteria Coverage

| Criteria | Marks | Status |
|----------|-------|--------|
| Admin login | 10 | ✅ Complete |
| Admin section | 20 | ✅ Complete |
| Customer registration | 10 | ✅ Complete |
| Customer login | 10 | ✅ Complete |
| Customer section | 20 | ✅ Complete |
| Additional functionalities | 20 | ✅ Complete |
| Report + Demo/viva | 10 | 📋 Pending |
| **Total** | **100** | **90/100** |

## 🎥 Demo Preparation

For your demo/viva presentation:
1. Set up Supabase with sample data
2. Test both admin and customer flows
3. Prepare to demonstrate all CRUD operations
4. Show authentication for both roles
5. Demonstrate additional features
6. Be ready to explain code architecture

## 📸 Screenshots

Include these in your report:
- Welcome screen
- Admin login
- Admin dashboard
- Resident management
- Visit approval
- Customer registration
- Customer dashboard
- Visit booking
- Services view

## 🚀 Future Enhancements

- Push notifications
- Real-time chat
- Photo uploads for residents
- Medicine tracking
- Health reports
- Payment integration
- Activity calendar
- Family photo gallery
- Video calls

## 👨‍💻 Author

Student Name: [Your Name]
Course: Advance Mobile App Development
Project: Flutter Mini-Project - Elder Care Hostel
Submission Date: February 18, 2026

## 📄 License

This project is for educational purposes as part of coursework.

## 🤝 Support

For issues or questions:
- Email: [your-email@example.com]
- Submit issues via course platform

---

**Note:** This app demonstrates a complete Flutter application with Supabase backend integration, featuring authentication, CRUD operations, and role-based access control suitable for a production-ready elderly care management system.
