import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/paths.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthLogoWidget extends StatelessWidget {
  const AuthLogoWidget({
    super.key,
    required this.textTheme,
    required this.colorScheme,
    required this.text, required this.subText,
  });

  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final String text;
  final String subText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(logo, height: 100.h),
        Text(
          text,
          style: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground,
          ),
        ),
        Text(
          subText,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onBackground.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
