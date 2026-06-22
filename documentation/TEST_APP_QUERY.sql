SELECT * 
FROM daily_activities
WHERE day_of_week = 'Tuesday'
ORDER BY scheduled_time;

SELECT da.*, r.name, r.room_number
FROM daily_activities da
LEFT JOIN residents r ON da.resident_id = r.id
WHERE da.day_of_week = 'Tuesday'
ORDER BY da.scheduled_time;
