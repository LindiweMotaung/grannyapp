SELECT COUNT(*) as total_residents FROM residents;

SELECT id, name, age, room_number FROM residents ORDER BY created_at DESC;

SELECT id, email, raw_user_meta_data ->> 'role' as role FROM auth.users WHERE email LIKE '%sarah%';
