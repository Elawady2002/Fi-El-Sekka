import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';
import '../providers/auth_provider.dart';
import 'signup_page.dart';
import '../../../home/presentation/pages/home_page.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      backgroundColor: AppTheme.backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                "أهلاً بيك!",
                style: AppTheme.textTheme.displayLarge?.copyWith(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ).animate().fadeIn().slideX(),
              const SizedBox(height: 8),
              Text(
                "سجل دخولك عشان تكمل رحلتك.",
                style: AppTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(),
              const SizedBox(height: 48),
              CustomInput(
                hintText: "رقم الموبايل",
                keyboardType: TextInputType.phone,
                prefixIcon: CupertinoIcons.phone,
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 16),
              CustomInput(
                hintText: "كلمة السر",
                isPassword: true,
                prefixIcon: CupertinoIcons.lock,
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft, // Changed for RTL
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "نسيت كلمة السر؟",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 24),
              CustomButton(
                text: "تسجيل الدخول",
                onPressed: () async {
                  try {
                    await ref
                        .read(authProvider.notifier)
                        .login('user@example.com', 'password');
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(builder: (_) => const HomePage()),
                      );
                    }
                  } catch (e) {
                    // Handle error
                  }
                },
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "معندكش حساب؟ ",
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      decoration: TextDecoration.none,
                      decorationColor: Colors.transparent,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                      );
                    },
                    child: Text(
                      "سجل دلوقتي",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        decoration: TextDecoration.none,
                        decorationColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 700.ms),
            ],
          ),
        ),
      ),
    );
  }
}
