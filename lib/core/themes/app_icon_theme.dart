// lib/core/themes/app_icon_theme.dart
import 'dart:ui';
import 'package:flutter/material.dart';

/// Semantic, pre-scaled icon sizes. Pull these via `context.iconSizes`
/// instead of writing `Icon(x, size: 18)` anywhere in the app.
@immutable
class AppIconSizes extends ThemeExtension<AppIconSizes> {
  final double xs; // 16 - inline row icons (qty +/-)

  final double sm; // 16 - inline row icons (qty +/-)
  final double md; // 20 - default action icons
  final double lg; // 24 - primary buttons / avatars
  final double xl; // 32 - empty states / headers

  const AppIconSizes({
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xs,
  });

  /// [scale] comes from Settings (AppIconScale.scale).
  factory AppIconSizes.build({required double scale}) {
    return AppIconSizes(
      xs: 12 * scale,
      sm: 16 * scale,
      md: 20 * scale,
      lg: 24 * scale,
      xl: 32 * scale,
    );
  }

  @override
  AppIconSizes copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
  }) {
    return AppIconSizes(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }

  @override
  AppIconSizes lerp(ThemeExtension<AppIconSizes>? other, double t) {
    if (other is! AppIconSizes) return this;
    return AppIconSizes(
      xs: lerpDouble(xs, other.xs, t)!,

      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
    );
  }
}
