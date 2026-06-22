# Testing Guide - Beau Bassin Elderly Care App

## 🔍 Where Data is Stored in Supabase

### Database Tables Location:
1. Go to https://supabase.com/dashboard
2. Select your project: `otfykqmpxspygrwghhro`
3. Click **"Table Editor"** in left sidebar
4. You'll see these tables:
   - **residents** - All resident profiles
   - **health_vitals** - Vitals recorded by admin
   - **daily_activities** - Schedules created by admin
   - **visits** - Visit requests from visitors
   - **resident_family_links** - Family connections

---

## 🧪 TEST 1: Force Data via SQL (Verify App Reads Database)

### Step 1: Open SQL Editor
1. In Supabase Dashboard, click **"SQL Editor"** (left sidebar)
2. Click **"New Query"**

### Step 2: Insert Test Resident
```sql
-- Insert a test resident
INSERT INTO residents (
    id,
    name,
    age,
    gender,
    blood_group,
    room_number,
    medical_conditions,
    allergies,
    emergency_contact,
    emergency_phone,
    admission_date,
    status
) VALUES (
    gen_random_uuid(),
    'Margaret Smith',
    75,
    'Female',
    'O+',
    '204',
    'Diabetes, High Blood Pressure',
    'Penicillin, Peanuts',
    'John Smith',
    '(555) 123-4567',
    'Jan 15, 2024',
    'active'
) RETURNING id;
```

**SAVE THE ID** that gets returned - you'll need it for the next steps!

### Step 3: Insert Test Vitals (Replace YOUR_RESIDENT_ID)
```sql
-- Insert test vitals (replace with ID from Step 2)
INSERT INTO health_vitals (
    resident_id,
    blood_pressure,
    heart_rate,
    temperature,
    oxygen_level,
    recorded_at
) VALUES 
(
    'YOUR_RESIDENT_ID',  -- Replace this!
    '120/80',
    72,
    98.6,
    98,
    NOW() - INTERVAL '1 day'
),
(
    'YOUR_RESIDENT_ID',  -- Replace this!
    '118/78',
    70,
    98.4,
    97,
    NOW() - INTERVAL '2 days'
),
(
    'YOUR_RESIDENT_ID',  -- Replace this!
    '122/82',
    74,
    98.7,
    99,
    NOW() - INTERVAL '3 days'
);
```

### Step 4: Insert Test Activities (Replace YOUR_RESIDENT_ID)
```sql
-- Insert test daily activities
INSERT INTO daily_activities (
    resident_id,
    activity_type,
    activity_name,
    scheduled_time,
    day_of_week,
    status,
    notes
) VALUES 
(
    'YOUR_RESIDENT_ID',  -- Replace this!
    'Meds',
    'Morning Medication',
    '09:00 AM',
    'Monday',
    'completed',
    'Lisinopril 10mg administered'
),
(
    'YOUR_RESIDENT_ID',  -- Replace this!
    'Therapy',
    'Physical Therapy',
    '10:30 AM',
    'Monday',
    'completed',
    '20-minute walking session'
),
(
    'YOUR_RESIDENT_ID',  -- Replace this!
    'Meals',
    'Lunch',
    '12:00 PM',
    'Monday',
    'pending',
    NULL
);
```

### Step 5: Verify in App
1. **Open your Flutter app**
2. **Login as Admin**: lindiwe.motaung@umail.utm.ac.mu
3. **Check Admin Dashboard**:
   - Should show "1" resident count
4. **Click "View Residents"**:
   - Should see Margaret Smith, Room 204
5. **Click "View Profile" on Margaret**:
   - Verify all fields show correct data
   - Check Blood Group: O+
   - Check Allergies field
6. **Go to "Manage Schedules"**:
   - Click Monday
   - Should see 3 activities for Margaret Smith
7. **Go to "Record Vitals"**:
   - Should see "3 Vitals Recorded Today"

---

## 🧪 TEST 2: Register New Resident (End-to-End Test)

### Step 1: Register a New Resident
1. **Open Flutter app**
2. **Click "Get Started"** on welcome screen
3. **Select "As a Resident"**
4. **Fill registration form**:
   ```
   Full Name: Jane Doe
   Age: 68
   Gender: Female
   Room Number: 305
   Email: jane.doe@test.com
   Password: Test123
   Emergency Contact: Robert Doe
   Emergency Phone: (555) 987-6543
   Admission Date: Feb 18, 2026
   ```
5. **Click "Create Account"**
6. **Should redirect to Resident Dashboard**

### Step 2: Verify in Supabase
1. **Go to Supabase → Table Editor → residents**
2. **Find Jane Doe in the table**
3. **Verify all fields are populated correctly**

### Step 3: Add Data as Admin
1. **Logout from resident account**
2. **Login as Admin**: lindiwe.motaung@umail.utm.ac.mu
3. **Go to "View Residents"**
4. **Find Jane Doe, click "View Profile"**
5. **Click Edit, add**:
   - Blood Group: A+
   - Allergies: None
   - Medical Conditions: Arthritis
6. **Save changes**

### Step 4: Record Vitals for Jane
1. **Go to "Record Vitals"**
2. **Select "Jane Doe - Room 305"** from dropdown
3. **Fill vitals**:
   ```
   Blood Pressure: 125/85
   Heart Rate: 75 bpm
   Temperature: 98.5°F
   Oxygen Level: 97%
   ```
4. **Click "Record Vitals"**

