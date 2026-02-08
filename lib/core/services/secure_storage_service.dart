import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SecureStorageService extends GotrueAsyncStorage {
  // Configured with EncryptedSharedPreferences for Android
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<String?> getItem({required String key}) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> setItem({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<void> removeItem({required String key}) async {
    await _storage.delete(key: key);
  }
}
