-- إزالة قيد المفتاح الأجنبي المؤقت لـ schedule_id
-- Remove foreign key constraint for schedule_id temporarily
-- This allows bookings to be created without requiring a real schedule

-- First, drop the existing foreign key constraint if it exists
ALTER TABLE bookings 
DROP CONSTRAINT IF EXISTS bookings_schedule_id_fkey;

-- Make schedule_id nullable and remove the foreign key requirement
-- In the future, when you have a real schedules table, you can add it back
ALTER TABLE bookings 
ALTER COLUMN schedule_id DROP NOT NULL;

-- Add a comment explaining this is temporary
COMMENT ON COLUMN bookings.schedule_id IS 'معرف الجدول الزمني (مؤقت - بدون قيد مفتاح أجنبي)';
