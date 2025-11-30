-- Migration: Change Stations to be linked to Cities instead of Universities
-- Run this in Supabase SQL Editor

-- Step 1: Drop existing stations table and recreate with new schema
DROP TABLE IF EXISTS stations CASCADE;

-- Step 2: Create new stations table with city_id
CREATE TABLE stations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  city_id UUID REFERENCES cities(id) ON DELETE CASCADE,
  name_ar TEXT NOT NULL,
  name_en TEXT NOT NULL,
  location JSONB NOT NULL,
  station_type TEXT CHECK (station_type IN ('pickup', 'dropoff', 'both')) DEFAULT 'both',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 3: Create indexes
CREATE INDEX idx_stations_city ON stations(city_id);
CREATE INDEX idx_stations_active ON stations(is_active);

-- Step 4: Enable RLS
ALTER TABLE stations ENABLE ROW LEVEL SECURITY;

-- Step 5: Create RLS policy
CREATE POLICY "Stations are viewable by everyone"
  ON stations FOR SELECT
  USING (is_active = true);
