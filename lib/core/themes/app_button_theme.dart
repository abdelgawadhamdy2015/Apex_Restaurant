import 'package:flutter/material.dart';

@immutable
class AppButtonTheme extends ThemeExtension<AppButtonTheme> {
  final Color background;
  final Color iconColor;
  final Color subtitleColor;

  const AppButtonTheme({
    required this.background,
    required this.iconColor,
    required this.subtitleColor,
  });

  @override
  AppButtonTheme copyWith({
    Color? background,
    Color? backgroundSecondary,
    Color? iconTint,
    Color? subtitleColor,
  }) {
    return AppButtonTheme(
      background: background ?? this.background,
      iconColor: backgroundSecondary ?? this.iconColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
    );
  }

  @override
  AppButtonTheme lerp(ThemeExtension<AppButtonTheme>? other, double t) {
    if (other is! AppButtonTheme) return this;

    return AppButtonTheme(
      background: Color.lerp(background, other.background, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t)!,
    );
  }
}
