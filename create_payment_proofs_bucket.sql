-- إنشاء Storage Bucket لصور إثبات الدفع
-- Create Storage Bucket for Payment Proof Images

-- إنشاء الـ bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('payment-proofs', 'payment-proofs', true)
ON CONFLICT (id) DO NOTHING;

-- سياسة: السماح للمستخدمين المسجلين برفع الصور
DROP POLICY IF EXISTS "Authenticated users can upload payment proofs" ON storage.objects;
CREATE POLICY "Authenticated users can upload payment proofs"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'payment-proofs' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- سياسة: السماح للجميع بقراءة الصور (لأن الـ bucket public)
DROP POLICY IF EXISTS "Anyone can view payment proofs" ON storage.objects;
CREATE POLICY "Anyone can view payment proofs"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'payment-proofs');

-- سياسة: السماح للمستخدمين بحذف صورهم فقط
DROP POLICY IF EXISTS "Users can delete their own payment proofs" ON storage.objects;
CREATE POLICY "Users can delete their own payment proofs"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'payment-proofs' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- ✅ تم إنشاء الـ Storage Bucket بنجاح!
-- الآن يمكن رفع صور إثبات الدفع
