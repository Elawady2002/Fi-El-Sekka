-- Check if user exists in both auth and users table
-- Run this in Supabase SQL Editor

-- 1. Check Supabase Auth users
SELECT id, email, created_at
FROM auth.users
ORDER BY created_at DESC;

-- 2. Check public.users table
SELECT id, email, full_name, created_at
FROM public.users
ORDER BY created_at DESC;

-- 3. Check if there's a mismatch (user in auth but not in public.users)
SELECT au.id, au.email, au.created_at as auth_created_at
FROM auth.users au
LEFT JOIN public.users pu ON au.id = pu.id
WHERE pu.id IS NULL;
