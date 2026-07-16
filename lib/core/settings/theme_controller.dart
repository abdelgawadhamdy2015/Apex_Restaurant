import 'package:apex_restaurant/core/settings/app_accent_colors.dart';
import 'package:apex_restaurant/core/settings/settings_state.dart';
import 'package:apex_restaurant/core/themes/app_theme.dart';
import 'package:flutter/material.dart';

class AppThemeController {
  final SettingsState settings;

  const AppThemeController(this.settings);

  ThemeData get lightTheme => AppTheme.theme(
    settings.fontScale.scale,
    accent: settings.accentColor.color,
  );

  ThemeData get darkTheme => AppTheme.darkTheme(
    settings.fontScale.scale,
    accent: settings.accentColor.color,
  );

  ThemeMode get themeMode => settings.themeMode;
}
