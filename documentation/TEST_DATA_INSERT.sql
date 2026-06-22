-- ==========================================
-- STEP-BY-STEP TEST DATA INSERTION
-- Run these queries ONE AT A TIME in Supabase SQL Editor
-- ==========================================

-- ==========================================
-- TEST 1: INSERT TEST RESIDENT
-- ==========================================
-- Copy and run this first, then SAVE THE ID that gets returned!

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
    '+230 5123-4567',
    'Jan 15, 2024',
    'active'
) RETURNING id, name, room_number;

-- ⚠️ IMPORTANT: Copy the ID from the result above!
-- You'll use it in the next steps where you see 'PASTE_RESIDENT_ID_HERE'

-- ==========================================
-- TEST 2: VERIFY RESIDENT IN TABLE
-- ==========================================
-- Run this to see if Margaret Smith was inserted correctly

SELECT 
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
FROM residents 
WHERE name = 'Margaret Smith';

-- ==========================================
-- TEST 3: INSERT HEALTH VITALS
-- ==========================================
-- ⚠️ REPLACE 'PASTE_RESIDENT_ID_HERE' with the actual ID from TEST 1

INSERT INTO health_vitals (
    resident_id,
    blood_pressure,
    heart_rate,
    temperature,
    oxygen_level,
    recorded_at
) VALUES 
-- Today's vitals
(
    'PASTE_RESIDENT_ID_HERE',  -- ⚠️ REPLACE THIS!
    '120/80',
    72,
    98.6,
    98,
    NOW()
),
-- Yesterday's vitals
(
    'PASTE_RESIDENT_ID_HERE',  -- ⚠️ REPLACE THIS!
    '118/78',
    70,
    98.4,
    97,
    NOW() - INTERVAL '1 day'
),
-- 2 days ago
(
    'PASTE_RESIDENT_ID_HERE',  -- ⚠️ REPLACE THIS!
    '122/82',
    74,
    98.7,
    99,
    NOW() - INTERVAL '2 days'
);

-- ==========================================
-- TEST 4: VERIFY VITALS INSERTED
-- ==========================================

SELECT 
    r.name as resident_name,
    v.blood_pressure,
    v.heart_rate,
    v.temperature,
    v.oxygen_level,
    v.recorded_at
FROM health_vitals v
JOIN residents r ON v.resident_id = r.id
WHERE r.name = 'Margaret Smith'
ORDER BY v.recorded_at DESC;

-- ==========================================
-- TEST 5: INSERT DAILY ACTIVITIES
-- ==========================================
-- ⚠️ REPLACE 'PASTE_RESIDENT_ID_HERE' with the actual ID from TEST 1
-- Note: Change 'Monday' to today's day of week for testing!
-- Options: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday

INSERT INTO daily_activities (
    resident_id,
    activity_type,
    activity_name,
    scheduled_time,
    day_of_week,
    status,
    notes
) VALUES 
-- Morning Medication
(
    'PASTE_RESIDENT_ID_HERE',  -- ⚠️ REPLACE THIS!
    'Meds',
    'Morning Medication',
    '09:00 AM',
    'Tuesday',  -- ⚠️ Change to today's day!
    'completed',
    'Lisinopril 10mg administered'
),
-- Physical Therapy
(
    'PASTE_RESIDENT_ID_HERE',  -- ⚠️ REPLACE THIS!
    'Therapy',
    'Physical Therapy',
    '10:30 AM',
    'Tuesday',  -- ⚠️ Change to today's day!
    'pending',
    '20-minute walking session'
),
-- Lunch
(
    'PASTE_RESIDENT_ID_HERE',  -- ⚠️ REPLACE THIS!
    'Meals',
    'Lunch',
    '12:00 PM',
    'Tuesday',  -- ⚠️ Change to today's day!
    'pending',
    NULL
),
-- Afternoon Medication
(
    'PASTE_RESIDENT_ID_HERE',  -- ⚠️ REPLACE THIS!
    'Meds',
    'Afternoon Medication',
    '03:00 PM',
    'Tuesday',  -- ⚠️ Change to today's day!
    'pending',
    'Blood pressure medication'
),
-- Social Hour
(
    'PASTE_RESIDENT_ID_HERE',  -- ⚠️ REPLACE THIS!
    'Social',
    'Social Hour',
    '04:00 PM',
    'Tuesday',  -- ⚠️ Change to today's day!
    'pending',
    'Community gathering'
);

-- ==========================================
-- TEST 6: VERIFY ACTIVITIES INSERTED
-- ==========================================

SELECT 
    r.name as resident_name,
    a.activity_type,
    a.activity_name,
    a.scheduled_time,
    a.day_of_week,
    a.status,
    a.notes
FROM daily_activities a
JOIN residents r ON a.resident_id = r.id
WHERE r.name = 'Margaret Smith'
ORDER BY 
    CASE a.day_of_week
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END,
    a.scheduled_time;

-- ==========================================
-- TEST 7: INSERT TEST VISIT
-- ==========================================
-- ⚠️ REPLACE 'PASTE_RESIDENT_ID_HERE' with the actual ID from TEST 1
-- This creates a visit scheduled 2 days from now at 2:00 PM

INSERT INTO visits (
    resident_id,
    visitor_name,
    visitor_contact,
    scheduled_at,
    purpose,
    status
) VALUES (
    'PASTE_RESIDENT_ID_HERE',  -- ⚠️ REPLACE THIS!
    'Robert Smith',
    '+230 5987-6543',
    NOW() + INTERVAL '2 days' + INTERVAL '14 hours',  -- 2 days from now at 2 PM
    'Family Visit',
    'pending'
);

-- ==========================================
-- TEST 8: VERIFY VISIT INSERTED
-- ==========================================

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
WHERE r.name = 'Margaret Smith'
ORDER BY v.scheduled_at;

-- ==========================================
-- TEST 9: VIEW ALL DATA SUMMARY
-- ==========================================

SELECT 
    'Total Residents' as metric,
    COUNT(*)::text as value
FROM residents WHERE status = 'active'

UNION ALL

SELECT 
    'Total Vitals Records' as metric,
    COUNT(*)::text as value
FROM health_vitals

UNION ALL

SELECT 
    'Total Activities' as metric,
    COUNT(*)::text as value
FROM daily_activities

UNION ALL

SELECT 
    'Pending Visits' as metric,
    COUNT(*)::text as value
FROM visits WHERE status = 'pending';

-- ==========================================
-- TROUBLESHOOTING QUERIES
-- ==========================================

-- If you need to find Margaret's ID again:
SELECT id, name, room_number FROM residents WHERE name = 'Margaret Smith';

-- If you need to delete all test data and start over:
/*
DELETE FROM visits WHERE resident_id IN (SELECT id FROM residents WHERE name = 'Margaret Smith');
DELETE FROM daily_activities WHERE resident_id IN (SELECT id FROM residents WHERE name = 'Margaret Smith');
DELETE FROM health_vitals WHERE resident_id IN (SELECT id FROM residents WHERE name = 'Margaret Smith');
DELETE FROM residents WHERE name = 'Margaret Smith';
*/

-- Check if your admin user exists:
SELECT 
    id,
    email,
    raw_user_meta_data ->> 'role' as role,
    raw_user_meta_data ->> 'full_name' as full_name
FROM auth.users 
WHERE email = 'lindiwe.motaung@umail.utm.ac.mu';
