import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';
import 'otp_page.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppTheme.backgroundColor,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppTheme.backgroundColor,
        border: null,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "حساب جديد",
                style: AppTheme.textTheme.displayLarge?.copyWith(
                  color: Colors.black,
                ),
              ).animate().fadeIn().slideX(),
              const SizedBox(height: 8),
              Text(
                "انضم لينا وابدأ رحلتك.",
                style: AppTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(),
              const SizedBox(height: 32),
              const CustomInput(
                hintText: "الاسم بالكامل",
                prefixIcon: CupertinoIcons.person,
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 16),
              const CustomInput(
                hintText: "البريد الإلكتروني",
                prefixIcon: CupertinoIcons.mail,
                keyboardType: TextInputType.emailAddress,
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 16),
              const CustomInput(
                hintText: "رقم الموبايل",
                prefixIcon: CupertinoIcons.phone,
                keyboardType: TextInputType.phone,
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 16),
              const CustomInput(
                hintText: "كلمة السر",
                prefixIcon: CupertinoIcons.lock,
                isPassword: true,
                suffixIcon: Icon(
                  CupertinoIcons.eye_slash,
                  color: AppTheme.textSecondary,
                ),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 32),
              CustomButton(
                text: "إنشاء حساب",
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const OtpPage()),
                  );
                },
              ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "عندك حساب بالفعل؟ ",
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      decoration: TextDecoration.none,
                      decorationColor: Colors.transparent,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "سجل دخول",
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        decoration: TextDecoration.none,
                        decorationColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}
