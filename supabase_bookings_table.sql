-- إنشاء جدول الحجوزات (Bookings Table)
CREATE TABLE IF NOT EXISTS bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    schedule_id UUID NOT NULL,
    booking_date DATE NOT NULL,
    trip_type TEXT NOT NULL CHECK (trip_type IN ('departure_only', 'return_only', 'round_trip')),
    pickup_station_id UUID,
    dropoff_station_id UUID,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),
    payment_status TEXT NOT NULL DEFAULT 'unpaid' CHECK (payment_status IN ('unpaid', 'paid', 'refunded')),
    total_price NUMERIC(10, 2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- إنشاء فهرس لتسريع البحث بواسطة user_id
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);

-- إنشاء فهرس لتسريع البحث بواسطة booking_date
CREATE INDEX IF NOT EXISTS idx_bookings_booking_date ON bookings(booking_date);

-- إنشاء فهرس لتسريع البحث بواسطة status
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);

-- تفعيل Row Level Security (RLS)
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;

-- سياسة: المستخدم يمكنه قراءة حجوزاته فقط
CREATE POLICY "Users can view their own bookings"
ON bookings FOR SELECT
USING (auth.uid() = user_id);

-- سياسة: المستخدم يمكنه إنشاء حجوزات جديدة
CREATE POLICY "Users can create their own bookings"
ON bookings FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- سياسة: المستخدم يمكنه تحديث حجوزاته فقط
CREATE POLICY "Users can update their own bookings"
ON bookings FOR UPDATE
USING (auth.uid() = user_id);

-- دالة لتحديث updated_at تلقائياً
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger لتحديث updated_at عند التعديل
CREATE TRIGGER update_bookings_updated_at
BEFORE UPDATE ON bookings
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ✅ الجدول جاهز للاستخدام!
-- يمكنك الآن إنشاء حجوزات من التطبيق
