import 'package:apex_restaurant/core/themes/app_button_theme.dart';
import 'package:apex_restaurant/core/themes/app_icon_theme.dart';
import 'package:apex_restaurant/core/themes/app_spacing_theme.dart';
import 'package:apex_restaurant/core/themes/app_text_style.dart';
import 'package:apex_restaurant/core/themes/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData theme(
    double fontScale, {
    Color accent = AppColors.primaryLight,
    double spacingScale = 1.0,
    double iconScale = 1.0,
  }) {
    final colorScheme = ColorScheme.light(
      primary: accent,
      onPrimary: AppColors.textPrimary,
      secondary: AppColors.amber,
      error: AppColors.error,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.canvas,
      onSurface: AppColors.white,
      outlineVariant: AppColors.border,
      onSecondary: AppColors.lightTextSecondery,
    );

    final baseTextTheme = AppTypography.textTheme(fontScale);
    final textTheme = GoogleFonts.ibmPlexSansArabicTextTheme(baseTextTheme)
        .apply(
          bodyColor: AppColors.black,
          displayColor: Colors.black.withOpacity(.8),
        );
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.canvas,
      colorScheme: colorScheme,
      extensions: [
        AppButtonTheme(
          background: AppColors.background,
          iconColor: AppColors.primaryLight,
          subtitleColor: AppColors.primaryLight,
        ),
        AppTextStyles.build(
          scale: fontScale,
          accent: accent,
          onSurface: colorScheme.onSurface,
        ),
        AppSpacing.build(scale: spacingScale),
        AppIconSizes.build(scale: iconScale),
      ],
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16 * spacingScale,
          vertical: 14 * spacingScale,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10 * spacingScale),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10 * spacingScale),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10 * spacingScale),
          borderSide: BorderSide(color: accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10 * spacingScale),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10 * spacingScale),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: GoogleFonts.ibmPlexSansArabic(
          color: AppColors.darkTextSecondary,
          fontSize: 14 * fontScale,
        ),
        hintStyle: GoogleFonts.ibmPlexSansArabic(
          color: const Color(0xFFB0BBC8),
          fontSize: 14 * fontScale,
        ),
      ),
    );
  }

  static ThemeData darkTheme(
    double fontScale, {
    Color accent = AppColors.primaryDark,
    double spacingScale = 1.0,
    double iconScale = 1.0,
  }) {
    final colorScheme = ColorScheme.dark(
      primary: accent,
      onPrimary: Colors.white,
      secondary: AppColors.amber,
      error: AppColors.error,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.containerBackground,
      onSurface: AppColors.onSurface,
      outlineVariant: AppColors.darkPorder,
      onSecondary: AppColors.darkTextSecondary,
    );

    final baseTextTheme = AppTypography.textTheme(fontScale);
    final textTheme = GoogleFonts.ibmPlexSansArabicTextTheme(baseTextTheme)
        .apply(
          bodyColor: Colors.white,
          displayColor: Colors.white.withOpacity(.8),
        );

    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      colorScheme: colorScheme,
      extensions: [
        AppButtonTheme(
          background: AppColors.amber,
          iconColor: AppColors.onPrimary,
          subtitleColor: AppColors.onPrimary,
        ),
        AppTextStyles.build(
          scale: fontScale,
          accent: accent,
          onSurface: colorScheme.onSurface,
        ),
        AppSpacing.build(scale: spacingScale),
        AppIconSizes.build(scale: iconScale),
      ],
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16 * spacingScale,
          vertical: 14 * spacingScale,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10 * spacingScale),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10 * spacingScale),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10 * spacingScale),
          borderSide: BorderSide(color: accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10 * spacingScale),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10 * spacingScale),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: GoogleFonts.ibmPlexSansArabic(
          color: Colors.white70,
          fontSize: 14 * fontScale,
        ),
        hintStyle: GoogleFonts.ibmPlexSansArabic(
          color: Colors.white38,
          fontSize: 14 * fontScale,
        ),
      ),
    );
  }
}