### Step 5: Add Schedule for Jane
1. **Go to "Manage Schedules"**
2. **Click "+" button**
3. **Select Jane Doe from dropdown**
4. **Fill form**:
   ```
   Activity Type: Medication
   Activity Name: Morning Vitamins
   Day: Tuesday (or today's day)
   Time: 08:00 AM
   Notes: Take with breakfast
   ```
5. **Click "Add Activity"**

### Step 6: Login as Jane and Verify
1. **Logout from admin**
2. **Login as Jane**: jane.doe@test.com / Test123
3. **Should see Resident Dashboard with**:
   - Real name: Jane Doe
   - Room: 305
   - Today's activities (if you scheduled for today)
   - Latest vitals card showing the vitals you just recorded

4. **Click "Health" tab at bottom**:
   - Should see Blood Type: A+
   - Admitted: Feb 18, 2026
   - Medical Conditions: Arthritis
   - Recent Vitals showing BP: 125/85, HR: 75, etc.
   - Today's Care Notes showing "Morning Vitamins" (if scheduled for today)
   - Emergency Contact: Robert Doe
   - Phone: (555) 987-6543

---

## 🧪 TEST 3: Test Visit Approval Flow

### Step 1: Insert Test Visit Request via SQL
```sql
-- Insert a test visit request
INSERT INTO visits (
    resident_id,
    visitor_name,
    visitor_contact,
    scheduled_at,
    purpose,
    status
) VALUES (
    (SELECT id FROM residents WHERE name = 'Jane Doe' LIMIT 1),
    'Robert Doe',
    '(555) 987-6543',
    NOW() + INTERVAL '2 days' + INTERVAL '2 hours',
    'Family Visit',
    'pending'
);
```

### Step 2: Approve as Admin
1. **Login as Admin**
2. **Go to "Approve Visits"**
3. **Should see visit card**:
   - Visitor: Robert Doe
   - Visiting: Jane Doe, Room 305
   - Status: Pending (orange)
4. **Click "Approve" button**
5. **Should show success message**
6. **Visit card should now show "Approved" (green)**

### Step 3: Verify in Database
1. **Go to Supabase → Table Editor → visits**
2. **Find the visit for Robert Doe**
3. **Status should be "approved"**

---

## 📋 Quick Verification Checklist

### ✅ Registration Flow
- [ ] Resident can register with all fields
- [ ] Data appears in Supabase `residents` table
- [ ] Resident can login immediately after registration
- [ ] Dashboard shows resident's name and room number

### ✅ Admin → Resident Data Flow
- [ ] Admin can view all residents in list
- [ ] Admin can edit resident profile (blood group, allergies, etc.)
- [ ] Admin can record vitals for resident
- [ ] Admin can create schedules for resident
- [ ] Changes save to database correctly

### ✅ Resident View (Health Tab)
- [ ] Blood Type displays correctly
- [ ] Admitted date shows
- [ ] Allergies appear as yellow chips (if present)
- [ ] Medical conditions show in "Current Medications"
- [ ] Recent Vitals show with correct values
- [ ] Today's Care Notes show scheduled activities
- [ ] Emergency contact displays correctly

### ✅ Search & Filter
- [ ] Residents list search bar works
- [ ] Manage Schedules day filter works
- [ ] Approve Visits tabs (All/Pending/Approved) filter correctly

---

## 🐛 Common Issues & Solutions

### Issue: "No residents found" in admin
**Solution**: Check that resident registered with role='resident' in auth metadata

### Issue: Vitals not showing in resident health tab
**Solution**: Verify `resident_id` in health_vitals matches the user's auth ID

### Issue: Activities not appearing
**Solution**: Check that `day_of_week` matches today (e.g., 'Monday' not 'monday')

### Issue: Can't login after registration
**Solution**: Check Supabase Auth → Users tab to verify user was created

---

## 🔗 Quick Links

- **Supabase Dashboard**: https://supabase.com/dashboard/project/otfykqmpxspygrwghhro
- **Table Editor**: https://supabase.com/dashboard/project/otfykqmpxspygrwghhro/editor
- **SQL Editor**: https://supabase.com/dashboard/project/otfykqmpxspygrwghhro/sql
- **Auth Users**: https://supabase.com/dashboard/project/otfykqmpxspygrwghhro/auth/users

---

## 📊 View All Data Queries

### See all residents with their details:
```sql
SELECT 
    name,
    age,
    gender,
    blood_group,
    room_number,
    admission_date,
    status
FROM residents
ORDER BY name;
```

### See all vitals with resident names:
```sql
SELECT 
    r.name as resident_name,
    r.room_number,
    v.blood_pressure,
    v.heart_rate,
    v.temperature,
    v.oxygen_level,
    v.recorded_at
FROM health_vitals v
JOIN residents r ON v.resident_id = r.id
ORDER BY v.recorded_at DESC;
```

### See all activities with resident names:
```sql
SELECT 
    r.name as resident_name,
    a.activity_type,
    a.activity_name,
    a.scheduled_time,
    a.day_of_week,
    a.status
FROM daily_activities a
JOIN residents r ON a.resident_id = r.id
ORDER BY a.day_of_week, a.scheduled_time;
```

### See all visit requests:
```sql
SELECT 
    r.name as resident_name,
    r.room_number,
    v.visitor_name,
    v.visitor_contact,
    v.scheduled_at,
    v.purpose,
    v.status
FROM visits v
JOIN residents r ON v.resident_id = r.id
ORDER BY v.scheduled_at DESC;
```

---

## ✨ Testing Complete!

If all tests pass, your app is working correctly with real-time database synchronization! 🎉
