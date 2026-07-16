import 'package:apex_restaurant/core/settings/app_accent_colors.dart';
import 'package:apex_restaurant/core/settings/app_font_scale.dart';
import 'package:apex_restaurant/core/settings/settings_state.dart';
import 'package:apex_restaurant/core/shared/enums/ui_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsCubit extends Cubit<SettingsState> {
  static const _themeKey = 'settings.themeMode';
  static const _fontScaleKey = 'settings.fontScale';
  static const _accentColorKey = 'settings.accentColor';
  static const _uiScaleKey = 'settings.uiScale';

  final SharedPreferences prefs;

  SettingsCubit(this.prefs) : super(const SettingsState()) {
    _restore();
  }

  void _restore() {
    final themeIndex = prefs.getInt(_themeKey);
    final fontIndex = prefs.getInt(_fontScaleKey);
    final accentIndex = prefs.getInt(_accentColorKey);

    emit(
      state.copyWith(
        themeMode:
            themeIndex != null &&
                themeIndex >= 0 &&
                themeIndex < ThemeMode.values.length
            ? ThemeMode.values[themeIndex]
            : ThemeMode.system,
        fontScale:
            fontIndex != null &&
                fontIndex >= 0 &&
                fontIndex < AppFontScale.values.length
            ? AppFontScale.values[fontIndex]
            : AppFontScale.medium,
        accentColor:
            accentIndex != null &&
                accentIndex >= 0 &&
                accentIndex < AppAccentColor.values.length
            ? AppAccentColor.values[accentIndex]
            : AppAccentColor.primary,
      ),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
    await prefs.setInt(_themeKey, mode.index);
  }

  Future<void> toggleDarkMode(bool isDark) async {
    await setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> setFontScale(AppFontScale scale) async {
    emit(state.copyWith(fontScale: scale));
    await prefs.setInt(_fontScaleKey, scale.index);
  }

  Future<void> setAccentColor(AppAccentColor accent) async {
    emit(state.copyWith(accentColor: accent));
    await prefs.setInt(_accentColorKey, accent.index);
  }

  Future<void> reset() async {
    const state = SettingsState();

    emit(state);

    await Future.wait([
      prefs.setInt(_themeKey, state.themeMode.index),
      prefs.setInt(_fontScaleKey, state.fontScale.index),
      prefs.setInt(_accentColorKey, state.accentColor.index),
    ]);
  }

  Future<void> setUiScale(AppUiScale scale) async {
    emit(state.copyWith(uiScale: scale));
    await prefs.setDouble(_uiScaleKey, scale.scale);
  }
}
