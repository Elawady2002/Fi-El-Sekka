import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  bool build() {
    return false; // Initial state: not logged in
  }

  Future<void> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    state = true;
  }

  Future<void> signup(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    // After signup, we might want to login or verify OTP
  }

  Future<void> verifyOtp(String otp) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    state = true;
  }

  void logout() {
    state = false;
  }
}
