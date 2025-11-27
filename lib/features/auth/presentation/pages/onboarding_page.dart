import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import 'login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    super.initState();
    // Splash screen removed as requested by user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              // Illustration placeholder (using an icon for now if SVG not available,
              // but code assumes SVG asset will be added or we use a placeholder icon)
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.directions_bus_filled_rounded,
                  size: 100,
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                ),
              ),
              const Spacer(),
              Text(
                "جامعتك،\nمشوارك",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.black,
                  height: 1.2,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "توصيل سهل لطلاب الجامعات. احجز رحلتك، تابع الباص، واوصل في ميعادك.",
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
              ),
              const Spacer(),
              CustomButton(
                text: "يلا بينا",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
