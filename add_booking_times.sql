-- تحديث جدول الحجوزات لإضافة أوقات الذهاب والعودة
-- Add departure and return times to bookings table

ALTER TABLE bookings 
ADD COLUMN IF NOT EXISTS departure_time TIME,
ADD COLUMN IF NOT EXISTS return_time TIME;

-- إضافة تعليق للتوضيح
COMMENT ON COLUMN bookings.departure_time IS 'وقت الذهاب (اختياري - فقط لرحلات الذهاب أو الذهاب والعودة)';
COMMENT ON COLUMN bookings.return_time IS 'وقت العودة (اختياري - فقط لرحلات العودة أو الذهاب والعودة)';
