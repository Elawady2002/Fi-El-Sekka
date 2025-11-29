# Supabase Database Setup Guide
# دليل إعداد قاعدة بيانات Supabase

هذا الملف يحتوي على كل الـ SQL commands المطلوبة لإعداد قاعدة البيانات في Supabase.

## خطوات الإعداد

### 1. إنشاء مشروع Supabase

1. اذهب إلى [database.new](https://database.new)
2. سجل دخول أو أنشئ حساب جديد
3. اضغط "New Project"
4. اختر اسم المشروع: `fi-el-sekka`
5. اختر كلمة سر قوية للقاعدة (احفظها!)
6. اختر المنطقة الأقرب (مثلاً: Europe West)
7. انتظر دقيقتين حتى يتم إنشاء المشروع

### 2. الحصول على API Credentials

1. بعد إنشاء المشروع، اذهب إلى `Project Settings` → `API`
2. انسخ الـ `Project URL`
3. انسخ الـ `anon` public key
4. ضع القيم دي في ملف `.env` في المشروع:

```
SUPABASE_URL=your_project_url_here
SUPABASE_ANON_KEY=your_anon_key_here
```

### 3. إنشاء الجداول

اذهب إلى `SQL Editor` في Supabase Dashboard وشغل الـ SQL التالي:

---

## SQL Scripts

### Enable UUID Extension

```sql
-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

---

### Create Tables

#### 1. Users Table

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  phone TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  student_id TEXT,
  university_id UUID,
  user_type TEXT NOT NULL CHECK (user_type IN ('student', 'driver', 'admin')) DEFAULT 'student',
  avatar_url TEXT,
  is_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add index for faster queries
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_university ON users(university_id);
```

#### 2. Cities Table

```sql
CREATE TABLE cities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name_ar TEXT NOT NULL,
  name_en TEXT NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_cities_active ON cities(is_active);
```

#### 3. Universities Table

```sql
CREATE TABLE universities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  city_id UUID REFERENCES cities(id) ON DELETE CASCADE,
  name_ar TEXT NOT NULL,
  name_en TEXT NOT NULL,
  location JSONB NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_universities_city ON universities(city_id);
CREATE INDEX idx_universities_active ON universities(is_active);
```

#### 4. Stations Table

```sql
CREATE TABLE stations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  university_id UUID REFERENCES universities(id) ON DELETE CASCADE,
  name_ar TEXT NOT NULL,
  name_en TEXT NOT NULL,
  location JSONB NOT NULL,
  station_type TEXT CHECK (station_type IN ('pickup', 'dropoff', 'both')) DEFAULT 'both',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_stations_university ON stations(university_id);
CREATE INDEX idx_stations_active ON stations(is_active);
```

#### 5. Routes Table

```sql
CREATE TABLE routes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  university_id UUID REFERENCES universities(id) ON DELETE CASCADE,
  route_name_ar TEXT NOT NULL,
  route_name_en TEXT NOT NULL,
  route_code TEXT UNIQUE NOT NULL,
  stations_order JSONB NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_routes_university ON routes(university_id);
CREATE INDEX idx_routes_code ON routes(route_code);
```

#### 6. Schedules Table

```sql
CREATE TABLE schedules (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  route_id UUID REFERENCES routes(id) ON DELETE CASCADE,
  direction TEXT NOT NULL CHECK (direction IN ('to_university', 'from_university')),
  departure_time TIME NOT NULL,
  available_days JSONB NOT NULL,
  capacity INTEGER NOT NULL DEFAULT 30,
  price_per_trip DECIMAL(10,2) NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_schedules_route ON schedules(route_id);
CREATE INDEX idx_schedules_active ON schedules(is_active);
```

#### 7. Bookings Table

```sql
CREATE TABLE bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  schedule_id UUID REFERENCES schedules(id) ON DELETE CASCADE,
  booking_date DATE NOT NULL,
  trip_type TEXT NOT NULL CHECK (trip_type IN ('departure_only', 'return_only', 'round_trip')),
  pickup_station_id UUID REFERENCES stations(id),
  dropoff_station_id UUID REFERENCES stations(id),
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),
  payment_status TEXT NOT NULL DEFAULT 'unpaid' CHECK (payment_status IN ('unpaid', 'paid', 'refunded')),
  total_price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_bookings_user ON bookings(user_id);
CREATE INDEX idx_bookings_schedule ON bookings(schedule_id);
CREATE INDEX idx_bookings_date ON bookings(booking_date);
CREATE INDEX idx_bookings_status ON bookings(status);
```

#### 8. Subscriptions Table

```sql
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  plan_type TEXT NOT NULL CHECK (plan_type IN ('daily', 'weekly', 'monthly', 'semester')),
  route_id UUID REFERENCES routes(id),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  payment_status TEXT NOT NULL DEFAULT 'unpaid' CHECK (payment_status IN ('unpaid', 'paid', 'refunded')),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_subscriptions_user ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_active ON subscriptions(is_active);
```

#### 9. Payments Table

```sql
CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  booking_id UUID REFERENCES bookings(id),
  subscription_id UUID REFERENCES subscriptions(id),
  amount DECIMAL(10,2) NOT NULL,
  payment_method TEXT NOT NULL CHECK (payment_method IN ('cash', 'instapay', 'vodafone_cash', 'wallet')),
  payment_status TEXT NOT NULL DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded')),
  transaction_id TEXT UNIQUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_payments_user ON payments(user_id);
CREATE INDEX idx_payments_booking ON payments(booking_id);
CREATE INDEX idx_payments_subscription ON payments(subscription_id);
```

---

### Add Foreign Key Constraints for Users

```sql
-- Add foreign key for university_id in users table
-- (we need to create it after universities table exists)
ALTER TABLE users
ADD CONSTRAINT fk_users_university
FOREIGN KEY (university_id)
REFERENCES universities(id)
ON DELETE SET NULL;
```

---

### Enable Row Level Security (RLS)

```sql
-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE cities ENABLE ROW LEVEL SECURITY;
ALTER TABLE universities ENABLE ROW LEVEL SECURITY;
ALTER TABLE stations ENABLE ROW LEVEL SECURITY;
ALTER TABLE routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
```

---

### Create RLS Policies

#### Users Policies

```sql
-- Users can read their own data
CREATE POLICY "Users can view own profile"
  ON users FOR SELECT
  USING (auth.uid() = id);

-- Users can update their own data
CREATE POLICY "Users can update own profile"
  ON users FOR UPDATE
  USING (auth.uid() = id);

-- Allow signup (insert)
CREATE POLICY "Enable insert for authentication"
  ON users FOR INSERT
  WITH CHECK (true);
```

#### Cities Policies (Public read)

```sql
CREATE POLICY "Cities are viewable by everyone"
  ON cities FOR SELECT
  USING (is_active = true);
```

#### Universities Policies (Public read)

```sql
CREATE POLICY "Universities are viewable by everyone"
  ON universities FOR SELECT
  USING (is_active = true);
```

#### Stations Policies (Public read)

```sql
CREATE POLICY "Stations are viewable by everyone"
  ON stations FOR SELECT
  USING (is_active = true);
```

#### Routes Policies (Public read)

```sql
CREATE POLICY "Routes are viewable by everyone"
  ON routes FOR SELECT
  USING (is_active = true);
```

#### Schedules Policies (Public read)

```sql
CREATE POLICY "Schedules are viewable by everyone"
  ON schedules FOR SELECT
  USING (is_active = true);
```

#### Bookings Policies

```sql
-- Users can view their own bookings
CREATE POLICY "Users can view own bookings"
  ON bookings FOR SELECT
  USING (auth.uid() = user_id);

-- Users can create bookings
CREATE POLICY "Users can create bookings"
  ON bookings FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own bookings (cancel only)
CREATE POLICY "Users can update own bookings"
  ON bookings FOR UPDATE
  USING (auth.uid() = user_id);
```

#### Subscriptions Policies

```sql
-- Users can view their own subscriptions
CREATE POLICY "Users can view own subscriptions"
  ON subscriptions FOR SELECT
  USING (auth.uid() = user_id);

-- Users can create subscriptions
CREATE POLICY "Users can create subscriptions"
  ON subscriptions FOR INSERT
  WITH CHECK (auth.uid() = user_id);
```

#### Payments Policies

```sql
-- Users can view their own payments
CREATE POLICY "Users can view own payments"
  ON payments FOR SELECT
  USING (auth.uid() = user_id);

-- Users can create payments
CREATE POLICY "Users can create payments"
  ON payments FOR INSERT
  WITH CHECK (auth.uid() = user_id);
```

---

## Sample Data (للتجربة)

### إضافة مدينة ونموذج بيانات

```sql
-- Add Cairo
INSERT INTO cities (name_ar, name_en, is_active)
VALUES ('القاهرة', 'Cairo', true);

-- Get Cairo ID (you'll need this for next queries)
-- SELECT id FROM cities WHERE name_en = 'Cairo';

-- Add Ain Shams University (replace <cairo_id> with actual ID)
INSERT INTO universities (
  city_id, 
  name_ar, 
  name_en, 
  location, 
  is_active
)
VALUES (
  '<cairo_id>',
  'جامعة عين شمس',
  'Ain Shams University',
  '{"lat": 30.0830, "lng": 31.2826, "address": "El-Khalifa El-Mamoun, Abbaseya, Cairo"}'::jsonb,
  true
);

-- Get University ID
-- SELECT id FROM universities WHERE name_en = 'Ain Shams University';

-- Add stations (replace <university_id> with actual ID)
INSERT INTO stations (university_id, name_ar, name_en, location, station_type, is_active)
VALUES
  (
    '<university_id>',
    'محطة النزهة',
    'El Nozha Station',
    '{"lat": 30.0900, "lng": 31.3200, "address": "El Nozha St."}'::jsonb,
    'both',
    true
  ),
  (
    '<university_id>',
    'محطة مدينة نصر',
    'Nasr City Station',
    '{"lat": 30.0500, "lng": 31.3500, "address": "Nasr City"}'::jsonb,
    'both',
    true
  ),
  (
    '<university_id>',
    'محطة مصر الجديدة',
    'Heliopolis Station',
    '{"lat": 30.0900, "lng": 31.3100, "address": "Heliopolis"}'::jsonb,
    'both',
    true
  ),
  (
    '<university_id>',
    'بوابة الجامعة الرئيسية',
    'University Main Gate',
    '{"lat": 30.0830, "lng": 31.2826, "address": "Ain Shams University Main Gate"}'::jsonb,
    'dropoff',
    true
  );
```

---

## التأكد من نجاح الإعداد

يمكنك التحقق بتشغيل الاستعلامات التالية في SQL Editor:

```sql
-- Check all tables exist
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

-- Check sample data
SELECT * FROM cities;
SELECT * FROM universities;
SELECT * FROM stations;

-- Check RLS is enabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';
```

---

## الخطوات التالية

1. ✅ شغل كل الـ SQL scripts أعلاه
2. ✅ تأكد من وجود البيانات التجريبية
3. ✅ ضع الـ credentials في `.env`
4. ✅ شغل التطبيق وجرب التسجيل!

🎉 بالتوفيق!
