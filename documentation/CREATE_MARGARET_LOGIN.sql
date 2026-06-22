INSERT INTO auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    raw_app_meta_data,
    raw_user_meta_data,
    created_at,
    updated_at,
    confirmation_token,
    email_change,
    email_change_token_new,
    recovery_token
) VALUES (
    '00000000-0000-0000-0000-000000000000',
    '4c9e6aa2-e696-4c4a-909c-aafeba09b152',
    'authenticated',
    'authenticated',
    'margaret.smith@test.com',
    crypt('Margaret123', gen_salt('bf')),
    NOW(),
    '{"provider":"email","providers":["email"]}',
    '{"full_name":"Margaret Smith","role":"resident"}',
    NOW(),
    NOW(),
    '',
    '',
    '',
    ''
);

SELECT 
    id,
    email,
    raw_user_meta_data ->> 'role' as role,
    raw_user_meta_data ->> 'full_name' as name
FROM auth.users 
WHERE email = 'margaret.smith@test.com';
