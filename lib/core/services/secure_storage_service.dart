import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SecureStorageService extends LocalStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _key = 'supabase_persist_session';

  @override
  Future<void> initialize() async {
    // No initialization needed for FlutterSecureStorage
  }

  @override
  Future<bool> hasAccessToken() async {
    return await _storage.containsKey(key: _key);
  }

  @override
  Future<String?> accessToken() async {
    return await _storage.read(key: _key);
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    await _storage.write(key: _key, value: persistSessionString);
  }

  @override
  Future<void> removePersistedSession() async {
    await _storage.delete(key: _key);
  }
}
