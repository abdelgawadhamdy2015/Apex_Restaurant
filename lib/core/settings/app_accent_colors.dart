import '../themes/app_colors.dart';
import 'package:flutter/material.dart';

enum AppAccentColor { primary, amber, navy }

extension AppAccentColorX on AppAccentColor {
  Color get color {
    switch (this) {
      case AppAccentColor.primary:
        return AppColors.primaryLight;

      case AppAccentColor.amber:
        return AppColors.amber;

      case AppAccentColor.navy:
        return AppColors.navy;
    }
  }

  String get name {
    switch (this) {
      case AppAccentColor.primary:
        return 'Blue';

      case AppAccentColor.amber:
        return 'Amber';

      case AppAccentColor.navy:
        return 'Navy';
    }
  }
}
