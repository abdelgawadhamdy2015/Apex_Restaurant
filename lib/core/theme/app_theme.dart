import 'package:apex_restaurant/core/theme/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

extension TextStyleX on TextStyle {
  TextStyle colored(Color color) => copyWith(color: color);
  TextStyle semiBold() => copyWith(fontWeight: FontWeight.w600);
  TextStyle bold() => copyWith(fontWeight: FontWeight.w700);
  TextStyle sized(double size) => copyWith(fontSize: size.sp);
}

class AppFonts {
  AppFonts._();

  // ─── Font Sizes (clamped for tablet) ──────────────────────────
  static double get xs => _sp(10, max: 12);
  static double get sm => _sp(12, max: 14);
  static double get md => _sp(14, max: 16);
  static double get lg => _sp(16, max: 18);
  static double get xl => _sp(18, max: 20);
  static double get xxl => _sp(22, max: 24);
  static double get xxxl => _sp(28, max: 30);

  // clamp helper — scales with screen but never exceeds max
  static double _sp(double size, {required double max}) =>
      size.sp.clamp(size * 0.85, max);

  // ─── Text Styles ──────────────────────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.cairo(
    fontSize: xxxl,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get displayMedium => GoogleFonts.cairo(
    fontSize: xxl,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleLarge => GoogleFonts.cairo(
    fontSize: xl,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.cairo(
    fontSize: lg,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleSmall => GoogleFonts.cairo(
    fontSize: md,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.cairo(
    fontSize: _sp(15, max: 16),
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.cairo(
    fontSize: sm,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodySmall => GoogleFonts.cairo(
    fontSize: xs,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static TextStyle get labelLarge => GoogleFonts.cairo(
    fontSize: md,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
}

class AppSizes {
  AppSizes._(); // Prevent instantiation

  // ─── Screen ───────────────────────────────────────────────────
  static double get screenWidth => ScreenUtil().screenWidth;
  static double get screenHeight => ScreenUtil().screenHeight;

  // ─── Fractions of screen ──────────────────────────────────────
  static double wFraction(double fraction) => screenWidth * fraction;
  static double hFraction(double fraction) => screenHeight * fraction;

  // ─── Fixed Widths (responsive) ────────────────────────────────
  static double get w4 => 4.w;
  static double get w8 => 8.w;
  static double get w12 => 12.w;
  static double get w16 => 16.w;
  static double get w20 => 20.w;
  static double get w24 => 24.w;
  static double get w32 => 32.w;
  static double get w40 => 40.w;
  static double get w48 => 48.w;
  static double get w64 => 64.w;
  static double get w80 => 80.w;
  static double get w100 => 100.w;
  static double get w120 => 120.w;
  static double get w160 => 160.w;
  static double get w200 => 200.w;

  // ─── Fixed Heights (responsive) ───────────────────────────────
  static double get h4 => 4.h;
  static double get h8 => 8.h;
  static double get h12 => 12.h;
  static double get h16 => 16.h;
  static double get h20 => 20.h;
  static double get h24 => 24.h;
  static double get h32 => 32.h;
  static double get h40 => 40.h;
  static double get h48 => 48.h;
  static double get h56 => 56.h;
  static double get h64 => 64.h;
  static double get h80 => 80.h;
  static double get h100 => 100.h;
  static double get h120 => 120.h;
  static double get h160 => 160.h;
  static double get h200 => 200.h;

  // ─── Common UI Components ─────────────────────────────────────
  static double get buttonHeight => 52.h;
  static double get buttonHeightSm => 40.h;
  static double get inputHeight => 52.h;
  static double get appBarHeight => 60.h;
  static double get bottomNavHeight => 65.h;
  static double get iconSm => 16.w;
  static double get iconMd => 20.w;
  static double get iconLg => 24.w;
  static double get iconXl => 32.w;
  static double get avatarSm => 32.w;
  static double get avatarMd => 48.w;
  static double get avatarLg => 64.w;
  static double get imageSm => 60.w;
  static double get imageMd => 100.w;
  static double get imageLg => 140.w;

  // ─── SizedBox Gaps (most common use case) ─────────────────────
  static Widget get gapW4 => SizedBox(width: w4);
  static Widget get gapW8 => SizedBox(width: w8);
  static Widget get gapW12 => SizedBox(width: w12);
  static Widget get gapW16 => SizedBox(width: w16);
  static Widget get gapW20 => SizedBox(width: w20);
  static Widget get gapW24 => SizedBox(width: w24);

  static Widget get gapH4 => SizedBox(height: h4);
  static Widget get gapH8 => SizedBox(height: h8);
  static Widget get gapH12 => SizedBox(height: h12);
  static Widget get gapH16 => SizedBox(height: h16);
  static Widget get gapH20 => SizedBox(height: h20);
  static Widget get gapH24 => SizedBox(height: h24);
  static Widget get gapH32 => SizedBox(height: h32);
  static Widget get gapH48 => SizedBox(height: h48);
}

class AppPadding {
  AppPadding._(); // Prevent instantiation

  // ─── Raw Values (responsive) ───────────────────────────────────
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 12.w;
  static double get lg => 16.w;
  static double get xl => 20.w;
  static double get xxl => 24.w;
  static double get xxxl => 32.w;

  // ─── Symmetric ────────────────────────────────────────────────
  static EdgeInsets get horizontalSm => EdgeInsets.symmetric(horizontal: sm);
  static EdgeInsets get horizontalMd => EdgeInsets.symmetric(horizontal: md);
  static EdgeInsets get horizontalLg => EdgeInsets.symmetric(horizontal: lg);
  static EdgeInsets get horizontalXl => EdgeInsets.symmetric(horizontal: xl);

  static EdgeInsets get verticalSm => EdgeInsets.symmetric(vertical: sm);
  static EdgeInsets get verticalMd => EdgeInsets.symmetric(vertical: md);
  static EdgeInsets get verticalLg => EdgeInsets.symmetric(vertical: lg);
  static EdgeInsets get verticalXl => EdgeInsets.symmetric(vertical: xl);

  // ─── All Sides ────────────────────────────────────────────────
  static EdgeInsets get allXs => EdgeInsets.all(xs);
  static EdgeInsets get allSm => EdgeInsets.all(sm);
  static EdgeInsets get allMd => EdgeInsets.all(md);
  static EdgeInsets get allLg => EdgeInsets.all(lg);
  static EdgeInsets get allXl => EdgeInsets.all(xl);
  static EdgeInsets get allXxl => EdgeInsets.all(xxl);

  // ─── Screen Padding (replaces SizeConfig.getScreenPadding) ────
  static EdgeInsets get screen =>
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);

  static EdgeInsets get screenHorizontal =>
      EdgeInsets.symmetric(horizontal: 16.w);
  static EdgeInsets get screenVertical => EdgeInsets.symmetric(vertical: 12.h);
}

class AppColors {
  // Primary
  static const Color primary = Color(0xFF0353A4);
  static const Color primaryDark = Color(0xFF0F1A3D);
  static const Color primaryLight = Color(0xFF2D4A9E);
  static const Color accent = Color(0xFF2563EB);

  static const Color selectedColor = Color(0xFFB5D4F4);
  static const Color unSelectedColor = Color(0xFFF0F0F0);

  // Semantic
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF4F6FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Sidebar
  static const Color sidebarBg = Color(0xFFFFFFFF);
  static const Color sidebarActive = Color(0xFFEFF6FF);
  static const Color sidebarActiveBorder = Color(0xFF2563EB);

  // Category badge
  static const Color priceBadge = Color(0xFF1A2B5E);
  static const Color priceBadgeText = Color(0xFFFFFFFF);
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double full = 100.0;
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: GoogleFonts.cairoTextTheme().copyWith(
      displayLarge: GoogleFonts.cairo(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      displayMedium: GoogleFonts.cairo(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.cairo(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.cairo(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleSmall: GoogleFonts.cairo(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.cairo(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.cairo(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.cairo(
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      ),
      labelLarge: GoogleFonts.cairo(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        minimumSize: const Size(double.infinity, 52),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 0,
    ),
    iconTheme: IconThemeData(
      color: AppColors.textPrimary,
      size: SizeConfig.iconSize1!,
    ),
  );
}
