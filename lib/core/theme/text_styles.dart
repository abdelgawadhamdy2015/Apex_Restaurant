import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/core/theme/font_weight_helper.dart';
import 'package:flutter/material.dart';

class TextStyles {
  static const double _defaultFontSize = 14;

  static TextStyle lighterGrayBoldStyle({
    double fontSize = _defaultFontSize,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: fontSize,
      fontWeight: FontWeightHelper.bold,
      color: AppColors.textSecondary,
    );
  }

  static TextStyle lighterGrayRegulerStyle({
    double fontSize = _defaultFontSize,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: fontSize,
      fontWeight: FontWeightHelper.reguler,
      color: AppColors.textSecondary,
    );
  }

  static TextStyle blackBoldStyle({
    double fontSize = _defaultFontSize,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: fontSize,
      fontWeight: FontWeightHelper.bold,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle blackRegulerStyle({
    double fontSize = _defaultFontSize,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: fontSize,
      fontWeight: FontWeightHelper.reguler,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle blackMediumStyle({
    double fontSize = _defaultFontSize,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: fontSize,
      fontWeight: FontWeightHelper.medium,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle blackSemiBoldStyle({
    double fontSize = _defaultFontSize,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: fontSize,
      fontWeight: FontWeightHelper.semiBold,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle lightRedRegulerStyle({
    double fontSize = _defaultFontSize,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: fontSize,
      fontWeight: FontWeightHelper.reguler,
      color: AppColors.error,
    );
  }

  static TextStyle lightGreenRegulerStyle({
    double fontSize = _defaultFontSize,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: fontSize,
      fontWeight: FontWeightHelper.reguler,
      color: AppColors.success,
    );
  }

  static TextStyle whiteRegulerStyle({
    double fontSize = _defaultFontSize,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: fontSize,
      fontWeight: FontWeightHelper.reguler,
      color: Colors.white,
    );
  }

  static TextStyle whiteBoldStyle({
    double fontSize = _defaultFontSize,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: fontSize,
      fontWeight: FontWeightHelper.bold,
      color: Colors.white,
    );
  }

  static TextStyle whiteSemiBoldStyle({
    double fontSize = _defaultFontSize,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: fontSize,
      fontWeight: FontWeightHelper.semiBold,
      color: Colors.white,
    );
  }

  static TextStyle whiteMediumStyle({
    double fontSize = _defaultFontSize,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: fontSize,
      fontWeight: FontWeightHelper.medium,
      color: Colors.white,
    );
  }

  static TextStyle darkBlueRegulerStyle({
    double fontSize = _defaultFontSize,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: fontSize,
      fontWeight: FontWeightHelper.reguler,
      color: AppColors.primary,
    );
  }

  static TextStyle darkBlueBoldStyle({
    double fontSize = _defaultFontSize,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: fontSize,
      fontWeight: FontWeightHelper.bold,
      color: AppColors.textPrimary,
    );
  }
}
