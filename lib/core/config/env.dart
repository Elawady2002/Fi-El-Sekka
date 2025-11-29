import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration for sensitive credentials
class Env {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// Validate that all required environment variables are set
  static bool get isValid =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Get a helpful error message if configuration is invalid
  static String get validationError {
    if (supabaseUrl.isEmpty) {
      return 'SUPABASE_URL is not set in .env file';
    }
    if (supabaseAnonKey.isEmpty) {
      return 'SUPABASE_ANON_KEY is not set in .env file';
    }
    return '';
  }
}
