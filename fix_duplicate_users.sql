-- Fix Duplicate Users Issue
-- Run this in Supabase SQL Editor to diagnose and fix the "Cannot coerce to single JSON object" error

-- Step 1: Check for duplicate users by email
SELECT email, COUNT(*) as count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- Step 2: Check for duplicate users by ID (shouldn't happen with UUID PRIMARY KEY, but let's verify)
SELECT id, COUNT(*) as count
FROM users
GROUP BY id
HAVING COUNT(*) > 1;

-- Step 3: View all users to see what's in the table
SELECT id, email, full_name, created_at
FROM users
ORDER BY created_at DESC;

-- Step 4: If you find duplicates, delete them (CAREFUL! Backup first)
-- Uncomment and modify this query to delete specific duplicates:
-- DELETE FROM users WHERE id = 'duplicate_user_id_here';

-- Step 5: Alternative - Keep only the most recent user per email
-- This will delete older duplicate entries, keeping only the newest one
-- UNCOMMENT ONLY IF YOU WANT TO RUN THIS:
/*
DELETE FROM users a
USING users b
WHERE a.email = b.email
  AND a.created_at < b.created_at;
*/
