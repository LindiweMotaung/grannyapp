-- ==========================================
-- CORRECTED DATABASE SCHEMA
-- (Matches your Flutter app exactly)
-- ==========================================

-- STEP 1: DROP EXISTING TABLES IF YOU WANT FRESH START
-- (Skip this if you already have data you want to keep)
/*
DROP TABLE IF EXISTS resident_family_links CASCADE;
DROP TABLE IF EXISTS visits CASCADE;
DROP TABLE IF EXISTS daily_activities CASCADE;
DROP TABLE IF EXISTS health_vitals CASCADE;
DROP TABLE IF EXISTS residents CASCADE;
DROP VIEW IF EXISTS admin_analytics;
*/

-- ==========================================
-- STEP 2: CREATE ALL TABLES
-- ==========================================

-- 1. Create Residents Table
CREATE TABLE IF NOT EXISTS residents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    age INTEGER NOT NULL,
    gender TEXT NOT NULL,
    blood_group TEXT,
    room_number TEXT NOT NULL,
    medical_conditions TEXT,
    allergies TEXT,
    emergency_contact TEXT NOT NULL,
    emergency_phone TEXT NOT NULL,
    admission_date TEXT NOT NULL,
    photo_url TEXT,
    status TEXT DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Create Health Vitals Table
CREATE TABLE IF NOT EXISTS health_vitals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    resident_id UUID REFERENCES residents(id) ON DELETE CASCADE,
    blood_pressure TEXT NOT NULL,
    heart_rate INTEGER NOT NULL,
    temperature DECIMAL(4, 1) NOT NULL,
    oxygen_level INTEGER NOT NULL,
    recorded_by TEXT,
    notes TEXT,
    recorded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Create Daily Activities Table
CREATE TABLE IF NOT EXISTS daily_activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    resident_id UUID REFERENCES residents(id) ON DELETE CASCADE,
    activity_type TEXT NOT NULL,
    activity_name TEXT NOT NULL,
    scheduled_time TEXT NOT NULL,
    day_of_week TEXT NOT NULL,
    status TEXT DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Create Visits Table (CORRECTED TO MATCH APP)
CREATE TABLE IF NOT EXISTS visits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    resident_id UUID REFERENCES residents(id) ON DELETE CASCADE,
    visitor_id UUID REFERENCES auth.users(id),
    visitor_name TEXT NOT NULL,
    visitor_contact TEXT NOT NULL,  -- Changed from visitor_phone
    scheduled_at TIMESTAMP WITH TIME ZONE NOT NULL,  -- Changed from visit_date + visit_time
    purpose TEXT NOT NULL,
    status TEXT DEFAULT 'pending',
    check_in_time TIMESTAMP WITH TIME ZONE,
    check_out_time TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. Create Resident-Family Links Table
CREATE TABLE IF NOT EXISTS resident_family_links (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    resident_id UUID REFERENCES residents(id) ON DELETE CASCADE,
    visitor_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    relationship TEXT NOT NULL,
    approved BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(resident_id, visitor_id)
);

-- ==========================================
-- STEP 3: ENABLE RLS ON ALL TABLES
-- ==========================================

ALTER TABLE residents ENABLE ROW LEVEL SECURITY;
ALTER TABLE health_vitals ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE visits ENABLE ROW LEVEL SECURITY;
ALTER TABLE resident_family_links ENABLE ROW LEVEL SECURITY;

-- ==========================================
-- STEP 4: DROP OLD POLICIES (IF THEY EXIST)
-- ==========================================

DROP POLICY IF EXISTS "Allow admins full access to residents" ON residents;
DROP POLICY IF EXISTS "Allow residents to view their own profile" ON residents;
DROP POLICY IF EXISTS "Allow visitors to view linked residents" ON residents;
DROP POLICY IF EXISTS "Allow admins full access to vitals" ON health_vitals;
DROP POLICY IF EXISTS "Allow residents to view their own vitals" ON health_vitals;
DROP POLICY IF EXISTS "Allow visitors to view linked resident vitals" ON health_vitals;
DROP POLICY IF EXISTS "Allow admins full access to activities" ON daily_activities;
DROP POLICY IF EXISTS "Allow residents to view their activities" ON daily_activities;
DROP POLICY IF EXISTS "Allow visitors to view linked resident activities" ON daily_activities;
DROP POLICY IF EXISTS "Allow admins full access to visits" ON visits;
DROP POLICY IF EXISTS "Allow visitors to view their own visits" ON visits;
DROP POLICY IF EXISTS "Allow visitors to create visits" ON visits;
DROP POLICY IF EXISTS "Allow admins full access to family links" ON resident_family_links;
DROP POLICY IF EXISTS "Allow visitors to view their own links" ON resident_family_links;

