import 'package:apex_restaurant/core/settings/app_accent_colors.dart';
import 'package:apex_restaurant/core/settings/app_font_scale.dart';
import 'package:apex_restaurant/core/shared/enums/ui_enum.dart';
import 'package:flutter/material.dart' show ThemeMode;

class SettingsState {
  final ThemeMode themeMode;
  final AppFontScale fontScale;
  final AppAccentColor accentColor;

  /// Icon size across the app (small / medium / large).
  final AppIconScale iconScale;

  /// Spacing / density between items and card padding.
  /// 0.85 -> compact, 1.0 -> regular, 1.15 -> relaxed
  final AppUiScale uiScale;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.fontScale = AppFontScale.medium,
    this.accentColor = AppAccentColor.primary,
    this.iconScale = AppIconScale.medium,
    this.uiScale = AppUiScale.regular,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    AppFontScale? fontScale,
    AppAccentColor? accentColor,
    AppIconScale? iconScale,
    AppUiScale? uiScale,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      fontScale: fontScale ?? this.fontScale,
      accentColor: accentColor ?? this.accentColor,
      iconScale: iconScale ?? this.iconScale,
      uiScale: uiScale ?? this.uiScale,
    );
  }
}
