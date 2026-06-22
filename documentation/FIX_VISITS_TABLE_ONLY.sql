ALTER TABLE visits 
ADD COLUMN IF NOT EXISTS visitor_contact TEXT,
ADD COLUMN IF NOT EXISTS scheduled_at TIMESTAMP WITH TIME ZONE,
ADD COLUMN IF NOT EXISTS check_in_time TIMESTAMP WITH TIME ZONE,
ADD COLUMN IF NOT EXISTS check_out_time TIMESTAMP WITH TIME ZONE;

UPDATE visits 
SET 
    visitor_contact = visitor_phone,
    scheduled_at = (visit_date || ' ' || visit_time)::timestamp
WHERE visitor_contact IS NULL AND visitor_phone IS NOT NULL;

ALTER TABLE visits 
ALTER COLUMN visitor_contact SET NOT NULL;

ALTER TABLE visits 
ALTER COLUMN scheduled_at SET NOT NULL;

ALTER TABLE visits 
DROP COLUMN IF EXISTS resident_name,
DROP COLUMN IF EXISTS visitor_phone,
DROP COLUMN IF EXISTS visit_date,
DROP COLUMN IF EXISTS visit_time;

CREATE INDEX IF NOT EXISTS idx_visits_scheduled_at ON visits(scheduled_at);

SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'visits'
ORDER BY ordinal_position;
