import 'app_accent_colors.dart';
import 'settings_state.dart';
import '../themes/app_theme.dart';
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
