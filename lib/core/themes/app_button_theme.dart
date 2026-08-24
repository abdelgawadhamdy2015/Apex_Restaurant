import 'package:flutter/material.dart';

@immutable
class AppExtraTheme extends ThemeExtension<AppExtraTheme> {
  final Color background;
  final Color secondaryBackground;

  final Color iconColor;
  final Color subtitleColor;
  final Color greenBackground;
  final Color cancelPorder;
  final Color togelBackground;
  final Color totalAmountColor;
  final Gradient successGradient;
  const AppExtraTheme({
    required this.background,
    required this.iconColor,
    required this.subtitleColor,
    required this.greenBackground,
    required this.cancelPorder,
    required this.togelBackground,
    required this.secondaryBackground,
    required this.totalAmountColor,
    required this.successGradient,
  });

  @override
  AppExtraTheme copyWith({
    Color? background,
    Color? secondaryBackground,
    Color? iconColor,
    Color? greenBackground,
    Color? subtitleColor,
    Color? cancelPorder,
    Color? togelBackground,
    Color? totalAmountColor,
    Gradient? successGradient,
  }) {
    return AppExtraTheme(
      background: background ?? this.background,
      iconColor: iconColor ?? this.iconColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      greenBackground: greenBackground ?? this.greenBackground,
      cancelPorder: cancelPorder ?? this.cancelPorder,
      togelBackground: togelBackground ?? this.togelBackground,
      secondaryBackground: secondaryBackground ?? this.secondaryBackground,
      totalAmountColor: totalAmountColor ?? this.totalAmountColor,
      successGradient: successGradient ?? this.successGradient,
    );
  }

  @override
  AppExtraTheme lerp(ThemeExtension<AppExtraTheme>? other, double t) {
    if (other is! AppExtraTheme) return this;

    return AppExtraTheme(
      background: Color.lerp(background, other.background, t)!,
      secondaryBackground: Color.lerp(
        secondaryBackground,
        other.secondaryBackground,
        t,
      )!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t)!,
      greenBackground: Color.lerp(greenBackground, other.greenBackground, t)!,
      cancelPorder: Color.lerp(cancelPorder, other.cancelPorder, t)!,
      togelBackground: Color.lerp(togelBackground, other.togelBackground, t)!,
      totalAmountColor: Color.lerp(
        totalAmountColor,
        other.totalAmountColor,
        t,
      )!,
      successGradient: Gradient.lerp(
        successGradient,
        other.successGradient,
        t,
      )!,
    );
  }
}
