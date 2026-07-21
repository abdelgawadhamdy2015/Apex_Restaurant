// lib/core/themes/app_spacing_theme.dart
import 'dart:ui';
import 'package:flutter/material.dart';

/// Semantic, pre-scaled spacing & radius tokens.
/// Never hardcode EdgeInsets/SizedBox/BorderRadius numbers in widgets again —
/// pull them from here (via `context.spacing`) so the whole app can be
/// tightened or loosened from one Settings toggle (AppUiScale).
@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  final double xxs; // 4  - hairline gaps (icon <-> text)
  final double xs; // 8  - tight gaps (chip padding, row gaps)
  final double sm; // 12 - default inner card padding
  final double md; // 16 - default screen/card padding
  final double lg; // 20 - section gaps
  final double xl; // 24 - large section gaps
  final double xxl; // 32 - page-level gaps

  final double radiusSm; // 8  - inputs, small chips
  final double radiusMd; // 10 - buttons, cards
  final double radiusLg; // 12 - cards, sheets
  final double radiusPill; // 24 - pill/segmented chips

  const AppSpacing({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusPill,
  });

  /// [scale] comes from Settings (AppUiScale.scale), so users can pick
  /// compact / regular / relaxed density.
  factory AppSpacing.build({required double scale}) {
    return AppSpacing(
      xxs: 4 * scale,
      xs: 8 * scale,
      sm: 12 * scale,
      md: 16 * scale,
      lg: 20 * scale,
      xl: 24 * scale,
      xxl: 32 * scale,
      radiusSm: 8 * scale,
      radiusMd: 10 * scale,
      radiusLg: 12 * scale,
      radiusPill: 24 * scale,
    );
  }

  @override
  AppSpacing copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? radiusPill,
  }) {
    return AppSpacing(
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      radiusPill: radiusPill ?? this.radiusPill,
    );
  }

  @override
  AppSpacing lerp(ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) return this;
    return AppSpacing(
      xxs: lerpDouble(xxs, other.xxs, t)!,
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
      radiusSm: lerpDouble(radiusSm, other.radiusSm, t)!,
      radiusMd: lerpDouble(radiusMd, other.radiusMd, t)!,
      radiusLg: lerpDouble(radiusLg, other.radiusLg, t)!,
      radiusPill: lerpDouble(radiusPill, other.radiusPill, t)!,
    );
  }
}
