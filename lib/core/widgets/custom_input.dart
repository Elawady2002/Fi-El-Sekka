import 'package:flutter/cupertino.dart';

import '../theme/app_theme.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const CustomInput({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CupertinoTextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        placeholder: hintText,
        placeholderStyle: const TextStyle(color: CupertinoColors.systemGrey),
        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        prefix: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(prefixIcon, color: CupertinoColors.systemGrey),
              )
            : null,
        suffix: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12),
                child: suffixIcon,
              )
            : null,
      ),
    );
  }
}
