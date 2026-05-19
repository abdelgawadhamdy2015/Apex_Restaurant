import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/theme/colors.dart';
import 'package:apex_restaurant/core/theme/size_config.dart';
import 'package:flutter/material.dart';

import 'font_weight_helper.dart';

class TextStyles {
  static double factor = SizeConfig.isTablet
      ? 1.7
      : SizeConfig.screenWidth! > 375
      ? .7
      : 1;
  static TextStyle lighterGrayBoldStyle(double fontSize, {String? fontFamily}) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: (fontSize * factor),
      fontWeight: FontWeightHelper.bold,
      color: ColorManger.lighterGray,
    );
  }

  static TextStyle lighterGrayRegulerStyle(
    double fontSize, {
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: (fontSize * factor),
      fontWeight: FontWeightHelper.reguler,
      color: ColorManger.lighterGray,
    );
  }

  static TextStyle blackBoldStyle(double fontSize, {String? fontFamily}) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: (fontSize * factor),
      fontWeight: FontWeightHelper.bold,
      color: ColorManger.darkBlack,
    );
  }

  static TextStyle blackRegulerStyle(double fontSize, {String? fontFamily}) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: (fontSize * factor),
      fontWeight: FontWeightHelper.reguler,
      color: ColorManger.darkBlack,
    );
  }

  static TextStyle blackMediumStyle(double fontSize, {String? fontFamily}) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: (fontSize * factor),
      fontWeight: FontWeightHelper.medium,
      color: ColorManger.darkBlack,
    );
  }

  static TextStyle blackSemiBoldStyle(double fontSize, {String? fontFamily}) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: (fontSize * factor),
      fontWeight: FontWeightHelper.semiBold,
      color: ColorManger.darkBlack,
    );
  }

  static TextStyle lightRedRegulerStyle(double fontSize, {String? fontFamily}) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: (fontSize * factor),
      fontWeight: FontWeightHelper.reguler,
      color: ColorManger.lightred,
    );
  }

  static TextStyle lightGreenRegulerStyle(
    double fontSize, {
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: (fontSize * factor),
      fontWeight: FontWeightHelper.reguler,
      color: ColorManger.lightGreen,
    );
  }

  static TextStyle whiteRegulerStyle(double fontSize, {String? fontFamily}) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: (fontSize * factor),
      fontWeight: FontWeightHelper.reguler,
      color: Colors.white,
    );
  }

  static TextStyle whiteBoldStyle(double fontSize, {String? fontFamily}) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: (fontSize * factor),
      fontWeight: FontWeightHelper.bold,
      color: Colors.white,
    );
  }

  static TextStyle whiteSemiBoldStyle(double fontSize, {String? fontFamily}) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: (fontSize * factor),
      fontWeight: FontWeightHelper.semiBold,
      color: Colors.white,
    );
  }

  static TextStyle whiteMediumStyle(double fontSize, {String? fontFamily}) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: (fontSize * factor),
      fontWeight: FontWeightHelper.medium,
      color: Colors.white,
    );
  }

  static TextStyle darkBlueRegulerStyle(double fontSize, {String? fontFamily}) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: (fontSize * factor),
      fontWeight: FontWeightHelper.reguler,
      color: ColorManger.darkBlue,
    );
  }

  static TextStyle darkBlueBoldStyle(double fontSize, {String? fontFamily}) {
    return TextStyle(
      fontFamily: fontFamily ?? RestaurantConstants.cairoFont,
      fontSize: (fontSize * factor),
      fontWeight: FontWeightHelper.bold,
      color: ColorManger.darkBlue,
    );
  }
}
