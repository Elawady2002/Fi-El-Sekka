-- Create schedules table for Sequential Car Filling
-- Create schedules table for Sequential Car Filling
CREATE TABLE IF NOT EXISTS schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add columns if they don't exist (Robust Migration)
ALTER TABLE schedules ADD COLUMN IF NOT EXISTS route_id UUID;
ALTER TABLE schedules ADD COLUMN IF NOT EXISTS direction TEXT CHECK (direction IN ('to_university', 'from_university'));
ALTER TABLE schedules ADD COLUMN IF NOT EXISTS departure_time TIME;
ALTER TABLE schedules ADD COLUMN IF NOT EXISTS capacity INTEGER DEFAULT 14;
ALTER TABLE schedules ADD COLUMN IF NOT EXISTS booked_count INTEGER DEFAULT 0;
ALTER TABLE schedules ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'full', 'completed', 'cancelled'));
ALTER TABLE schedules ADD COLUMN IF NOT EXISTS price NUMERIC(10, 2) DEFAULT 0.0;

-- Update existing rows to have sensible defaults if they were null
UPDATE schedules SET status = 'pending' WHERE status IS NULL;
UPDATE schedules SET booked_count = 0 WHERE booked_count IS NULL;
UPDATE schedules SET capacity = 14 WHERE capacity IS NULL;

-- Index for finding the active schedule quickly
CREATE INDEX IF NOT EXISTS idx_schedules_active ON schedules(route_id, direction) WHERE status = 'active';

-- Function to handle atomic booking (prevent overbooking)
CREATE OR REPLACE FUNCTION book_seat(
    p_user_id UUID,
    p_route_id UUID,
    p_direction TEXT,
    p_station_id UUID, -- Pickup station (optional)
    p_schedule_id UUID DEFAULT NULL -- Optional: if user wants a SPECIFIC schedule (for future use), otherwise auto-assign
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_schedule_id UUID;
    v_booking_id UUID;
    v_price NUMERIC(10, 2);
    v_capacity INTEGER;
    v_booked_count INTEGER;
BEGIN
    -- 1. Find the Active Schedule (if not provided)
    IF p_schedule_id IS NULL THEN
        SELECT id, price, capacity, booked_count
        INTO v_schedule_id, v_price, v_capacity, v_booked_count
        FROM schedules
        WHERE route_id = p_route_id 
          AND direction = p_direction
          AND status = 'active'
        ORDER BY departure_time ASC
        LIMIT 1
        FOR UPDATE; -- Lock the row to prevent race conditions
        
        -- If no active schedule found, try to find the next pending one and activate it?
        -- For now, if no active schedule, return error. Owner must activate trips.
        IF v_schedule_id IS NULL THEN
             RETURN jsonb_build_object('success', false, 'message', 'No active trips available right now. Please wait for an operator.');
        END IF;
    ELSE
        -- Use provided schedule ID
        SELECT id, price, capacity, booked_count
        INTO v_schedule_id, v_price, v_capacity, v_booked_count
        FROM schedules
        WHERE id = p_schedule_id
        FOR UPDATE;
    END IF;

    -- 2. Check Capacity
    IF v_booked_count >= v_capacity THEN
        -- Mark as full if not already
        UPDATE schedules SET status = 'full' WHERE id = v_schedule_id;
        
        -- Try to find the NEXT schedule to book on? 
        -- For simplicity in this version, simply fail and ask user to retry (which will pick up the next active one if Owner activated it)
        RETURN jsonb_build_object('success', false, 'message', 'This trip just got full! Please try again to catch the next one.');
    END IF;

    -- 3. Create Booking
    INSERT INTO bookings (
        user_id, 
        schedule_id, 
        booking_date, -- Use Today's date for sequential filling usually
        trip_type, 
        pickup_station_id, 
        total_price, 
        status
    ) VALUES (
        p_user_id,
        v_schedule_id,
        CURRENT_DATE,
        CASE WHEN p_direction = 'to_university' THEN 'departure_only' ELSE 'return_only' END,
        p_station_id,
        v_price,
        'confirmed' -- Auto confirm for now
    ) RETURNING id INTO v_booking_id;

    -- 4. Increment Booking Count
    UPDATE schedules 
    SET booked_count = booked_count + 1,
        status = CASE WHEN booked_count + 1 >= capacity THEN 'full' ELSE status END
    WHERE id = v_schedule_id;

    RETURN jsonb_build_object(
        'success', true, 
        'booking_id', v_booking_id,
        'schedule_id', v_schedule_id,
        'message', 'Booking successful!'
    );

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'message', SQLERRM);
END;
$$;
