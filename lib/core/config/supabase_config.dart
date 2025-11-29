import 'package:supabase_flutter/supabase_flutter.dart';
import 'env.dart';

/// Supabase configuration and initialization
class SupabaseConfig {
  static SupabaseClient? _client;

  /// Initialize Supabase client
  static Future<void> initialize() async {
    if (!Env.isValid) {
      throw Exception('Supabase configuration error: ${Env.validationError}');
    }

    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        // Auto-refresh tokens
        autoRefreshToken: true,
      ),
    );

    _client = Supabase.instance.client;
  }

  /// Get the Supabase client instance
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception(
        'Supabase client not initialized. Call SupabaseConfig.initialize() first.',
      );
    }
    return _client!;
  }

  /// Check if Supabase is initialized
  static bool get isInitialized => _client != null;
}
