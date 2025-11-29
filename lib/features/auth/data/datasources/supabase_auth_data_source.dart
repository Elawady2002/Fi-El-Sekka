import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/supabase_config.dart';
import '../models/user_model.dart';

/// Supabase authentication data source
/// Handles all direct communication with Supabase Auth
class SupabaseAuthDataSource {
  final SupabaseClient _client;

  SupabaseAuthDataSource() : _client = SupabaseConfig.client;

  /// Sign up a new user with email and password
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    String? studentId,
    String? universityId,
  }) async {
    try {
      // Sign up with Supabase Auth
      final authResponse = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'phone': phone},
      );

      if (authResponse.user == null) {
        throw Exception('Failed to create user account');
      }

      final userId = authResponse.user!.id;
      final isVerified = authResponse.session != null;

      // Insert user data into users table and return it immediately
      final userData = {
        'id': userId,
        'email': email,
        'phone': phone,
        'full_name': fullName,
        'student_id': studentId,
        'university_id': universityId,
        'user_type': 'student', // Default to student
        'is_verified': isVerified,
        'created_at': DateTime.now().toIso8601String(),
      };

      try {
        await _client.from('users').insert(userData);

        // Return user from local data to avoid RLS race conditions
        return UserModel.fromJson(userData);
      } on PostgrestException catch (e) {
        // If insert fails (e.g. duplicate email or phone in public.users)
        if (e.code == '23505') {
          throw Exception(
            'بيانات مكررة (البريد الإلكتروني أو الهاتف) موجودة بالفعل في جدول المستخدمين. يرجى حذف البيانات القديمة.',
          );
        }
        rethrow;
      }
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } on PostgrestException catch (e) {
      if (e.message.contains('users_email_key')) {
        throw Exception('البريد الإلكتروني مسجل بالفعل. الرجاء تسجيل الدخول.');
      }
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during sign up: $e');
    }
  }

  /// Sign in an existing user with email and password
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Failed to sign in');
      }

      final userId = authResponse.user!.id;

      // Fetch user data from users table
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return UserModel.fromJson(response);
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        throw Exception(
          'بيانات الدخول غير صحيحة، أو لم يتم تفعيل البريد الإلكتروني.',
        );
      }
      throw Exception('Authentication error: ${e.message}');
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during sign in: $e');
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw Exception('Sign out error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during sign out: $e');
    }
  }

  /// Get the currently authenticated user
  Future<UserModel?> getCurrentUser() async {
    try {
      final session = _client.auth.currentSession;
      if (session == null) {
        return null;
      }

      final userId = session.user.id;

      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return UserModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      // No user authenticated
      return null;
    }
  }

  /// Stream of authentication state changes
  Stream<UserModel?> authStateChanges() {
    return _client.auth.onAuthStateChange.asyncMap((data) async {
      final session = data.session;
      if (session == null) {
        return null;
      }

      try {
        final userId = session.user.id;
        final response = await _client
            .from('users')
            .select()
            .eq('id', userId)
            .single();

        return UserModel.fromJson(response);
      } catch (e) {
        return null;
      }
    });
  }

  /// Verify OTP code
  Future<UserModel> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final authResponse = await _client.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.signup,
      );

      if (authResponse.user == null) {
        throw Exception('Failed to verify OTP');
      }

      final userId = authResponse.user!.id;

      // Update user verification status
      await _client
          .from('users')
          .update({'is_verified': true})
          .eq('id', userId);

      // Fetch updated user data
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return UserModel.fromJson(response);
    } on AuthException catch (e) {
      throw Exception('OTP verification error: ${e.message}');
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during OTP verification: $e');
    }
  }

  /// Resend OTP code
  Future<void> resendOtp({required String email}) async {
    try {
      await _client.auth.resend(type: OtpType.signup, email: email);
    } on AuthException catch (e) {
      throw Exception('Failed to resend OTP: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while resending OTP: $e');
    }
  }
}
