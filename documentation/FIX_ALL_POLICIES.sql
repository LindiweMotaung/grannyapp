DROP POLICY IF EXISTS "Admins can do everything on residents" ON residents;
DROP POLICY IF EXISTS "Residents can view own profile" ON residents;
DROP POLICY IF EXISTS "Residents can update own profile" ON residents;
DROP POLICY IF EXISTS "Allow admins full access to vitals" ON health_vitals;
DROP POLICY IF EXISTS "Allow residents to view their own vitals" ON health_vitals;
DROP POLICY IF EXISTS "Allow admins full access to activities" ON daily_activities;
DROP POLICY IF EXISTS "Allow residents to view their activities" ON daily_activities;
DROP POLICY IF EXISTS "Allow admins full access to visits" ON visits;
DROP POLICY IF EXISTS "Allow residents to view their visits" ON visits;
DROP POLICY IF EXISTS "Allow visitors to view their own visits" ON visits;
DROP POLICY IF EXISTS "Allow visitors to create visits" ON visits;

CREATE POLICY "Admin full access residents" ON residents
    FOR ALL
    TO authenticated
    USING (
        (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin' OR
        id = auth.uid()
    )
    WITH CHECK (
        (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin' OR
        id = auth.uid()
    );

CREATE POLICY "Admin full access vitals" ON health_vitals
    FOR ALL
    TO authenticated
    USING (
        (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin' OR
        resident_id = auth.uid()
    )
    WITH CHECK (
        (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin' OR
        resident_id = auth.uid()
    );

CREATE POLICY "Admin full access activities" ON daily_activities
    FOR ALL
    TO authenticated
    USING (
        (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin' OR
        resident_id = auth.uid()
    )
    WITH CHECK (
        (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin' OR
        resident_id = auth.uid()
    );

CREATE POLICY "Admin full access visits" ON visits
    FOR ALL
    TO authenticated
    USING (
        (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin' OR
        resident_id = auth.uid() OR
        visitor_id = auth.uid()
    )
    WITH CHECK (
        (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin' OR
        resident_id = auth.uid() OR
        visitor_id = auth.uid()
    );

SELECT COUNT(*) as total_residents FROM residents;
SELECT COUNT(*) as total_vitals FROM health_vitals;
SELECT COUNT(*) as total_activities FROM daily_activities;
SELECT COUNT(*) as total_visits FROM visits;
