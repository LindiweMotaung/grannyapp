ALTER TABLE daily_activities ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admin full access activities" ON daily_activities;

CREATE POLICY "Allow all authenticated users activities" ON daily_activities
    FOR ALL
    TO authenticated
    USING (true)
    WITH CHECK (true);
