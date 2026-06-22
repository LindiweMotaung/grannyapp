# SUPABASE SETUP GUIDE
## Simple Step-by-Step Instructions

---

## OVERVIEW

This guide explains how to set up Supabase for the Beau Bassin Elderly Care Hostel Management System and create the necessary database tables using SQL scripts.

---

## STEP 1: CREATE SUPABASE ACCOUNT

### 1.1 Sign Up
1. Go to [https://supabase.com](https://supabase.com)
2. Click **"Start your project"** or **"Sign Up"**
3. Sign up using:
   - GitHub account (recommended), OR
   - Email and password

### 1.2 Verify Email
- Check your email inbox
- Click the verification link
- Your account is now active

---

## STEP 2: CREATE NEW PROJECT

### 2.1 Create Project
1. Once logged in, click **"New Project"**
2. Fill in the details:
   ```
   Organization: Your organization name
   Project Name: elderly-care-system (or any name)
   Database Password: Create a strong password
   Region: Choose closest to you (e.g., Singapore for Mauritius)
   ```
3. Click **"Create new project"**
4. Wait 2-3 minutes for project setup

### 2.2 Get Project Credentials
Once the project is ready:
1. Go to **Project Settings** (gear icon on left sidebar)
2. Click **"API"** tab
3. You'll see:
   ```
   Project URL: https://otfykqmpxspygrwghhro.supabase.co
   anon/public key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```
4. **Copy these** - you'll need them later!

---

## STEP 3: CREATE DATABASE TABLES (SQL SCRIPTS)

### 3.1 Open SQL Editor
1. In your Supabase project dashboard
2. Click **"SQL Editor"** from left sidebar
3. Click **"New query"**

### 3.2 Run First SQL Script - Create Tables

**File**: `DATABASE_SCHEMA_FIXED.sql`

Copy and paste this SQL script into the SQL Editor:

```sql
-- ================================================
-- ELDERLY CARE SYSTEM - DATABASE SCHEMA
-- ================================================

-- 1. CREATE RESIDENTS TABLE
CREATE TABLE IF NOT EXISTS residents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  age INTEGER,
  room_number VARCHAR(50),
  blood_type VARCHAR(10),
  allergies TEXT,
  medications TEXT[],
  care_notes TEXT,
  emergency_contact_name VARCHAR(255),
  emergency_contact_phone VARCHAR(50),
  phone VARCHAR(50),
  email VARCHAR(255),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 2. CREATE HEALTH VITALS TABLE
CREATE TABLE IF NOT EXISTS health_vitals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  resident_id UUID REFERENCES residents(id) ON DELETE CASCADE,
  blood_pressure VARCHAR(20),
  heart_rate INTEGER,
  temperature DECIMAL(4,2),
  oxygen_level INTEGER,
  notes TEXT,
  recorded_at TIMESTAMP DEFAULT NOW()
);

-- 3. CREATE DAILY ACTIVITIES TABLE
CREATE TABLE IF NOT EXISTS daily_activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  resident_id UUID REFERENCES residents(id) ON DELETE CASCADE,
  activity_type VARCHAR(50),
  description TEXT,
  day_of_week VARCHAR(20),
  scheduled_time TIME,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 4. CREATE VISITS TABLE
CREATE TABLE IF NOT EXISTS visits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  resident_id UUID REFERENCES residents(id) ON DELETE CASCADE,
  visitor_name VARCHAR(255),
  visitor_contact VARCHAR(50),
  relationship VARCHAR(100),
  scheduled_at TIMESTAMP,
  purpose TEXT,
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW()
);

-- ================================================
-- CREATE INDEXES FOR BETTER PERFORMANCE
-- ================================================

CREATE INDEX IF NOT EXISTS idx_residents_email ON residents(email);
CREATE INDEX IF NOT EXISTS idx_health_vitals_resident ON health_vitals(resident_id);
CREATE INDEX IF NOT EXISTS idx_activities_resident ON daily_activities(resident_id);
CREATE INDEX IF NOT EXISTS idx_visits_resident ON visits(resident_id);
CREATE INDEX IF NOT EXISTS idx_visits_status ON visits(status);
```

**What this does**:
- Creates 4 main tables: residents, health_vitals, daily_activities, visits
- Sets up relationships between tables
- Creates indexes for faster data retrieval

**To run**:
1. Paste the SQL above into SQL Editor
2. Click **"Run"** button (bottom right)
3. You should see: **"Success. No rows returned"**
4. Check **"Table Editor"** - you'll see your 4 new tables!

### 3.3 Run Second SQL Script - Add Test Data

**File**: `INSERT_MARGARET_DATA.sql`

Copy and paste this SQL script:

```sql
-- ================================================
-- INSERT TEST DATA - MARGARET SMITH
-- ================================================

-- 1. INSERT TEST RESIDENT
INSERT INTO residents (
  name,
  age,
  room_number,
  blood_type,
  allergies,
  medications,
  care_notes,
  emergency_contact_name,
  emergency_contact_phone,
  phone,
  email
) VALUES (
  'Margaret Smith',
  76,
  '204',
  'O+',
  'Penicillin',
  ARRAY['Blood pressure medication', 'Vitamin D'],
  'Requires assistance with mobility. Prefers morning activities.',
  'John Smith',
  '+230 5123 4567',
  '+230 5987 6543',
  'margaret.smith@test.com'
);

-- 2. GET MARGARET'S ID (for next inserts)
-- This will be used automatically in the next queries

-- 3. INSERT SAMPLE HEALTH VITALS
INSERT INTO health_vitals (
  resident_id,
  blood_pressure,
  heart_rate,
  temperature,
  oxygen_level,
  notes,
  recorded_at
)
SELECT 
  id,
  '120/80',
  72,
  36.8,
  98,
  'Normal vitals, patient feeling well',
  NOW() - INTERVAL '1 day'
FROM residents WHERE email = 'margaret.smith@test.com';

-- 4. INSERT SAMPLE ACTIVITIES
-- Monday Activities
INSERT INTO daily_activities (resident_id, activity_type, description, day_of_week, scheduled_time)
SELECT id, 'Exercise', 'Morning Walk', 'Monday', '08:00:00'
FROM residents WHERE email = 'margaret.smith@test.com';

INSERT INTO daily_activities (resident_id, activity_type, description, day_of_week, scheduled_time)
SELECT id, 'Meal', 'Breakfast', 'Monday', '09:00:00'
FROM residents WHERE email = 'margaret.smith@test.com';

INSERT INTO daily_activities (resident_id, activity_type, description, day_of_week, scheduled_time)
SELECT id, 'Social', 'Group Discussion', 'Monday', '14:00:00'
FROM residents WHERE email = 'margaret.smith@test.com';

-- Tuesday Activities
INSERT INTO daily_activities (resident_id, activity_type, description, day_of_week, scheduled_time)
SELECT id, 'Therapy', 'Physical Therapy', 'Tuesday', '10:00:00'
FROM residents WHERE email = 'margaret.smith@test.com';

-- 5. INSERT SAMPLE VISIT REQUEST
INSERT INTO visits (
  resident_id,
  visitor_name,
  visitor_contact,
  relationship,
  scheduled_at,
  purpose,
  status
)
SELECT 
  id,
  'John Smith',
  '+230 5123 4567',
  'Son',
  NOW() + INTERVAL '3 days',
  'Weekly family visit',
  'approved'
FROM residents WHERE email = 'margaret.smith@test.com';
```

**What this does**:
- Adds Margaret Smith as a test resident
- Adds sample health vitals for her
- Creates some daily activities
- Adds an approved visit request

**To run**:
1. Paste the SQL above into SQL Editor (new query)
2. Click **"Run"**
3. You should see: **"Success"** messages
4. Check **"Table Editor"** → **residents** → You'll see Margaret's data!

### 3.4 Run Third SQL Script - Disable RLS (For Testing)

**File**: `DISABLE_ALL_RLS.sql`

```sql
-- ================================================
-- DISABLE ROW LEVEL SECURITY (FOR TESTING ONLY)
-- ================================================
-- WARNING: In production, you should enable RLS with proper policies
-- This is only for development and testing purposes

-- Disable RLS on all tables
ALTER TABLE residents DISABLE ROW LEVEL SECURITY;
ALTER TABLE health_vitals DISABLE ROW LEVEL SECURITY;
ALTER TABLE daily_activities DISABLE ROW LEVEL SECURITY;
ALTER TABLE visits DISABLE ROW LEVEL SECURITY;

-- Confirm RLS is disabled
SELECT 
  schemaname, 
  tablename, 
  rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
  AND tablename IN ('residents', 'health_vitals', 'daily_activities', 'visits');
```

**What this does**:
- Disables Row Level Security (RLS) so you can test without permission issues
- **Note**: In production, you should enable RLS with proper access policies

**To run**:
1. Paste the SQL above into SQL Editor
2. Click **"Run"**
3. You should see a table showing `rowsecurity = false` for all tables

---

## STEP 4: CONNECT FLUTTER APP TO SUPABASE

### 4.1 Update Supabase Service File

**File**: `lib/services/supabase_service.dart`

Find these lines near the top of the file:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseKey = 'YOUR_SUPABASE_ANON_KEY';
```

Replace with **your actual credentials** from Step 2.2:

```dart
static const String supabaseUrl = 'https://otfykqmpxspygrwghhro.supabase.co';
static const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

### 4.2 Initialize Supabase in Flutter

The app already has this code in `lib/main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseService.supabaseUrl,
    anonKey: SupabaseService.supabaseKey,
  );
  runApp(MyApp());
}
```

This initializes Supabase when the app starts.

---

## STEP 5: CREATE ADMIN USER IN SUPABASE AUTH

### 5.1 Enable Email Authentication
1. In Supabase dashboard, go to **Authentication** → **Providers**
2. Make sure **Email** is enabled (it's enabled by default)

### 5.2 Create Admin User Manually
1. Go to **Authentication** → **Users**
2. Click **"Add user"** → **"Create new user"**
3. Fill in:
   ```
   Email: lindiwe.motaung@umail.utm.ac.mu
   Password: Admin123 (or any password you want)
   Auto Confirm User: ✅ (check this box)
   ```
4. Click **"Create user"**

### 5.3 Add Admin Role to User Metadata
1. In the users list, find the admin user you just created
2. Click on the user to open details
3. Scroll to **"User Metadata"** section
4. Click **"Edit"**
5. Add this JSON:
   ```json
   {
     "role": "admin"
   }
   ```
6. Click **"Save"**

**Now the admin can login!**

### 5.4 Create Test Resident User
1. Go to **Authentication** → **Users**
2. Click **"Add user"** → **"Create new user"**
3. Fill in:
   ```
   Email: margaret.smith@test.com
   Password: Margaret123
   Auto Confirm User: ✅
   ```
4. Click **"Create user"**
5. Edit user metadata:
   ```json
   {
     "role": "resident"
   }
   ```
6. Click **"Save"**

---

## STEP 6: TEST THE CONNECTION

### 6.1 Run the Flutter App
```bash
cd grannyapp
flutter run -d windows
```

### 6.2 Test Admin Login
1. On welcome screen, click **"Admin Portal"**
2. Login with:
   - Email: `lindiwe.motaung@umail.utm.ac.mu`
   - Password: `Admin123` (or what you set)
3. You should see the Admin Dashboard!

### 6.3 Test Resident Login
1. On welcome screen, click **"Resident/Visitor Login"**
2. Login with:
   - Email: `margaret.smith@test.com`
   - Password: `Margaret123`
3. You should see Margaret's dashboard with her data!

---

## TROUBLESHOOTING

### Problem: "Invalid API credentials"
**Solution**: Double-check your Supabase URL and API key in `supabase_service.dart`

### Problem: "No data showing"
**Solution**: 
1. Check if you ran all 3 SQL scripts
2. Make sure RLS is disabled (run `DISABLE_ALL_RLS.sql` again)
3. Verify data exists in Table Editor

### Problem: "Cannot login"
**Solution**: 
1. Check if user exists in Authentication → Users
2. Make sure "Auto Confirm User" was checked
3. Verify user metadata has correct "role"

### Problem: "Connection timeout"
**Solution**: 
1. Check your internet connection
2. Verify Supabase project is active (not paused)
3. Check if project URL is correct

---

## SUMMARY

### What You Created:

1. **Supabase Project**: Cloud database and authentication service
2. **4 Database Tables**: 
   - `residents` - Store resident information
   - `health_vitals` - Track health measurements
   - `daily_activities` - Schedule activities
   - `visits` - Manage visit requests

3. **Test Data**: Margaret Smith with sample health vitals, activities, and visits

4. **User Accounts**:
   - Admin: `lindiwe.motaung@umail.utm.ac.mu`
   - Test Resident: `margaret.smith@test.com`

5. **Flutter Connection**: App connected to Supabase for real-time data

### Database Structure:

```
residents
├── id (UUID)
├── name, age, room_number
├── blood_type, allergies, medications
├── emergency contacts
└── timestamps

health_vitals
├── id (UUID)
├── resident_id → links to residents
├── blood_pressure, heart_rate
├── temperature, oxygen_level
└── recorded_at

daily_activities
├── id (UUID)
├── resident_id → links to residents
├── activity_type, description
├── day_of_week, scheduled_time
└── created_at

visits
├── id (UUID)
├── resident_id → links to residents
├── visitor_name, contact, relationship
├── scheduled_at, purpose
└── status (pending/approved/rejected)
```

---

## NEXT STEPS

### For Production (Before Deployment):

1. **Enable RLS (Row Level Security)**:
   ```sql
   ALTER TABLE residents ENABLE ROW LEVEL SECURITY;
   -- Create policies for each user role
   ```

2. **Create Proper RLS Policies**:
   - Admins: Full access to all tables
   - Residents: Access only their own data
   - Visitors: Limited access to visit requests

3. **Secure API Keys**:
   - Store credentials in environment variables
   - Never commit API keys to Git
   - Use `.env` files (add to `.gitignore`)

4. **Enable Email Verification**:
   - In Authentication → Providers → Email
   - Enable "Confirm email" option
   - Configure email templates

5. **Set Up Backup**:
   - Enable automatic database backups
   - Download manual backups regularly

---

## USEFUL SUPABASE RESOURCES

- **Documentation**: https://supabase.com/docs
- **SQL Reference**: https://supabase.com/docs/guides/database
- **Auth Guide**: https://supabase.com/docs/guides/auth
- **Flutter Integration**: https://supabase.com/docs/reference/dart

---

**End of Setup Guide**

Your Supabase database is now ready and connected to your Flutter app! 🎉
