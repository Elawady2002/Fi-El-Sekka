import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

/// Authentication wrapper that routes based on auth state
class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Give the auth provider time to initialize
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: OnboardingPage build called'); // Added print statement
    print('DEBUG: AuthWrapper build called. _isInitialized: $_isInitialized');
    final authState = ref.watch(authProvider);
    print('DEBUG: AuthWrapper authState: $authState');

    // Show loading screen while initializing
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // authState is UserEntity? - null means not authenticated
    // If null, show onboarding; if not null, show home page
    return authState != null ? const HomePage() : const OnboardingPage();
  }
}
