import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

/// Service for handling file uploads to Supabase Storage
class StorageService {
  final SupabaseClient _client;
  static const String _bucketName = 'payment-proofs';

  StorageService(this._client);

  /// Upload a payment proof image and return the public URL
  ///
  /// [imageFile] - The image file to upload
  /// [userId] - The user ID (used for organizing files)
  ///
  /// Returns the public URL of the uploaded image
  /// Throws an exception if upload fails
  Future<String> uploadPaymentProof(File imageFile, String userId) async {
    try {
      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(imageFile.path);
      final fileName = '$userId/$timestamp$extension';

      print('📤 Uploading payment proof: $fileName');

      // Upload file to Supabase Storage
      final uploadPath = await _client.storage
          .from(_bucketName)
          .upload(fileName, imageFile);

      print('✅ Upload successful: $uploadPath');

      // Get public URL
      final publicUrl = _client.storage
          .from(_bucketName)
          .getPublicUrl(fileName);

      print('🔗 Public URL: $publicUrl');

      return publicUrl;
    } on StorageException catch (e) {
      print('❌ Storage error: ${e.message}');
      throw Exception('فشل رفع الصورة: ${e.message}');
    } catch (e) {
      print('❌ Unexpected error uploading image: $e');
      throw Exception('حدث خطأ أثناء رفع الصورة');
    }
  }

  /// Delete a payment proof image from storage
  ///
  /// [imageUrl] - The public URL of the image to delete
  Future<void> deletePaymentProof(String imageUrl) async {
    try {
      // Extract file path from URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      // Find the bucket name and file path
      final bucketIndex = pathSegments.indexOf(_bucketName);
      if (bucketIndex == -1) {
        throw Exception('Invalid image URL');
      }

      final filePath = pathSegments.sublist(bucketIndex + 1).join('/');

      print('🗑️ Deleting payment proof: $filePath');

      await _client.storage.from(_bucketName).remove([filePath]);

      print('✅ Image deleted successfully');
    } on StorageException catch (e) {
      print('❌ Storage error: ${e.message}');
      throw Exception('فشل حذف الصورة: ${e.message}');
    } catch (e) {
      print('❌ Unexpected error deleting image: $e');
      throw Exception('حدث خطأ أثناء حذف الصورة');
    }
  }
}
