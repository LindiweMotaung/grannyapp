SELECT 
    id,
    email,
    raw_user_meta_data ->> 'role' as role,
    raw_user_meta_data ->> 'full_name' as full_name
FROM auth.users 
WHERE email = 'lindiwe.motaung@umail.utm.ac.mu';

UPDATE auth.users
SET raw_user_meta_data = jsonb_set(
    COALESCE(raw_user_meta_data, '{}'::jsonb),
    '{role}',
    '"admin"'
)
WHERE email = 'lindiwe.motaung@umail.utm.ac.mu';

DROP POLICY IF EXISTS "Allow admins full access to residents" ON residents;
DROP POLICY IF EXISTS "Allow residents to view and update their own profile" ON residents;
DROP POLICY IF EXISTS "Allow public to read residents for registration" ON residents;

CREATE POLICY "Admins can do everything on residents" ON residents
    FOR ALL
    TO authenticated
    USING (
        (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
    )
    WITH CHECK (
        (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
    );

CREATE POLICY "Residents can view own profile" ON residents
    FOR SELECT
    TO authenticated
    USING (id = auth.uid());

CREATE POLICY "Residents can update own profile" ON residents
    FOR UPDATE
    TO authenticated
    USING (id = auth.uid())
    WITH CHECK (id = auth.uid());

SELECT 
    id,
    email,
    raw_user_meta_data ->> 'role' as role_after_fix
FROM auth.users 
WHERE email = 'lindiwe.motaung@umail.utm.ac.mu';
