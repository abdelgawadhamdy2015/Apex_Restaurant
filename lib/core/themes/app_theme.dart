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
        AppExtraTheme(
          background: AppColors.background,
          secondaryBackground: AppColors.secondaryButtonColor,
          iconColor: AppColors.primaryLight,
          subtitleColor: AppColors.primaryLight,
          greenBackground: AppColors.green,
          cancelPorder: AppColors.cancelLightPorder,
          togelBackground: AppColors.blueTint,
          totalAmountColor: AppColors.white,
          successGradient: AppColors.lightSuceesGrad,
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
      datePickerTheme: _datePickerTheme(colorScheme),
      timePickerTheme: _timePickerTheme(colorScheme),
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
      surface: AppColors.darkSurfaceBackground,
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
      scaffoldBackgroundColor: AppColors.darkSurfaceBackground,
      colorScheme: colorScheme,
      extensions: [
        AppExtraTheme(
          background: AppColors.amber,
          secondaryBackground: AppColors.darkPorder,
          iconColor: AppColors.onPrimary,
          subtitleColor: AppColors.onPrimary,
          greenBackground: AppColors.green,
          cancelPorder: AppColors.cancelDarkPorder,
          togelBackground: AppColors.onSurface,
          totalAmountColor: accent.withOpacity(.2),
          successGradient: AppColors.darkSuceesGrad,
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
      datePickerTheme: _datePickerTheme(colorScheme),
      timePickerTheme: _timePickerTheme(colorScheme),
    );
  }

  static DatePickerThemeData _datePickerTheme(ColorScheme colorScheme) {
    return DatePickerThemeData(
      backgroundColor: colorScheme.surface,
      headerBackgroundColor: colorScheme.primary,
      headerForegroundColor: Colors.white,
      subHeaderForegroundColor: colorScheme.onPrimary,
      weekdayStyle: TextStyle(color: colorScheme.primary),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return colorScheme.onPrimary;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return null;
      }),
      todayForegroundColor: WidgetStatePropertyAll(colorScheme.primary),
      todayBackgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      todayBorder: BorderSide(color: colorScheme.primary),
      yearForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return null;
      }),
      yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.onPrimary;
      }),

      surfaceTintColor: Colors.transparent,
    );
  }

  static TimePickerThemeData _timePickerTheme(ColorScheme colorScheme) {
    return TimePickerThemeData(
      backgroundColor: colorScheme.surface,
      dialBackgroundColor: colorScheme.onPrimary,
      dialHandColor: colorScheme.primary,
      dialTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return colorScheme.onSurface;
      }),

      hourMinuteColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary.withOpacity(.15);
        }
        return colorScheme.onPrimary;
      }),
      hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.onSurface;
      }),
      dayPeriodColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary.withOpacity(0.15);
        }
        return Colors.transparent;
      }),
      dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.onPrimary;
      }),
      dayPeriodBorderSide: BorderSide(color: colorScheme.outlineVariant),
      entryModeIconColor: colorScheme.primary,
      helpTextStyle: TextStyle(color: colorScheme.onPrimary),
      //  surfaceTintColor: Colors.transparent,
    );
  }
}
