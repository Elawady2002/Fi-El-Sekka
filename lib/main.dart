import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_app/features/auth/presentation/pages/onboarding_page.dart';
import 'core/theme/app_theme.dart';
import 'dart:async';
import 'dart:developer';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(const ProviderScope(child: MyApp()));
    },
    (error, stack) {
      log(
        'CRITICAL ERROR: Caught error in runZonedGuarded',
        error: error,
        stackTrace: stack,
        name: 'AppLaunch',
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fi El Sekka',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Localization Configuration
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'EG'), // Egyptian Arabic
      ],
      locale: const Locale('ar', 'EG'), // Force Arabic
      home: const OnboardingPage(),
    );
  }
}
