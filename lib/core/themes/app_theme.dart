import 'package:apex_restaurant/core/themes/app_header_theme.dart';
import 'package:apex_restaurant/core/themes/app_icon_theme.dart';
import 'package:apex_restaurant/core/themes/app_spacing_theme.dart';
import 'package:apex_restaurant/core/themes/app_status_theme.dart';
import 'package:apex_restaurant/core/themes/app_text_style.dart';
import 'package:apex_restaurant/core/themes/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData theme(
    double fontScale, {
    Color accent = AppColors.primary,
    double spacingScale = 1.0,
    double iconScale = 1.0,
  }) {
    final colorScheme = ColorScheme.light(
      primary: accent,
      onPrimary: Colors.white,
      secondary: AppColors.amber,
      error: AppColors.error,
      errorContainer: AppColors.errorContainer,
      surface: AppColors.surface,
      outlineVariant: AppColors.border,
    );

    final baseTextTheme = AppTypography.textTheme(fontScale);
    final textTheme = GoogleFonts.ibmPlexSansArabicTextTheme(baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.canvas,
      colorScheme: colorScheme,
      extensions: [
        const AppHeaderTheme(
          background: AppColors.navy,
          backgroundSecondary: AppColors.navyLight,
          iconTint: AppColors.primary,
          subtitleColor: AppColors.primaryVariant,
        ),
        const AppStatusTheme(
          registrationOpen: AppColors.success,
          groupStage: AppColors.primary,
          knockoutStage: AppColors.amber,
          completed: AppColors.tealLight,
          fallback: Colors.black38,
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
          color: AppColors.textSecondary,
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
    Color accent = AppColors.primary,
    double spacingScale = 1.0,
    double iconScale = 1.0,
  }) {
    final colorScheme = ColorScheme.dark(
      primary: accent,
      onPrimary: Colors.white,
      secondary: AppColors.amber,
      error: AppColors.error,
      errorContainer: AppColors.errorContainer,

      surface: const Color(0xFF1E293B),
      onSurface: Colors.white,
      outlineVariant: AppColors.border,
      secondaryContainer: const Color(0xFF0F172A),
    );

    final baseTextTheme = AppTypography.textTheme(fontScale);
    final textTheme = GoogleFonts.ibmPlexSansArabicTextTheme(
      baseTextTheme,
    ).apply(bodyColor: Colors.white, displayColor: Colors.white);

    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      colorScheme: colorScheme,
      extensions: [
        AppHeaderTheme(
          background: const Color(0xFF1E293B),
          backgroundSecondary: const Color(0xFF334155),
          iconTint: accent,
          subtitleColor: Colors.white70,
        ),
        const AppStatusTheme(
          registrationOpen: Color(0xFF10B981),
          groupStage: Color(0xFF3B82F6),
          knockoutStage: Color(0xFFF59E0B),
          completed: Color(0xFF64748B),
          fallback: Colors.white38,
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
