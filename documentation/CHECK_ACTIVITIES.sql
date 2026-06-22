SELECT 
    r.name as resident_name,
    a.activity_type,
    a.activity_name,
    a.scheduled_time,
    a.day_of_week,
    a.status
FROM daily_activities a
JOIN residents r ON a.resident_id = r.id
WHERE r.name = 'Margaret Smith'
ORDER BY a.day_of_week, a.scheduled_time;

SELECT COUNT(*) as total_activities FROM daily_activities;

SELECT * FROM daily_activities WHERE resident_id = '4c9e6aa2-e696-4c4a-909c-aafeba09b152';
