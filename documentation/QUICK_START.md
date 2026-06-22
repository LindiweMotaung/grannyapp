# 🚀 QUICK START GUIDE - Elder Care Hostel App

## Step-by-Step Setup (15 minutes)

### ✅ STEP 1: Supabase Account Setup (5 min)

1. Go to https://supabase.com
2. Sign up or login
3. Click "New Project"
4. Fill in:
   - Name: `elder-care-hostel`
   - Database Password: (Save this!)
   - Region: Choose closest to you
5. Wait for project to be ready (~2 minutes)

### ✅ STEP 2: Create Database Tables (3 min)

1. In your Supabase dashboard, click **SQL Editor** (left sidebar)
2. Click **New Query**
3. Copy and paste this entire SQL script:

```sql
-- Create Residents Table
CREATE TABLE residents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    age INTEGER NOT NULL,
    gender TEXT NOT NULL,
    room_number TEXT NOT NULL,
    medical_conditions TEXT,
    emergency_contact TEXT NOT NULL,
    emergency_phone TEXT NOT NULL,
    admission_date TEXT NOT NULL,
    photo_url TEXT,
    status TEXT DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE residents ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow admins all on residents" ON residents
    FOR ALL USING (
        (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
    );

CREATE POLICY "Allow customers view active residents" ON residents
    FOR SELECT USING (status = 'active');

-- Create Visits Table
CREATE TABLE visits (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    resident_id UUID,
    resident_name TEXT NOT NULL,
    visitor_name TEXT NOT NULL,
    visitor_phone TEXT NOT NULL,
    visit_date TEXT NOT NULL,
    visit_time TEXT NOT NULL,
    purpose TEXT NOT NULL,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE visits ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow admins all on visits" ON visits
    FOR ALL USING (
        (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
    );

CREATE POLICY "Allow customers view their visits" ON visits
    FOR SELECT USING (
        visitor_phone = (auth.jwt() -> 'user_metadata' ->> 'phone')
    );

CREATE POLICY "Allow customers create visits" ON visits
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow customers update their visits" ON visits
    FOR UPDATE USING (
        visitor_phone = (auth.jwt() -> 'user_metadata' ->> 'phone')
    );

-- Create Services Table
CREATE TABLE services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category TEXT NOT NULL,
    available BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE services ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow admins all on services" ON services
    FOR ALL USING (
        (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
    );

CREATE POLICY "Allow view available services" ON services
    FOR SELECT USING (available = true);

-- Create Staff Table
CREATE TABLE staff (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    role TEXT NOT NULL,
    phone TEXT NOT NULL,
    email TEXT NOT NULL,
    shift TEXT NOT NULL,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE staff ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow admins all on staff" ON staff
    FOR ALL USING (
        (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
    );

-- Insert Sample Data
INSERT INTO residents (name, age, gender, room_number, medical_conditions, emergency_contact, emergency_phone, admission_date) VALUES
('John Smith', 75, 'Male', '101', 'Diabetes, Hypertension', 'Mary Smith', '+1-555-0101', '2024-01-15'),
('Alice Johnson', 82, 'Female', '102', 'Arthritis', 'Bob Johnson', '+1-555-0102', '2024-02-20'),
('Robert Brown', 78, 'Male', '103', 'Heart condition', 'Sarah Brown', '+1-555-0103', '2024-03-10');

INSERT INTO services (name, description, price, category) VALUES
('24/7 Nursing Care', 'Round-the-clock professional nursing care', 2500.00, 'medical'),
('Physical Therapy', 'Regular physical therapy sessions', 800.00, 'medical'),
('Recreation Activities', 'Daily recreational and social activities', 300.00, 'recreational'),
('Personal Care Assistance', 'Help with daily activities', 1500.00, 'personal care'),
('Meal Service', 'Three nutritious meals per day', 600.00, 'personal care');

INSERT INTO staff (name, role, phone, email, shift) VALUES
('Dr. Emily Wilson', 'doctor', '+1-555-1001', 'emily.wilson@eldercare.com', 'morning'),
('Nurse Jane Davis', 'nurse', '+1-555-1002', 'jane.davis@eldercare.com', 'morning'),
('Nurse Mike Taylor', 'nurse', '+1-555-1003', 'mike.taylor@eldercare.com', 'evening');
```

4. Click **Run** or press `Ctrl+Enter`
5. You should see "Success. No rows returned"

