import 'package:apex_restaurant/core/settings/app_accent_colors.dart';
import 'package:apex_restaurant/core/settings/app_font_scale.dart';
import 'package:apex_restaurant/core/shared/enums/ui_enum.dart';
import 'package:flutter/material.dart' show ThemeMode;

class SettingsState {
  final ThemeMode themeMode;
  final AppFontScale fontScale;
  final AppAccentColor accentColor;

  /// 0.8 -> Small
  /// 1.0 -> Medium
  /// 1.2 -> Large
  final AppUiScale uiScale;
  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.fontScale = AppFontScale.medium,
    this.accentColor = AppAccentColor.primary,
    this.uiScale = AppUiScale.compact,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    AppFontScale? fontScale,
    AppAccentColor? accentColor,
    AppUiScale? uiScale,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      fontScale: fontScale ?? this.fontScale,
      accentColor: accentColor ?? this.accentColor,
      uiScale: uiScale ?? this.uiScale,
    );
  }
}
