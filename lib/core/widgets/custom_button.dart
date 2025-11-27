import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ios_components.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: IOSButton(
        text: text,
        onPressed: onPressed,
        isLoading: isLoading,
        color: backgroundColor,
        textColor: textColor,
      ),
    );
  }
}
