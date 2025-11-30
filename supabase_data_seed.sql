-- Seed data for Cities and Stations (Updated Schema)
-- Run this script in the Supabase SQL Editor

DO $$
DECLARE
  -- City IDs
  madinaty_id uuid;
  shorouk_id uuid;
  badr_id uuid;
  new_cairo_id uuid;

  -- University IDs
  madinaty_bue_id uuid;
  madinaty_buc_id uuid;
  madinaty_guc_id uuid;
  madinaty_auc_id uuid;
  madinaty_shorouk_acad_id uuid;

  shorouk_bue_id uuid;
  shorouk_shorouk_acad_id uuid;

  badr_buc_id uuid;
  badr_russian_uni_id uuid;

BEGIN
  -- ==========================================
  -- 0. Clear Existing Data (To prevent duplicates)
  -- ==========================================
  TRUNCATE TABLE cities, universities, stations, routes, schedules RESTART IDENTITY CASCADE;


  -- ==========================================
  -- 1. Insert Cities
  -- ==========================================
  
  -- Madinaty
  INSERT INTO cities (name_ar, name_en, is_active)
  VALUES ('مدينتي', 'Madinaty', true)
  RETURNING id INTO madinaty_id;

  -- El Shorouk
  INSERT INTO cities (name_ar, name_en, is_active)
  VALUES ('الشروق', 'El Shorouk', true)
  RETURNING id INTO shorouk_id;

  -- Badr City
  INSERT INTO cities (name_ar, name_en, is_active)
  VALUES ('مدينة بدر', 'Badr City', true)
  RETURNING id INTO badr_id;

  -- New Cairo
  INSERT INTO cities (name_ar, name_en, is_active)
  VALUES ('القاهرة الجديدة', 'New Cairo', true)
  RETURNING id INTO new_cairo_id;


  -- ==========================================
  -- 2. Insert Universities (Mapped to Cities they SERVE)
  -- ==========================================

  -- Universities available from MADINATY
  INSERT INTO universities (city_id, name_ar, name_en, location, is_active) VALUES
  (madinaty_id, 'الجامعة البريطانية (BUE)', 'British University', '{"lat": 30.119, "lng": 31.606, "address": "El Shorouk City"}', true) RETURNING id INTO madinaty_bue_id;

  INSERT INTO universities (city_id, name_ar, name_en, location, is_active) VALUES
  (madinaty_id, 'جامعة بدر (BUC)', 'Badr University', '{"lat": 30.166, "lng": 31.755, "address": "Badr City"}', true) RETURNING id INTO madinaty_buc_id;

  INSERT INTO universities (city_id, name_ar, name_en, location, is_active) VALUES
  (madinaty_id, 'الجامعة الألمانية (GUC)', 'German University', '{"lat": 29.986, "lng": 31.441, "address": "New Cairo"}', true) RETURNING id INTO madinaty_guc_id;

  INSERT INTO universities (city_id, name_ar, name_en, location, is_active) VALUES
  (madinaty_id, 'الجامعة الأمريكية (AUC)', 'American University', '{"lat": 30.020, "lng": 31.496, "address": "New Cairo"}', true) RETURNING id INTO madinaty_auc_id;

  INSERT INTO universities (city_id, name_ar, name_en, location, is_active) VALUES
  (madinaty_id, 'أكاديمية الشروق', 'Shorouk Academy', '{"lat": 30.135, "lng": 31.625, "address": "El Shorouk City"}', true) RETURNING id INTO madinaty_shorouk_acad_id;


  -- Universities available from SHOROUK
  INSERT INTO universities (city_id, name_ar, name_en, location, is_active) VALUES
  (shorouk_id, 'الجامعة البريطانية (BUE)', 'British University', '{"lat": 30.119, "lng": 31.606, "address": "El Shorouk City"}', true) RETURNING id INTO shorouk_bue_id;

  INSERT INTO universities (city_id, name_ar, name_en, location, is_active) VALUES
  (shorouk_id, 'أكاديمية الشروق', 'Shorouk Academy', '{"lat": 30.135, "lng": 31.625, "address": "El Shorouk City"}', true) RETURNING id INTO shorouk_shorouk_acad_id;


  -- Universities available from BADR
  INSERT INTO universities (city_id, name_ar, name_en, location, is_active) VALUES
  (badr_id, 'جامعة بدر (BUC)', 'Badr University', '{"lat": 30.166, "lng": 31.755, "address": "Badr City"}', true) RETURNING id INTO badr_buc_id;

  INSERT INTO universities (city_id, name_ar, name_en, location, is_active) VALUES
  (badr_id, 'الجامعة الروسية (ERU)', 'Russian University', '{"lat": 30.155, "lng": 31.740, "address": "Badr City"}', true) RETURNING id INTO badr_russian_uni_id;


  -- Universities available from NEW CAIRO
  INSERT INTO universities (city_id, name_ar, name_en, location, is_active) VALUES
  (new_cairo_id, 'الجامعة الألمانية (GUC)', 'German University', '{"lat": 29.986, "lng": 31.441, "address": "New Cairo"}', true);

  INSERT INTO universities (city_id, name_ar, name_en, location, is_active) VALUES
  (new_cairo_id, 'الجامعة الأمريكية (AUC)', 'American University', '{"lat": 30.020, "lng": 31.496, "address": "New Cairo"}', true);

  INSERT INTO universities (city_id, name_ar, name_en, location, is_active) VALUES
  (new_cairo_id, 'الجامعة الكندية', 'Canadian International College', '{"lat": 30.030, "lng": 31.480, "address": "New Cairo"}', true);


  -- ==========================================
  -- 3. Insert Stations (NOW LINKED TO CITIES, NOT UNIVERSITIES!)
  -- ==========================================

  -- MADINATY STATIONS (B1, B2, etc.)
  -- These stations are shared by ALL universities served from Madinaty
  INSERT INTO stations (city_id, name_ar, name_en, location, station_type, is_active) VALUES
  (madinaty_id, 'B1', 'B1', '{"lat": 30.090, "lng": 31.630, "address": "Madinaty B1"}', 'pickup', true),
  (madinaty_id, 'B2', 'B2', '{"lat": 30.092, "lng": 31.635, "address": "Madinaty B2"}', 'pickup', true),
  (madinaty_id, 'B3', 'B3', '{"lat": 30.095, "lng": 31.640, "address": "Madinaty B3"}', 'pickup', true),
  (madinaty_id, 'B5', 'B5', '{"lat": 30.100, "lng": 31.645, "address": "Madinaty B5"}', 'pickup', true),
  (madinaty_id, 'B7', 'B7', '{"lat": 30.105, "lng": 31.650, "address": "Madinaty B7"}', 'pickup', true),
  (madinaty_id, 'B8', 'B8', '{"lat": 30.110, "lng": 31.655, "address": "Madinaty B8"}', 'pickup', true),
  (madinaty_id, 'B10', 'B10', '{"lat": 30.115, "lng": 31.660, "address": "Madinaty B10"}', 'pickup', true),
  (madinaty_id, 'B11', 'B11', '{"lat": 30.120, "lng": 31.665, "address": "Madinaty B11"}', 'pickup', true),
  (madinaty_id, 'B12', 'B12', '{"lat": 30.125, "lng": 31.670, "address": "Madinaty B12"}', 'pickup', true),
  (madinaty_id, 'B15', 'B15', '{"lat": 30.130, "lng": 31.675, "address": "Madinaty B15"}', 'pickup', true);


  -- SHOROUK STATIONS
  -- These stations are shared by ALL universities served from Shorouk
  INSERT INTO stations (city_id, name_ar, name_en, location, station_type, is_active) VALUES
  (shorouk_id, 'بوابة 1', '1st Gate', '{"lat": 30.130, "lng": 31.610, "address": "Shorouk 1st Gate"}', 'pickup', true),
  (shorouk_id, 'بوابة 2', '2nd Gate', '{"lat": 30.132, "lng": 31.612, "address": "Shorouk 2nd Gate"}', 'pickup', true),
  (shorouk_id, 'نادي الشروق', 'Shorouk Club', '{"lat": 30.140, "lng": 31.620, "address": "Shorouk Club"}', 'pickup', true),
  (shorouk_id, 'بانوراما مول', 'Panorama Mall', '{"lat": 30.138, "lng": 31.615, "address": "Panorama Mall"}', 'pickup', true);


  -- BADR STATIONS
  -- These stations are shared by ALL universities served from Badr
  INSERT INTO stations (city_id, name_ar, name_en, location, station_type, is_active) VALUES
  (badr_id, 'بوابة الجامعة', 'University Gate', '{"lat": 30.166, "lng": 31.755, "address": "BUC Gate"}', 'pickup', true),
  (badr_id, 'موقف الأتوبيس', 'Bus Station', '{"lat": 30.160, "lng": 31.750, "address": "Badr Bus Station"}', 'pickup', true),
  (badr_id, 'الميدان', 'El Square', '{"lat": 30.150, "lng": 31.745, "address": "Badr Square"}', 'pickup', true);


  -- NEW CAIRO STATIONS
  -- These stations are shared by ALL universities served from New Cairo
  INSERT INTO stations (city_id, name_ar, name_en, location, station_type, is_active) VALUES
  (new_cairo_id, 'كايرو فيستيفال', 'Cairo Festival City', '{"lat": 30.030, "lng": 31.410, "address": "Cairo Festival City Mall"}', 'pickup', true),
  (new_cairo_id, 'بوينت 90', 'Point 90', '{"lat": 30.025, "lng": 31.480, "address": "Point 90 Mall"}', 'pickup', true),
  (new_cairo_id, 'داون تاون', 'Downtown Mall', '{"lat": 30.070, "lng": 31.430, "address": "Downtown Katameya"}', 'pickup', true),
  (new_cairo_id, 'كونكورد بلازا', 'Concord Plaza', '{"lat": 30.050, "lng": 31.420, "address": "Concord Plaza"}', 'pickup', true),
  (new_cairo_id, 'الرحاب كلوب', 'Rehab Club', '{"lat": 30.060, "lng": 31.500, "address": "Rehab City Club"}', 'pickup', true);

END $$;