### ✅ STEP 3: Create Admin User (2 min)

1. In Supabase dashboard, click **Authentication** → **Users** (left sidebar)
2. Click **Add User** → **Create new user**
3. Fill in:
   - Email: `admin@eldercare.com`
   - Password: `admin123`
   - Auto Confirm User: ✅ Check this box
4. Click **Create user**
5. Find the user in the list, click the **•••** menu → **Edit user**
6. Scroll to **USER METADATA** section
7. Add this JSON:
```json
{
  "role": "admin"
}
```
8. Click **Save**

### ✅ STEP 4: Get Your API Keys (1 min)

1. In Supabase, click **Project Settings** (gear icon at bottom left)
2. Click **API** in the left menu
3. You'll see:
   - **Project URL** - Copy this
   - **anon/public** key - Copy this

### ✅ STEP 5: Configure Flutter App (2 min)

1. Open the file: `lib/services/supabase_service.dart`
2. Find these lines:
```dart
url: 'YOUR_SUPABASE_URL',
anonKey: 'YOUR_SUPABASE_ANON_KEY',
```
3. Replace with your actual values:
```dart
url: 'https://xxxxxxxxxxxxx.supabase.co',  // Your Project URL
anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',  // Your anon key
```
4. Save the file

### ✅ STEP 6: Run the App (2 min)

1. Open terminal in VS Code
2. Run:
```bash
flutter run
```
3. Select your device (Android emulator, iOS simulator, or Chrome)

---

## 🎯 Testing the App

### Test Admin Features:
1. Launch app → Click **Admin Login**
2. Login with:
   - Email: `admin@eldercare.com`
   - Password: `admin123`
3. You should see Admin Dashboard with 4 tiles
4. Click each tile to test:
   - **Residents** - View 3 sample residents, try adding one
   - **Visits** - Will be empty initially
   - **Services** - View 5 sample services
   - **Staff** - View 3 sample staff members

### Test Customer Features:
1. Go back to Welcome screen
2. Click **Family/Customer Login**
3. Click **Register Now**
4. Fill in registration form:
   - Name: Your name
   - Email: your-email@test.com
   - Phone: +1-555-9999
   - Password: test123
5. After registration, login
6. You should see Customer Dashboard
7. Test:
   - **View Residents** - See the 3 residents
   - **Book a Visit** - Schedule a visit
   - **Our Services** - Browse services
   - **My Visits** - See your booked visits

---

## ⚠️ Troubleshooting

### Problem: "Invalid API key"
**Solution:** Double-check you copied the ANON key (not service_role key) from Supabase

### Problem: "Table doesn't exist"
**Solution:** Make sure Step 2 SQL ran successfully. Check SQL Editor history.

### Problem: Admin login fails
**Solution:** 
1. Check user exists in Authentication → Users
2. Verify user metadata has `"role": "admin"`
3. Make sure Auto Confirm User was checked

### Problem: Can't see data in app
**Solution:**
1. Check internet connection
2. Verify Supabase project is running (green indicator)
3. Check RLS policies are created (run Step 2 SQL again)

### Problem: Customer can't register
**Solution:**
1. In Supabase Dashboard → Authentication → Settings
2. Enable "Enable email signups"
3. Disable "Enable email confirmations" (for testing)

---

## 📱 Demo Day Checklist

Before your presentation:
- [ ] Supabase project is running
- [ ] Admin account works
- [ ] Sample data is loaded
- [ ] Test customer registration
- [ ] Test booking a visit
- [ ] Admin can approve visits
- [ ] All CRUD operations work
- [ ] Take screenshots for report
- [ ] Prepare to explain code

---

## 📞 Need Help?

Common issues and solutions:
1. **App crashes on start** → Run `flutter clean` then `flutter pub get`
2. **White screen** → Check Supabase URL is correct
3. **Data not loading** → Check internet and Supabase status
4. **Login fails** → Verify credentials and user role metadata

---

## 🎓 For Your Report

Include:
1. **Screenshots** of all screens (admin & customer)
2. **Code snippets** from key files:
   - `auth_service.dart`
   - `admin_dashboard.dart`
   - `customer_dashboard.dart`
3. **Database schema** diagram (from Supabase Table Editor)
4. **Explanation** of features implemented
5. **Challenges** faced and solutions
6. **Future improvements**

---

**Total Setup Time: ~15 minutes**

**Good luck with your project! 🚀**
