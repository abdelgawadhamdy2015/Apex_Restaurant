import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme textTheme(double scale) {
    final baseFont = GoogleFonts.ibmPlexSansArabic();

    return TextTheme(
      displayLarge: baseFont.copyWith(
        fontSize: 32 * scale,
        fontWeight: FontWeight.bold,
      ),

      headlineLarge: baseFont.copyWith(
        fontSize: 28 * scale,
        fontWeight: FontWeight.bold,
      ),

      headlineMedium: baseFont.copyWith(
        fontSize: 24 * scale,
        fontWeight: FontWeight.w600,
      ),

      titleLarge: baseFont.copyWith(
        fontSize: 20 * scale,
        fontWeight: FontWeight.w600,
      ),

      titleMedium: baseFont.copyWith(
        fontSize: 18 * scale,
        fontWeight: FontWeight.w500,
      ),

      bodyLarge: baseFont.copyWith(fontSize: 16 * scale),

      bodyMedium: baseFont.copyWith(fontSize: 14 * scale),

      bodySmall: baseFont.copyWith(fontSize: 12 * scale),

      labelLarge: baseFont.copyWith(
        fontSize: 14 * scale,
        fontWeight: FontWeight.w600,
      ),

      labelMedium: baseFont.copyWith(fontSize: 12 * scale),
    );
  }
}