-- ==========================================
-- STEP 5: CREATE NEW POLICIES
-- ==========================================

-- Residents Policies
CREATE POLICY "Allow admins full access to residents" ON residents
    FOR ALL 
    TO authenticated
    USING (
        (SELECT (auth.jwt() -> 'user_metadata' ->> 'role')::text) = 'admin'
    );

CREATE POLICY "Allow residents to view and update their own profile" ON residents
    FOR ALL
    TO authenticated
    USING (id = auth.uid());

CREATE POLICY "Allow public to read residents for registration" ON residents
    FOR SELECT
    TO authenticated
    USING (true);

-- Health Vitals Policies
CREATE POLICY "Allow admins full access to vitals" ON health_vitals
    FOR ALL
    TO authenticated
    USING (
        (SELECT (auth.jwt() -> 'user_metadata' ->> 'role')::text) = 'admin'
    );

CREATE POLICY "Allow residents to view their own vitals" ON health_vitals
    FOR SELECT
    TO authenticated
    USING (resident_id = auth.uid());

-- Daily Activities Policies
CREATE POLICY "Allow admins full access to activities" ON daily_activities
    FOR ALL
    TO authenticated
    USING (
        (SELECT (auth.jwt() -> 'user_metadata' ->> 'role')::text) = 'admin'
    );

CREATE POLICY "Allow residents to view their activities" ON daily_activities
    FOR SELECT
    TO authenticated
    USING (resident_id = auth.uid());

-- Visits Policies
CREATE POLICY "Allow admins full access to visits" ON visits
    FOR ALL
    TO authenticated
    USING (
        (SELECT (auth.jwt() -> 'user_metadata' ->> 'role')::text) = 'admin'
    );

CREATE POLICY "Allow residents to view their visits" ON visits
    FOR SELECT
    TO authenticated
    USING (resident_id = auth.uid());

CREATE POLICY "Allow visitors to view their own visits" ON visits
    FOR SELECT
    TO authenticated
    USING (visitor_id = auth.uid());

CREATE POLICY "Allow visitors to create visits" ON visits
    FOR INSERT
    TO authenticated
    WITH CHECK (visitor_id = auth.uid());

-- Resident-Family Links Policies
CREATE POLICY "Allow admins full access to family links" ON resident_family_links
    FOR ALL
    TO authenticated
    USING (
        (SELECT (auth.jwt() -> 'user_metadata' ->> 'role')::text) = 'admin'
    );

CREATE POLICY "Allow visitors to view their own links" ON resident_family_links
    FOR SELECT
    TO authenticated
    USING (visitor_id = auth.uid());

-- ==========================================
-- STEP 6: CREATE ANALYTICS VIEW
-- ==========================================

CREATE OR REPLACE VIEW admin_analytics AS
SELECT
    (SELECT COUNT(*) FROM residents WHERE status = 'active') as total_residents,
    (SELECT COUNT(*) FROM visits WHERE status = 'pending') as pending_visits,
    (SELECT COUNT(*) FROM visits WHERE status = 'approved') as approved_visits,
    (SELECT COUNT(DISTINCT visitor_id) FROM visits) as total_visitors,
    (SELECT COUNT(*) FROM residents WHERE created_at >= NOW() - INTERVAL '7 days') as new_residents_week,
    (SELECT COUNT(*) FROM visits WHERE created_at >= NOW() - INTERVAL '7 days') as new_visits_week,
    (SELECT COUNT(*) FROM health_vitals WHERE recorded_at >= NOW() - INTERVAL '24 hours') as vitals_recorded_today,
    (SELECT COUNT(DISTINCT room_number) FROM residents WHERE status = 'active') as occupied_rooms;

-- ==========================================
-- STEP 7: CREATE INDEXES FOR PERFORMANCE
-- ==========================================

CREATE INDEX IF NOT EXISTS idx_residents_status ON residents(status);
CREATE INDEX IF NOT EXISTS idx_health_vitals_resident_id ON health_vitals(resident_id);
CREATE INDEX IF NOT EXISTS idx_health_vitals_recorded_at ON health_vitals(recorded_at);
CREATE INDEX IF NOT EXISTS idx_daily_activities_resident_id ON daily_activities(resident_id);
CREATE INDEX IF NOT EXISTS idx_daily_activities_day ON daily_activities(day_of_week);
CREATE INDEX IF NOT EXISTS idx_visits_resident_id ON visits(resident_id);
CREATE INDEX IF NOT EXISTS idx_visits_visitor_id ON visits(visitor_id);
CREATE INDEX IF NOT EXISTS idx_visits_status ON visits(status);
CREATE INDEX IF NOT EXISTS idx_visits_scheduled_at ON visits(scheduled_at);
