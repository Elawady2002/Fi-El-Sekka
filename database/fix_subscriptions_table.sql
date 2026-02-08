-- Add payment_proof_url column if it doesn't exist
ALTER TABLE subscriptions 
ADD COLUMN IF NOT EXISTS payment_proof_url TEXT;

-- Add transfer_number column if it doesn't exist (just in case)
ALTER TABLE subscriptions 
ADD COLUMN IF NOT EXISTS transfer_number TEXT;
