-- تشخيص وإصلاح مشاكل جدول المستخدمين
-- Diagnose and Fix Users Table Issues

-- الخطوة 1: شوف كل المستخدمين الموجودين
-- Step 1: View all existing users
SELECT id, email, full_name, phone, created_at 
FROM users 
ORDER BY created_at DESC;

-- الخطوة 2: تحقق من وجود مستخدمين مكررين بنفس البريد الإلكتروني
-- Step 2: Check for duplicate users with same email
SELECT email, COUNT(*) as count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- الخطوة 3: تحقق من وجود مستخدمين بدون بيانات أساسية
-- Step 3: Check for users with missing essential data
SELECT id, email, full_name, phone
FROM users
WHERE full_name IS NULL OR phone IS NULL OR email IS NULL;

-- الخطوة 4: احذف كل المستخدمين (إذا كنت متأكد!)
-- Step 4: Delete all users (if you're sure!)
-- UNCOMMENT ONLY IF YOU WANT TO START FRESH:
/*
TRUNCATE TABLE users CASCADE;
*/

-- الخطوة 5: أو احذف مستخدم معين بالبريد الإلكتروني
-- Step 5: Or delete a specific user by email
-- UNCOMMENT AND REPLACE EMAIL:
/*
DELETE FROM users WHERE email = 'abdullahelawady68@gmail.com';
*/
