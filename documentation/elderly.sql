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

CREATE TABLE IF NOT EXISTS daily_activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  resident_id UUID REFERENCES residents(id) ON DELETE CASCADE,
  activity_type VARCHAR(50),
  description TEXT,
  day_of_week VARCHAR(20),
  scheduled_time TIME,
  created_at TIMESTAMP DEFAULT NOW()
);

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

CREATE INDEX IF NOT EXISTS idx_residents_email ON residents(email);
CREATE INDEX IF NOT EXISTS idx_health_vitals_resident ON health_vitals(resident_id);
CREATE INDEX IF NOT EXISTS idx_activities_resident ON daily_activities(resident_id);
CREATE INDEX IF NOT EXISTS idx_visits_resident ON visits(resident_id);
CREATE INDEX IF NOT EXISTS idx_visits_status ON visits(status);

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

INSERT INTO daily_activities (resident_id, activity_type, description, day_of_week, scheduled_time)
SELECT id, 'Exercise', 'Morning Walk', 'Monday', '08:00:00'
FROM residents WHERE email = 'margaret.smith@test.com';

INSERT INTO daily_activities (resident_id, activity_type, description, day_of_week, scheduled_time)
SELECT id, 'Meal', 'Breakfast', 'Monday', '09:00:00'
FROM residents WHERE email = 'margaret.smith@test.com';

INSERT INTO daily_activities (resident_id, activity_type, description, day_of_week, scheduled_time)
SELECT id, 'Social', 'Group Discussion', 'Monday', '14:00:00'
FROM residents WHERE email = 'margaret.smith@test.com';

INSERT INTO daily_activities (resident_id, activity_type, description, day_of_week, scheduled_time)
SELECT id, 'Therapy', 'Physical Therapy', 'Tuesday', '10:00:00'
FROM residents WHERE email = 'margaret.smith@test.com';

INSERT INTO daily_activities (resident_id, activity_type, description, day_of_week, scheduled_time)
SELECT id, 'Meal', 'Lunch', 'Tuesday', '12:30:00'
FROM residents WHERE email = 'margaret.smith@test.com';

INSERT INTO daily_activities (resident_id, activity_type, description, day_of_week, scheduled_time)
SELECT id, 'Recreation', 'Arts and Crafts', 'Wednesday', '14:00:00'
FROM residents WHERE email = 'margaret.smith@test.com';

INSERT INTO daily_activities (resident_id, activity_type, description, day_of_week, scheduled_time)
SELECT id, 'Exercise', 'Yoga Class', 'Thursday', '09:00:00'
FROM residents WHERE email = 'margaret.smith@test.com';

INSERT INTO daily_activities (resident_id, activity_type, description, day_of_week, scheduled_time)
SELECT id, 'Social', 'Tea Time', 'Friday', '15:00:00'
FROM residents WHERE email = 'margaret.smith@test.com';

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
  'Sarah Johnson',
  '+230 5234 5678',
  'Daughter',
  NOW() + INTERVAL '5 days',
  'Birthday celebration',
  'pending'
FROM residents WHERE email = 'margaret.smith@test.com';

ALTER TABLE residents DISABLE ROW LEVEL SECURITY;
ALTER TABLE health_vitals DISABLE ROW LEVEL SECURITY;
ALTER TABLE daily_activities DISABLE ROW LEVEL SECURITY;
ALTER TABLE visits DISABLE ROW LEVEL SECURITY;
