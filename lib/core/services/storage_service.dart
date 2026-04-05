import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'logger_service.dart';

/// Service for handling file uploads to Supabase Storage
class StorageService {
  final SupabaseClient _client;
  static const String _bucketName = 'payment-proofs';

  /// Maximum allowed file size: 5 MB
  static const int _maxFileSizeBytes = 5 * 1024 * 1024;

  /// Allowed image extensions
  static const Set<String> _allowedExtensions = {
    '.jpg',
    '.jpeg',
    '.png',
    '.webp',
  };

  StorageService(this._client);

  /// Upload a payment proof image and return the public URL
  ///
  /// [imageFile] - The image file to upload
  /// [userId] - The user ID (used for organizing files)
  ///
  /// Returns the public URL of the uploaded image
  /// Throws an exception if upload fails or validation fails
  Future<String> uploadPaymentProof(File imageFile, String userId) async {
    // Validate file size
    final fileSize = await imageFile.length();
    if (fileSize > _maxFileSizeBytes) {
      throw Exception(
          'حجم الصورة كبير جداً. الحد الأقصى هو ${_maxFileSizeBytes ~/ (1024 * 1024)} ميجابايت');
    }

    // Validate file extension
    final ext = path.extension(imageFile.path).toLowerCase();
    if (!_allowedExtensions.contains(ext)) {
      throw Exception(
          'نوع الملف غير مسموح به. يُرجى رفع صورة بصيغة JPG أو PNG أو WEBP فقط');
    }

    try {
      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$userId/$timestamp$ext';

      LoggerService.info('📤 Uploading payment proof: $fileName');

      // Upload file to Supabase Storage
      final uploadPath = await _client.storage
          .from(_bucketName)
          .upload(fileName, imageFile);

      LoggerService.info('✅ Upload successful: $uploadPath');

      // Get public URL
      final publicUrl = _client.storage
          .from(_bucketName)
          .getPublicUrl(fileName);

      LoggerService.info('🔗 Public URL: $publicUrl');

      return publicUrl;
    } on StorageException catch (e) {
      LoggerService.error('❌ Storage error: ${e.message}');
      throw Exception('فشل رفع الصورة: ${e.message}');
    } catch (e) {
      LoggerService.error('❌ Unexpected error uploading image: $e');
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

      LoggerService.info('🗑️ Deleting payment proof: $filePath');

      await _client.storage.from(_bucketName).remove([filePath]);

      LoggerService.info('✅ Image deleted successfully');
    } on StorageException catch (e) {
      LoggerService.error('❌ Storage error: ${e.message}');
      throw Exception('فشل حذف الصورة: ${e.message}');
    } catch (e) {
      LoggerService.error('❌ Unexpected error deleting image: $e');
      throw Exception('حدث خطأ أثناء حذف الصورة');
    }
  }
}
