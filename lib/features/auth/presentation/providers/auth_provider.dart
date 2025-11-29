import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

part 'auth_provider.g.dart';

/// Provider for AuthRepository
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl();
}

/// Authentication state provider
@riverpod
class Auth extends _$Auth {
  late final AuthRepository _repository;

  @override
  UserEntity? build() {
    _repository = ref.read(authRepositoryProvider);

    // Listen to auth state changes
    _repository.authStateChanges().listen((user) {
      state = user;
    });

    // Initialize with current user
    _initializeAuth();

    return null; // Initial state: no user
  }

  /// Initialize authentication state
  Future<void> _initializeAuth() async {
    final result = await _repository.getCurrentUser();
    result.fold(
      (failure) {
        // Handle error silently or log it
        state = null;
      },
      (user) {
        state = user;
      },
    );
  }

  /// Login with email and password
  Future<String?> login(String email, String password) async {
    final result = await _repository.signIn(email: email, password: password);

    return result.fold(
      (failure) {
        // Return error message
        return failure.message;
      },
      (user) {
        state = user;
        return null; // Success
      },
    );
  }

  /// Sign up with email and password
  Future<String?> signup(
    String name,
    String email,
    String password,
    String phone, {
    String? studentId,
    String? universityId,
  }) async {
    final result = await _repository.signUp(
      email: email,
      password: password,
      fullName: name,
      phone: phone,
      studentId: studentId,
      universityId: universityId,
    );

    return result.fold(
      (failure) {
        // Return error message
        return failure.message;
      },
      (user) {
        state = user;
        return null; // Success
      },
    );
  }

  /// Verify OTP code
  Future<String?> verifyOtp(String otp, String email) async {
    final result = await _repository.verifyOtp(email: email, otp: otp);

    return result.fold(
      (failure) {
        // Return error message
        return failure.message;
      },
      (user) {
        state = user;
        return null; // Success
      },
    );
  }

  /// Resend OTP code
  Future<String?> resendOtp(String email) async {
    final result = await _repository.resendOtp(email: email);

    return result.fold(
      (failure) {
        // Return error message
        return failure.message;
      },
      (_) {
        return null; // Success
      },
    );
  }

  /// Logout
  Future<String?> logout() async {
    final result = await _repository.signOut();

    return result.fold(
      (failure) {
        // Return error message
        return failure.message;
      },
      (_) {
        state = null;
        return null; // Success
      },
    );
  }

  /// Check if user is authenticated
  bool get isAuthenticated => state != null;

  /// Get current user
  UserEntity? get currentUser => state;
}
