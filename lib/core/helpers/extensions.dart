import 'restaurant_constants.dart';
import '../service/api_error_handler.dart';
import '../settings/settings_cubit.dart';
import '../shared/model/base_response.dart';
import '../themes/app_extra_theme.dart';
import '../themes/app_icon_theme.dart';
import '../themes/app_spacing_theme.dart';
import '../themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

extension AlertMessageExt on BaseResponse {
  String getLocalizedMessage({bool isSuccess = false}) {
    final isArabic = Intl.defaultLocale == RestaurantConstants.arabic;

    return isArabic
        ? alert?.messageAr ??
              (isSuccess
                  ? "تم الحفظ بنجاح"
                  : "فشل الحفظ. يرجى المحاولة مرة أخرى.")
        : alert?.messageEn ??
              (isSuccess
                  ? "Saved successfully"
                  : "Failed to save. Please try again.");
  }
}

extension ErrorMessageExt on ErrorHandler {
  String getLocalizedMessage() {
    final isArabic = Intl.defaultLocale == RestaurantConstants.arabic;

    return isArabic
        ? apiErrorModel.errorMessageAr ?? "حدث خطأ ما"
        : apiErrorModel.errorMessageEn ?? "An error occurred";
  }
}

extension ResponsiveContext on BuildContext {
  bool get isMobile => MediaQuery.sizeOf(this).width < 600;
  bool get isTablet =>
      MediaQuery.sizeOf(this).width >= 600 &&
      MediaQuery.sizeOf(this).width < 1100;
  bool get isDesktop => MediaQuery.sizeOf(this).width >= 1100;
}

extension UiScaleExtension on BuildContext {
  double get uiScale => watch<SettingsCubit>().state.uiScale.scale;
}

extension AppThemeContextX on BuildContext {
  AppSpacing get spacing =>
      Theme.of(this).extension<AppSpacing>() ?? AppSpacing.build(scale: 1);

  AppIconSizes get iconSizes =>
      Theme.of(this).extension<AppIconSizes>() ?? AppIconSizes.build(scale: 1);

  AppTextStyles get appTextStyles =>
      Theme.of(this).extension<AppTextStyles>() ??
      AppTextStyles.build(
        scale: 1,
        accent: Theme.of(this).colorScheme.primary,
        onSurface: Theme.of(this).colorScheme.onSurface,
      );

  AppExtraTheme get appExtraTheme => Theme.of(this).extension<AppExtraTheme>()!;
}
