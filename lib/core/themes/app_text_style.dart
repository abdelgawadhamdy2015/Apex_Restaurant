import 'package:flutter/material.dart';

/// Semantic, pre-scaled text styles for card/list-style UI (CupCard, etc).
/// Colors that are theme-driven (accent, onSurface) are baked in at
/// ThemeData-build time so widgets never hardcode fontSize/weight/color.
@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  final TextStyle cardTitle; // header title on gradient — always white
  final TextStyle cardSubtitle; // header Arabic subtitle — follows accent
  final TextStyle badge; // small pill/badge text — color set per-status
  final TextStyle statLabel; // stat chip caption
  final TextStyle statValue; // stat chip value
  final TextStyle caption; // muted small caption (e.g. "Teams registered")
  final TextStyle captionBold; // emphasized small caption (e.g. "8/16")
  final TextStyle button; // action button label — color set per-button

  const AppTextStyles({
    required this.cardTitle,
    required this.cardSubtitle,
    required this.badge,
    required this.statLabel,
    required this.statValue,
    required this.caption,
    required this.captionBold,
    required this.button,
  });

  factory AppTextStyles.build({
    required double scale,
    required Color accent,
    required Color onSurface,
  }) {
    return AppTextStyles(
      cardTitle: TextStyle(
        fontSize: 15 * scale,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      cardSubtitle: TextStyle(
        fontSize: 12 * scale,
        color: accent.withOpacity(0.9),
      ),
      badge: TextStyle(fontSize: 10 * scale, fontWeight: FontWeight.w700),
      statLabel: TextStyle(
        fontSize: 9 * scale,
        fontWeight: FontWeight.w500,
        color: onSurface.withOpacity(0.6),
      ),
      statValue: TextStyle(
        fontSize: 11 * scale,
        fontWeight: FontWeight.w800,
        color: onSurface,
      ),
      caption: TextStyle(
        fontSize: 11 * scale,
        color: onSurface.withOpacity(0.6),
      ),
      captionBold: TextStyle(
        fontSize: 11 * scale,
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),
      button: TextStyle(
        fontSize: 13 * scale,
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),
    );
  }

  @override
  AppTextStyles copyWith({
    TextStyle? cardTitle,
    TextStyle? cardSubtitle,
    TextStyle? badge,
    TextStyle? statLabel,
    TextStyle? statValue,
    TextStyle? caption,
    TextStyle? captionBold,
    TextStyle? button,
  }) {
    return AppTextStyles(
      cardTitle: cardTitle ?? this.cardTitle,
      cardSubtitle: cardSubtitle ?? this.cardSubtitle,
      badge: badge ?? this.badge,
      statLabel: statLabel ?? this.statLabel,
      statValue: statValue ?? this.statValue,
      caption: caption ?? this.caption,
      captionBold: captionBold ?? this.captionBold,
      button: button ?? this.button,
    );
  }

  @override
  AppTextStyles lerp(ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) return this;
    return AppTextStyles(
      cardTitle: TextStyle.lerp(cardTitle, other.cardTitle, t)!,
      cardSubtitle: TextStyle.lerp(cardSubtitle, other.cardSubtitle, t)!,
      badge: TextStyle.lerp(badge, other.badge, t)!,
      statLabel: TextStyle.lerp(statLabel, other.statLabel, t)!,
      statValue: TextStyle.lerp(statValue, other.statValue, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      captionBold: TextStyle.lerp(captionBold, other.captionBold, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
    );
  }
}
