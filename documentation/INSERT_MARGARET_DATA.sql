INSERT INTO health_vitals (
    resident_id,
    blood_pressure,
    heart_rate,
    temperature,
    oxygen_level,
    recorded_at
) VALUES 
(
    '4c9e6aa2-e696-4c4a-909c-aafeba09b152',
    '120/80',
    72,
    98.6,
    98,
    NOW()
),
(
    '4c9e6aa2-e696-4c4a-909c-aafeba09b152',
    '118/78',
    70,
    98.4,
    97,
    NOW() - INTERVAL '1 day'
),
(
    '4c9e6aa2-e696-4c4a-909c-aafeba09b152',
    '122/82',
    74,
    98.7,
    99,
    NOW() - INTERVAL '2 days'
);

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
    '4c9e6aa2-e696-4c4a-909c-aafeba09b152',
    'Meds',
    'Morning Medication',
    '09:00 AM',
    'Tuesday',
    'completed',
    'Lisinopril 10mg administered'
),
(
    '4c9e6aa2-e696-4c4a-909c-aafeba09b152',
    'Therapy',
    'Physical Therapy',
    '10:30 AM',
    'Tuesday',
    'pending',
    '20-minute walking session'
),
(
    '4c9e6aa2-e696-4c4a-909c-aafeba09b152',
    'Meals',
    'Lunch',
    '12:00 PM',
    'Tuesday',
    'pending',
    NULL
),
(
    '4c9e6aa2-e696-4c4a-909c-aafeba09b152',
    'Meds',
    'Afternoon Medication',
    '03:00 PM',
    'Tuesday',
    'pending',
    'Blood pressure medication'
),
(
    '4c9e6aa2-e696-4c4a-909c-aafeba09b152',
    'Social',
    'Social Hour',
    '04:00 PM',
    'Tuesday',
    'pending',
    'Community gathering'
);

INSERT INTO visits (
    resident_id,
    visitor_name,
    visitor_contact,
    scheduled_at,
    purpose,
    status
) VALUES (
    '4c9e6aa2-e696-4c4a-909c-aafeba09b152',
    'Robert Smith',
    '+230 5987-6543',
    NOW() + INTERVAL '2 days' + INTERVAL '14 hours',
    'Family Visit',
    'pending'
);

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
