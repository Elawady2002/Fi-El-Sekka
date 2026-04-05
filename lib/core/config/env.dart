/// Environment configuration for sensitive credentials.
/// Values are injected at compile-time via --dart-define-from-file=.env
/// Never bundle .env as a Flutter asset.
class Env {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Validate that all required environment variables are set
  static bool get isValid =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Get a helpful error message if configuration is invalid
  static String get validationError {
    if (supabaseUrl.isEmpty) {
      return 'SUPABASE_URL is not configured. Build with --dart-define-from-file=.env';
    }
    if (supabaseAnonKey.isEmpty) {
      return 'SUPABASE_ANON_KEY is not configured. Build with --dart-define-from-file=.env';
    }
    return '';
  }
}
