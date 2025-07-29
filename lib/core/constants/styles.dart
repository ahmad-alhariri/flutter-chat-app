// --- 2. Text Style Constants ---
// Using Noto Serif from Google Fonts. Make sure to add the `google_fonts` package to your pubspec.yaml

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final TextTheme _baseTextTheme = GoogleFonts.notoSerifTextTheme();

  static final TextTheme lightTextTheme = _baseTextTheme.apply(
    bodyColor: AppColors.lightOnBackground,
    displayColor: AppColors.lightOnBackground,
  ).copyWith(
    // You can override specific text styles here if needed.
    // Example:
    headlineLarge: _baseTextTheme.headlineLarge?.copyWith(
      fontWeight: FontWeight.bold,
      color: AppColors.lightPrimary,
    ),
  );

  static final TextTheme darkTextTheme = _baseTextTheme.apply(
    bodyColor: AppColors.darkOnBackground,
    displayColor: AppColors.darkOnBackground,
  ).copyWith(
    // Example override for dark theme
    titleMedium: _baseTextTheme.titleMedium?.copyWith(
      color: AppColors.darkPrimary,
    ),
  );
}