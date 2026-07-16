import 'package:flutter/material.dart';

@immutable
class AppHeaderTheme extends ThemeExtension<AppHeaderTheme> {
  final Color background;
  final Color backgroundSecondary;
  final Color iconTint;
  final Color subtitleColor;

  const AppHeaderTheme({
    required this.background,
    required this.backgroundSecondary,
    required this.iconTint,
    required this.subtitleColor,
  });

  @override
  AppHeaderTheme copyWith({
    Color? background,
    Color? backgroundSecondary,
    Color? iconTint,
    Color? subtitleColor,
  }) {
    return AppHeaderTheme(
      background: background ?? this.background,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      iconTint: iconTint ?? this.iconTint,
      subtitleColor: subtitleColor ?? this.subtitleColor,
    );
  }

  @override
  AppHeaderTheme lerp(ThemeExtension<AppHeaderTheme>? other, double t) {
    if (other is! AppHeaderTheme) return this;

    return AppHeaderTheme(
      background: Color.lerp(background, other.background, t)!,
      backgroundSecondary: Color.lerp(
        backgroundSecondary,
        other.backgroundSecondary,
        t,
      )!,
      iconTint: Color.lerp(iconTint, other.iconTint, t)!,
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t)!,
    );
  }
}
