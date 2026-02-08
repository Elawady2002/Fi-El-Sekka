-- Add status column if it doesn't exist
ALTER TABLE subscriptions 
ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'pending';

-- Add start_date column if it doesn't exist
ALTER TABLE subscriptions 
ADD COLUMN IF NOT EXISTS start_date TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- Add end_date column if it doesn't exist
ALTER TABLE subscriptions 
ADD COLUMN IF NOT EXISTS end_date TIMESTAMP WITH TIME ZONE;

-- Add plan_type column if it doesn't exist
ALTER TABLE subscriptions 
ADD COLUMN IF NOT EXISTS plan_type TEXT;

-- Add total_price column if it doesn't exist
ALTER TABLE subscriptions 
ADD COLUMN IF NOT EXISTS total_price NUMERIC;

-- Ensure payment_proof_url and transfer_number exist (from previous step)
ALTER TABLE subscriptions 
ADD COLUMN IF NOT EXISTS payment_proof_url TEXT;

ALTER TABLE subscriptions 
ADD COLUMN IF NOT EXISTS transfer_number TEXT;

-- Refresh the schema cache (sometimes needed)
NOTIFY pgrst, 'reload config';
