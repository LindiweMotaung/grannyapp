# Elder Care Hostel App - Supabase Setup Guide

## 1. Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign up/login
2. Create a new project
3. Note your project URL and anon key

## 2. Database Tables Setup

Run the following SQL commands in your Supabase SQL Editor:

### Create Residents Table
```sql
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

-- Enable Row Level Security
ALTER TABLE residents ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow admins to do everything" ON residents
    FOR ALL USING (auth.jwt() ->> 'role' = 'admin');

CREATE POLICY "Allow customers to view active residents" ON residents
    FOR SELECT USING (status = 'active');
```

### Create Visits Table
```sql
CREATE TABLE visits (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    resident_id UUID REFERENCES residents(id) ON DELETE CASCADE,
    resident_name TEXT NOT NULL,
    visitor_name TEXT NOT NULL,
    visitor_phone TEXT NOT NULL,
    visit_date TEXT NOT NULL,
    visit_time TEXT NOT NULL,
    purpose TEXT NOT NULL,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE visits ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow admins full access to visits" ON visits
    FOR ALL USING (auth.jwt() ->> 'role' = 'admin');

CREATE POLICY "Allow customers to view their visits" ON visits
    FOR SELECT USING (visitor_phone = (auth.jwt() -> 'user_metadata' ->> 'phone'));

CREATE POLICY "Allow customers to create visits" ON visits
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow customers to update their visits" ON visits
    FOR UPDATE USING (visitor_phone = (auth.jwt() -> 'user_metadata' ->> 'phone'));
```

### Create Services Table
```sql
CREATE TABLE services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category TEXT NOT NULL,
    available BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE services ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow admins full access to services" ON services
    FOR ALL USING (auth.jwt() ->> 'role' = 'admin');

CREATE POLICY "Allow everyone to view available services" ON services
    FOR SELECT USING (available = true);
```

### Create Staff Table
```sql
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

-- Enable Row Level Security
ALTER TABLE staff ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow admins full access to staff" ON staff
    FOR ALL USING (auth.jwt() ->> 'role' = 'admin');
```

## 3. Create Admin User

Run this SQL to create an admin user:

```sql
-- First, you need to create the user through Supabase Auth UI or API
-- Then update their metadata:

UPDATE auth.users
SET raw_user_meta_data = jsonb_set(
    COALESCE(raw_user_meta_data, '{}'::jsonb),
    '{role}',
    '"admin"'
)
WHERE email = 'admin@eldercare.com';
```

## 4. Insert Sample Data (Optional)

```sql
-- Insert sample residents
INSERT INTO residents (name, age, gender, room_number, medical_conditions, emergency_contact, emergency_phone, admission_date, status) VALUES
('John Smith', 75, 'Male', '101', 'Diabetes, Hypertension', 'Mary Smith', '+1-555-0101', '2024-01-15', 'active'),
('Alice Johnson', 82, 'Female', '102', 'Arthritis', 'Bob Johnson', '+1-555-0102', '2024-02-20', 'active'),
('Robert Brown', 78, 'Male', '103', 'Heart condition', 'Sarah Brown', '+1-555-0103', '2024-03-10', 'active');

-- Insert sample services
INSERT INTO services (name, description, price, category, available) VALUES
('24/7 Nursing Care', 'Round-the-clock professional nursing care', 2500.00, 'medical', true),
('Physical Therapy', 'Regular physical therapy sessions', 800.00, 'medical', true),
('Recreation Activities', 'Daily recreational and social activities', 300.00, 'recreational', true),
('Personal Care Assistance', 'Help with daily activities', 1500.00, 'personal care', true),
('Meal Service', 'Three nutritious meals per day', 600.00, 'personal care', true);

-- Insert sample staff
INSERT INTO staff (name, role, phone, email, shift, active) VALUES
('Dr. Emily Wilson', 'doctor', '+1-555-1001', 'emily.wilson@eldercare.com', 'morning', true),
('Nurse Jane Davis', 'nurse', '+1-555-1002', 'jane.davis@eldercare.com', 'morning', true),
('Nurse Mike Taylor', 'nurse', '+1-555-1003', 'mike.taylor@eldercare.com', 'evening', true),
('Caregiver Lisa Anderson', 'caregiver', '+1-555-1004', 'lisa.anderson@eldercare.com', 'night', true);
```

## 5. Update App Configuration

1. Open `lib/services/supabase_service.dart`
2. Replace the placeholders with your actual Supabase credentials:
   - `YOUR_SUPABASE_URL` → Your project URL
   - `YOUR_SUPABASE_ANON_KEY` → Your project anon key

## 6. Create Admin Account

1. In Supabase Dashboard, go to Authentication → Users
2. Click "Add user"
3. Email: `admin@eldercare.com`
4. Password: `admin123` (or your choice)
5. After creation, run the UPDATE SQL from step 3 to set the role

## 7. Test the App

- Admin Login: admin@eldercare.com / admin123
- Create a customer account through the app's registration screen

## Security Notes

- Change default admin password immediately
- Use strong passwords in production
- Enable email verification in Supabase Auth settings
- Review and adjust RLS policies based on your needs
- Add additional security measures for production deployment
