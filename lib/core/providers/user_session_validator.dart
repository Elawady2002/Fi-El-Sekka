import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../services/logger_service.dart';

/// Provider that monitors app lifecycle and verifies user session validity
/// when the app returns to the foreground.
final userSessionValidatorProvider = Provider<void>((ref) {
  // Access the auth provider to enable ref.invalidate
  
  // Create a listener for lifecycle changes
  final observer = _AppLifecycleObserver(
    onResumed: () async {
      // Check if user is logged in
      final asyncUser = ref.read(authProvider);
      
      // We only care if we have data and it's not null
      asyncUser.whenData((user) {
        if (user != null) {
          LoggerService.info('SessionValidator: App resumed, verifying user existence for ${user.id}');
          // Invalidating authProvider will force a re-fetch from Supabase, 
          // which will trigger the strict logout logic if the user is missing.
          ref.invalidate(authProvider);
        }
      });
    },
  );

  WidgetsBinding.instance.addObserver(observer);
  
  ref.onDispose(() {
    WidgetsBinding.instance.removeObserver(observer);
  });
});

class _AppLifecycleObserver extends WidgetsBindingObserver {
  final VoidCallback onResumed;

  _AppLifecycleObserver({required this.onResumed});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    }
  }
}
